/* drivers/input/sensors/access/sh3001_acc.c
 *
 * Copyright (C) 2012-2015 ALIENTEK.
 * Author: dengtao<dengtao@alientek.com>
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */
#include <linux/interrupt.h>
#include <linux/i2c.h>
#include <linux/slab.h>
#include <linux/irq.h>
#include <linux/miscdevice.h>
#include <linux/gpio.h>
#include <linux/uaccess.h>
#include <asm/atomic.h>
#include <linux/delay.h>
#include <linux/input.h>
#include <linux/workqueue.h>
#include <linux/freezer.h>
#include <linux/of_gpio.h>
#ifdef CONFIG_HAS_EARLYSUSPEND
#include <linux/earlysuspend.h>
#endif
#include <linux/sensor-dev.h>
#include <linux/sh3001.h>


typedef enum sh3001_power_mode {
	SH3001_PM_NORMAL,
	SH3001_PM_SLEEP,
	SH3001_PM_POWERDOWN,
	SH3001_PM_ACC_NORMAL,
} sh3001_pmode_t;

static unsigned char storeAccODR;

static int sh3001_write_reg(struct i2c_client *client, u8 addr, u8 data)
{
	struct i2c_msg msg;
	u8 buf[2];
	int ret;

	buf[0] = addr;	//寄存器地址
	buf[1] = data;	//要写入寄存器中的数据

	msg.flags = !I2C_M_RD;	//写
	msg.addr  = client->addr;//器件地址
	msg.len   = 2;
	msg.buf   = buf;

	ret = i2c_transfer(client->adapter, &msg, 1);
	if (ret == 1)
		return 0;
	else
		return -1;
}

static int sh3001_read_reg(struct i2c_client *client, u8 addr, u8 *buf)
{
	struct i2c_msg msgs[2];
	int ret;

	msgs[0].flags = !I2C_M_RD;	//写
	msgs[0].addr  = client->addr;//器件地址
	msgs[0].len   = 1;
	msgs[0].buf   = &addr;

	msgs[1].flags = I2C_M_RD;	//读
	msgs[1].addr  = client->addr;//器件地址
	msgs[1].len   = 1;
	msgs[1].buf   = buf;

	ret = i2c_transfer(client->adapter, msgs, 2);
	if (ret == 2)
		return 0;
	else
		return -1;
}

static int sh3001_read_regs(struct i2c_client *client, u8 addr, int len, u8 *buf)
{
	struct i2c_msg msgs[2];
	int ret;

	msgs[0].flags = !I2C_M_RD;	//写
	msgs[0].addr  = client->addr;//器件地址
	msgs[0].len   = 1;
	msgs[0].buf   = &addr;

	msgs[1].flags = I2C_M_RD;	//读
	msgs[1].addr  = client->addr;//器件地址
	msgs[1].len   = len;		//读取的数据长度
	msgs[1].buf   = buf;

	ret = i2c_transfer(client->adapter, msgs, 2);
	if (ret == 2)
		return 0;
	else
		return -1;
}

static int sh3001_module_reset_mcc(struct i2c_client *client)
{
	unsigned char regAddr[9] = {0xC0, 0xD3, 0xC2, 0xD3, 0xD5, 0xD4, 0xBB, 0xB9, 0xBA};
	unsigned char regDataA[9] = {0x38, 0xC6, 0x10, 0xC1, 0x02, 0x0C, 0x18, 0x18, 0x18};
	unsigned char regDataB[9] = {0x3D, 0xC2, 0x20, 0xC2, 0x00, 0x04, 0x00, 0x00, 0x00};

	//Drive Start
	sh3001_write_reg(client, regAddr[0], regDataA[0]);
	sh3001_write_reg(client, regAddr[1], regDataA[1]);
	sh3001_write_reg(client, regAddr[2], regDataA[2]);
	msleep(300);
	sh3001_write_reg(client, regAddr[0], regDataB[0]);
	sh3001_write_reg(client, regAddr[1], regDataB[1]);
	sh3001_write_reg(client, regAddr[2], regDataB[2]);
	msleep(100);

	//ADC Reset
	sh3001_write_reg(client, regAddr[3], regDataA[3]);
	sh3001_write_reg(client, regAddr[4], regDataA[4]);
	msleep(1);
	sh3001_write_reg(client, regAddr[3], regDataB[3]);
	msleep(1);
	sh3001_write_reg(client, regAddr[4], regDataB[4]);
	msleep(50);

	//CVA Reset
	sh3001_write_reg(client, regAddr[5], regDataA[5]);
	msleep(10);
	sh3001_write_reg(client, regAddr[5], regDataB[5]);

	msleep(1);

	sh3001_write_reg(client, regAddr[6], regDataA[6]);
	msleep(10);
	sh3001_write_reg(client, regAddr[7], regDataA[7]);
	msleep(10);
	sh3001_write_reg(client, regAddr[8], regDataA[8]);
	msleep(10);
	sh3001_write_reg(client, regAddr[6], regDataB[6]);
	msleep(10);
	sh3001_write_reg(client, regAddr[7], regDataB[7]);
	msleep(10);
	sh3001_write_reg(client, regAddr[8], regDataB[8]);
	msleep(10);

	return 0;
}

static int sh3001_module_reset_mcd(struct i2c_client *client)
{
	unsigned char regAddr[9] = {0xC0, 0xD3, 0xC2, 0xD3, 0xD5, 0xD4, 0xBB, 0xB9, 0xBA};
	unsigned char regDataA[9] = {0x38, 0xD6, 0x10, 0xD1, 0x02, 0x08, 0x18, 0x18, 0x18};
	unsigned char regDataB[9] = {0x3D, 0xD2, 0x20, 0xD2, 0x00, 0x00, 0x00, 0x00, 0x00};

	//Drive Start
	sh3001_write_reg(client, regAddr[0], regDataA[0]);
	sh3001_write_reg(client, regAddr[1], regDataA[1]);
	sh3001_write_reg(client, regAddr[2], regDataA[2]);
	msleep(300);
	sh3001_write_reg(client, regAddr[0], regDataB[0]);
	sh3001_write_reg(client, regAddr[1], regDataB[1]);
	sh3001_write_reg(client, regAddr[2], regDataB[2]);
	msleep(100);

	//ADC Reset
	sh3001_write_reg(client, regAddr[3], regDataA[3]);
	sh3001_write_reg(client, regAddr[4], regDataA[4]);
	msleep(1);
	sh3001_write_reg(client, regAddr[3], regDataB[3]);
	msleep(1);
	sh3001_write_reg(client, regAddr[4], regDataB[4]);
	msleep(50);

	//CVA Reset
	sh3001_write_reg(client, regAddr[5], regDataA[5]);
	msleep(10);
	sh3001_write_reg(client, regAddr[5], regDataB[5]);

	msleep(1);

	sh3001_write_reg(client, regAddr[6], regDataA[6]);
	msleep(10);
	sh3001_write_reg(client, regAddr[7], regDataA[7]);
	msleep(10);
	sh3001_write_reg(client, regAddr[8], regDataA[8]);
	msleep(10);
	sh3001_write_reg(client, regAddr[6], regDataB[6]);
	msleep(10);
	sh3001_write_reg(client, regAddr[7], regDataB[7]);
	msleep(10);
	sh3001_write_reg(client, regAddr[8], regDataB[8]);
	msleep(10);

	return 0;
}

static int sh3001_module_reset_mcf(struct i2c_client *client)
{
	unsigned char regAddr[9] = {0xC0, 0xD3, 0xC2, 0xD3, 0xD5, 0xD4, 0xBB, 0xB9, 0xBA};
	unsigned char regDataA[9] = {0x38, 0x16, 0x10, 0x11, 0x02, 0x08, 0x18, 0x18, 0x18};
	unsigned char regDataB[9] = {0x3E, 0x12, 0x20, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00};

	//Drive Start
	sh3001_write_reg(client, regAddr[0], regDataA[0]);
	sh3001_write_reg(client, regAddr[1], regDataA[1]);
	sh3001_write_reg(client, regAddr[2], regDataA[2]);
	msleep(300);
	sh3001_write_reg(client, regAddr[0], regDataB[0]);
	sh3001_write_reg(client, regAddr[1], regDataB[1]);
	sh3001_write_reg(client, regAddr[2], regDataB[2]);
	msleep(100);

	//ADC Reset
	sh3001_write_reg(client, regAddr[3], regDataA[3]);
	sh3001_write_reg(client, regAddr[4], regDataA[4]);
	msleep(1);
	sh3001_write_reg(client, regAddr[3], regDataB[3]);
	msleep(1);
	sh3001_write_reg(client, regAddr[4], regDataB[4]);
	msleep(50);

	//CVA Reset
	sh3001_write_reg(client, regAddr[5], regDataA[5]);
	msleep(10);
	sh3001_write_reg(client, regAddr[5], regDataB[5]);

	msleep(1);

	sh3001_write_reg(client, regAddr[6], regDataA[6]);
	msleep(10);
	sh3001_write_reg(client, regAddr[7], regDataA[7]);
	msleep(10);
	sh3001_write_reg(client, regAddr[8], regDataA[8]);
	msleep(10);
	sh3001_write_reg(client, regAddr[6], regDataB[6]);
	msleep(10);
	sh3001_write_reg(client, regAddr[7], regDataB[7]);
	msleep(10);
	sh3001_write_reg(client, regAddr[8], regDataB[8]);
	msleep(10);

	return 0;
}

static int sh3001_module_reset(struct i2c_client *client)
{
	unsigned char regData = 0;

	msleep(20);
	if (sh3001_read_reg(client, SH3001_CHIP_VERSION, &regData) < 0)
		return -1;

	if(regData == SH3001_CHIP_VERSION_MCC)
		sh3001_module_reset_mcc(client);
	else if(regData == SH3001_CHIP_VERSION_MCD)
		sh3001_module_reset_mcd(client);
	else if(regData == SH3001_CHIP_VERSION_MCF)
		sh3001_module_reset_mcf(client);
	else
		sh3001_module_reset_mcd(client);

	return 0;
}

#if 0
static int sh3001_switch_pmode(struct i2c_client *client, sh3001_pmode_t pmode)
{
	unsigned char regAddr[11] = {0xCF, 0x22, 0x2F, 0xCB, 0xCE, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8};
	unsigned char regData[11] = {0};
	int i = 0;
	unsigned char accODR = SH3001_ODR_1000HZ;

	for(i = 0; i < 11; i++)
		sh3001_read_reg(client, regAddr[i], &regData[i]);

	switch(pmode) {
	case SH3001_PM_NORMAL:
		// restore accODR
		sh3001_write_reg(client, SH3001_ACC_CONF1, storeAccODR);

		regData[0] = (regData[0] & 0xF8);
		regData[1] = (regData[1] & 0x7F);
		regData[2] = (regData[2] & 0xF7);
		regData[3] = (regData[3] & 0xF7);
		regData[4] = (regData[4] & 0xFE);
		regData[5] = (regData[5] & 0xFC) | 0x2;
		regData[6] = (regData[6] & 0xE);
		regData[7] = 0;
		regData[8] = 0x1;
		regData[9] = 0x50;
		regData[10] = (regData[10] & 0x1D);

		for(i = 0; i < 11; i++)
			sh3001_write_reg(client, regAddr[i], regData[i]);

		return sh3001_module_reset(client);

	case SH3001_PM_SLEEP:
		// store current acc ODR
		sh3001_read_reg(client, SH3001_ACC_CONF1, &storeAccODR);
		// set acc ODR=1000Hz
		sh3001_write_reg(client, SH3001_ACC_CONF1, accODR);

		regData[0] = (regData[0] & 0xF8) | 0x07;
		regData[1] = (regData[1] & 0x7F) | 0x80;
		regData[2] = (regData[2] & 0xF7) | 0x08;
		regData[3] = (regData[3] & 0xF7) | 0x08;
		regData[4] = (regData[4] & 0xFE) | 0x01;
		regData[5] = (regData[5] & 0xFC) | 0x01;
		regData[6] = (regData[6] & 0xE);
		regData[7] = 122;
		regData[8] = 255;
		regData[9] = 252;
		regData[10] = (regData[10] & 0x1D);

		for(i = 0; i < 11; i++)
			sh3001_write_reg(client, regAddr[i], regData[i]);

		return SH3001_TRUE;

	case SH3001_PM_POWERDOWN:
		regData[0] = (regData[0] & 0xF8);
		regData[1] = (regData[1] & 0x7F) | 0x80;
		regData[2] = (regData[2] & 0xF7) | 0x08;
		regData[3] = (regData[3] & 0xF7) | 0x08;
		regData[4] = (regData[4] & 0xFE);
		regData[5] = (regData[5] & 0xFC) | 0x1;
		regData[6] = (regData[6] & 0xE) | 0xF1;
		regData[7] = 254;
		regData[8] = 255;
		regData[9] = 252;
		regData[10] = (regData[10] & 0x1D) | 0xE2;

		for(i = 0; i < 11; i++)
			sh3001_write_reg(client, regAddr[i], regData[i]);

		return SH3001_TRUE;

	case SH3001_PM_ACC_NORMAL:
		regData[0] = (regData[0] & 0xF8);
		regData[1] = (regData[1] & 0x7F);
		regData[2] = (regData[2] & 0xF7);
		regData[3] = (regData[3] & 0xF7);
		regData[4] = (regData[4] & 0xFE) | 0x01;
		regData[5] = (regData[5] & 0xFC) | 0x01;
		regData[6] = (regData[6] & 0xE);
		regData[7] = 122;
		regData[8] = 255;
		regData[9] = 252;
		regData[10] = (regData[10] & 0x1D);

		for(i = 0; i < 11; i++)
			sh3001_write_reg(client, regAddr[i], regData[i]);

		return SH3001_TRUE;

	default:
		return SH3001_FALSE;
	}
}
#endif

static int sh3001_acc_config(struct i2c_client *client,
			unsigned char accODR,
			unsigned char accRange,
			unsigned char accCutOffFreq,
			unsigned char accFilterEnble)
{
	unsigned char regData = 0;

	// enable acc digital filter
	sh3001_read_reg(client, SH3001_ACC_CONF0, &regData);
	regData |= 0x01;
	sh3001_write_reg(client, SH3001_ACC_CONF0, regData);

	// set acc ODR
	storeAccODR = accODR;
	sh3001_write_reg(client, SH3001_ACC_CONF1, accODR);

	// set acc Range
	sh3001_write_reg(client, SH3001_ACC_CONF2, accRange);

	// bypass acc low pass filter or not
	sh3001_read_reg(client, SH3001_ACC_CONF3, &regData);
	regData &= 0x17;
	regData |= (accCutOffFreq | accFilterEnble);

	return sh3001_write_reg(client, SH3001_ACC_CONF3, regData);
}

static int sh3001_gyro_config(struct i2c_client *client,
			unsigned char gyroODR,
			unsigned char gyroRangeX,
			unsigned char gyroRangeY,
			unsigned char gyroRangeZ,
			unsigned char gyroCutOffFreq,
			unsigned char gyroFilterEnble)
{
	unsigned char regData = 0;

	// enable gyro digital filter
	sh3001_read_reg(client, SH3001_GYRO_CONF0, &regData);
	regData |= 0x01;
	sh3001_write_reg(client, SH3001_GYRO_CONF0, regData);

	// set gyro ODR
	sh3001_write_reg(client, SH3001_GYRO_CONF1, gyroODR);

	// set gyro X\Y\Z range
	sh3001_write_reg(client, SH3001_GYRO_CONF3, gyroRangeX);
	sh3001_write_reg(client, SH3001_GYRO_CONF4, gyroRangeY);
	sh3001_write_reg(client, SH3001_GYRO_CONF5, gyroRangeZ);

	// bypass gyro low pass filter or not
	sh3001_read_reg(client, SH3001_GYRO_CONF2, &regData);
	regData &= 0xE3;
	regData |= (gyroCutOffFreq | gyroFilterEnble);

	return sh3001_write_reg(client, SH3001_GYRO_CONF2, regData);
}

static int sh3001_temp_config(struct i2c_client *client,
			unsigned char tempODR,
			unsigned char tempEnable)
{
	unsigned char regData = 0;

	// enable temperature, set ODR
	sh3001_read_reg(client, SH3001_TEMP_CONF0, &regData);
	regData &= 0x4F;
	regData |= (tempODR | tempEnable);
	return sh3001_write_reg(client, SH3001_TEMP_CONF0, regData);
}

static int sh3001_sensor_init(struct i2c_client *client)
{
	unsigned char regData = 0;
	int i = 0;

	// SH3001 chipID = 0x61;
	while ((regData != 0x61) && (i++ < 3)) {

		sh3001_read_reg(client, SH3001_CHIP_ID, &regData);
		if ((i == 3) && (regData != 0x61)) {
			dev_err(&client->dev, "check id error,read data:0x%x,ops->id_data:0x%x\n", regData, 0x61);
			return SH3001_FALSE;
		}
	}

	// reset internal module
	if (sh3001_module_reset(client) < 0) {
		dev_err(&client->dev, "Failed to initialize internal module!\n");
		return SH3001_FALSE;
	}

	// 500Hz, 16G, cut off Freq(BW)=500*0.25Hz=125Hz, enable filter;
	sh3001_acc_config(client,
			SH3001_ODR_500HZ,
			SH3001_ACC_RANGE_2G,//使用2G量程
			SH3001_ACC_ODRX025,
			SH3001_ACC_FILTER_EN);

	// 500Hz, X\Y\Z 2000deg/s, cut off Freq(BW)=181Hz, enable filter;
	sh3001_gyro_config(client,
			SH3001_ODR_500HZ,
			SH3001_GYRO_RANGE_2000,
			SH3001_GYRO_RANGE_2000,
			SH3001_GYRO_RANGE_2000,
			SH3001_GYRO_ODRX00,
			SH3001_GYRO_FILTER_EN);

	// temperature ODR is 63Hz, enable temperature measurement
	sh3001_temp_config(client, SH3001_TEMP_ODR_63, SH3001_TEMP_EN);

	sh3001_read_reg(client, SH3001_CHIP_ID1, &regData);
	if (regData == 0x61)
		dev_info(&client->dev, "New Version SH3001.\n");

	return SH3001_TRUE;
}

static int sensor_active(struct i2c_client *client, int enable, int rate)
{
#if 0
	sh3001_pmode_t pmode;
	int ret = -1;

	if (enable)     //power on
		pmode = SH3001_PM_NORMAL;
	else            //power off
		pmode = SH3001_PM_POWERDOWN;

	ret = sh3001_switch_pmode(client, pmode);
	if (ret < 0)
		dev_err(&client->dev, "Failed to switch power mode!\n");

	return ret;
#endif

	return 0;
}

static int sensor_init(struct i2c_client *client)
{
	struct sensor_private_data *sensor =
		(struct sensor_private_data *)i2c_get_clientdata(client);
	int ret = -1;

	/* 初始化sh3001传感器 */
	ret = sh3001_sensor_init(client);
	if (ret < 0)
		return ret;
	dev_info(&client->dev, "Sensor initialization succeeded!\n");

	/* power off */
	ret = sensor->ops->active(client, 0, sensor->pdata->poll_delay_ms);
	if (ret)
		dev_err(&client->dev, "%s:line=%d,error\n", __func__, __LINE__);

	return ret;
}

static int sensor_report_value(struct i2c_client *client)
{
	struct sensor_private_data *sensor =
		(struct sensor_private_data *)i2c_get_clientdata(client);
	struct sensor_platform_data *pdata = sensor->pdata;
	struct sensor_axis axis;
	u8 buf[6] = {0};
	short x, y, z;
	int ret = -1;

	/* Data bytes from hardware xL, xH, yL, yH, zL, zH */
	memset(buf, 0, sizeof(buf));
	do {
		ret = sh3001_read_regs(client, sensor->ops->read_reg,
				sensor->ops->read_len, buf);
		if (ret < 0) {
			dev_err(&client->dev, "sh3001_read_regs error!\n");
			return ret;
		}
	} while (0);

	x = ((buf[1] << 8) & 0xFF00) + (buf[0] & 0xFF);
	y = ((buf[3] << 8) & 0xFF00) + (buf[2] & 0xFF);
	z = ((buf[5] << 8) & 0xFF00) + (buf[4] & 0xFF);
	axis.x = (pdata->orientation[0]) * x + (pdata->orientation[1]) * y + (pdata->orientation[2]) * z;
	axis.y = (pdata->orientation[3]) * x + (pdata->orientation[4]) * y + (pdata->orientation[5]) * z;
	axis.z = (pdata->orientation[6]) * x + (pdata->orientation[7]) * y + (pdata->orientation[8]) * z;

	if (sensor->status_cur == SENSOR_ON) {
		/* Report acceleration sensor information */
		input_report_abs(sensor->input_dev, ABS_X, axis.x);
		input_report_abs(sensor->input_dev, ABS_Y, axis.y);
		input_report_abs(sensor->input_dev, ABS_Z, axis.z);
		input_sync(sensor->input_dev);
	}

	mutex_lock(&(sensor->data_mutex));
	sensor->axis = axis;
	mutex_unlock(&(sensor->data_mutex));

	return ret;
}

static struct sensor_operate gsensor_sh3001_ops = {
	.name				= "sh3001_acc",
	.type				= SENSOR_TYPE_ACCEL,
	.id_i2c				= ACCEL_ID_SH3001,
	.read_reg			= SH3001_ACC_XL,
	.read_len			= 6,
	.id_reg				= SH3001_CHIP_ID,
	.id_data			= 0x61,
	.precision			= 16,
	.ctrl_reg			= -1,
	.ctrl_data			= -1,
	.int_ctrl_reg		= -1,
	.int_status_reg		= -1,
	.range				= {-32768, 32768},
	.trig				= IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
	.active				= sensor_active,
	.init				= sensor_init,
	.report				= sensor_report_value,
	.suspend			= NULL,
	.resume				= NULL,
};

/****************operate according to sensor chip:end************/
static int gsensor_sh3001_probe(struct i2c_client *client,
				const struct i2c_device_id *devid)
{
	return sensor_register_device(client, NULL, devid, &gsensor_sh3001_ops);
}

static int gsensor_sh3001_remove(struct i2c_client *client)
{
	return sensor_unregister_device(client, NULL, &gsensor_sh3001_ops);
}

static const struct i2c_device_id gsensor_sh3001_id[] = {
	{"sh3001_acc", ACCEL_ID_SH3001},
	{}
};

static struct i2c_driver gsensor_sh3001_driver = {
	.probe = gsensor_sh3001_probe,
	.remove = gsensor_sh3001_remove,
	.shutdown = sensor_shutdown,
	.id_table = gsensor_sh3001_id,
	.driver = {
		.name = "gsensor_sh3001",
	#ifdef CONFIG_PM
		.pm = &sensor_pm_ops,
	#endif
	},
};

module_i2c_driver(gsensor_sh3001_driver);

MODULE_AUTHOR("dengtao <dengtao@alientek.com>");
MODULE_DESCRIPTION("Senodia sh3001 3-Axis accelerometer driver");
MODULE_LICENSE("GPL");
