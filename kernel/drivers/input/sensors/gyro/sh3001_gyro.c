/* drivers/input/sensors/gyro/sh3001_gyro.c
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

static int sensor_active(struct i2c_client *client, int enable, int rate)
{
	return 0;
}

static int sensor_init(struct i2c_client *client)
{
	struct sensor_private_data *sensor =
		(struct sensor_private_data *)i2c_get_clientdata(client);
	int ret = -1;

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
		input_report_abs(sensor->input_dev, ABS_RX, axis.x);
		input_report_abs(sensor->input_dev, ABS_RY, axis.y);
		input_report_abs(sensor->input_dev, ABS_RZ, axis.z);
		input_sync(sensor->input_dev);
	}

	mutex_lock(&(sensor->data_mutex));
	sensor->axis = axis;
	mutex_unlock(&(sensor->data_mutex));

	return ret;
}

static struct sensor_operate gyro_sh3001_ops = {
	.name				= "sh3001_gyro",
	.type				= SENSOR_TYPE_GYROSCOPE,
	.id_i2c				= GYRO_ID_SH3001,
	.read_reg			= SH3001_GYRO_XL,
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
static int gyro_sh3001_probe(struct i2c_client *client,
				const struct i2c_device_id *devid)
{
	return sensor_register_device(client, NULL, devid, &gyro_sh3001_ops);
}

static int gyro_sh3001_remove(struct i2c_client *client)
{
	return sensor_unregister_device(client, NULL, &gyro_sh3001_ops);
}

static const struct i2c_device_id gyro_sh3001_id[] = {
	{"sh3001_gyro", GYRO_ID_SH3001},
	{}
};

static struct i2c_driver gyro_sh3001_driver = {
	.probe = gyro_sh3001_probe,
	.remove = gyro_sh3001_remove,
	.shutdown = sensor_shutdown,
	.id_table = gyro_sh3001_id,
	.driver = {
		.name = "gyro_sh3001",
	#ifdef CONFIG_PM
		.pm = &sensor_pm_ops,
	#endif
	},
};

static int __init gyro_sh3001_init(void)
{
	return i2c_add_driver(&gyro_sh3001_driver);
}

static void __exit gyro_sh3001_exit(void)
{
	i2c_del_driver(&gyro_sh3001_driver);
}

/* must register after sh3001_acc */
device_initcall_sync(gyro_sh3001_init);
module_exit(gyro_sh3001_exit);

MODULE_AUTHOR("dengtao <dengtao@alientek.com>");
MODULE_DESCRIPTION("Senodia sh3001 3-Axis Gyroscope driver");
MODULE_LICENSE("GPL");
