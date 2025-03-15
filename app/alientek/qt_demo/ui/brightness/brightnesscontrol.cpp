/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         brightnesscontrol.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-21
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "brightnesscontrol.h"
#include <QFile>

BrightnessControl::BrightnessControl(QObject *parent)
    : QFileSystemWatcher(parent)
{
    QFile file("/sys/class/backlight/backlight1/brightness");
    if (file.exists()) {
        m_brightnessPath = "/sys/class/backlight/backlight1/brightness";
    } else
        m_brightnessPath = "/sys/class/backlight/backlight/brightness";
    this->addPath(m_brightnessPath);
    connect(this, SIGNAL(fileChanged(QString)), this, SLOT(onFileChanged(QString)));
    readBrightness();
}

int BrightnessControl::brightness() const
{
    return m_brightness;
}

void BrightnessControl::setBrightness(int newBrightness)
{
    if (m_brightness == newBrightness)
        return;
    m_brightness = newBrightness;
    emit brightnessChanged();
}

void BrightnessControl::readBrightness()
{
    FILE *fp = fopen(m_brightnessPath.toUtf8().constData(), "r");
    if (fp) {
        int brightness;
        if (fscanf(fp, "%d", &brightness) == 1) {
            setBrightness(brightness);
        }
        fclose(fp);
    }
}

void BrightnessControl::onFileChanged(const QString &path)
{
    Q_UNUSED(path)
    readBrightness();
}

void BrightnessControl::writeBrightness(int brightness)
{
    // 防止亮度过低，导致屏幕看不见
    if (brightness < 50)
        return;
    setBrightness(brightness);
    FILE *fp = fopen(m_brightnessPath.toUtf8().constData(), "w");
    if (fp) {
        if (fprintf(fp, "%d", brightness) > 0) {
        } else {
            perror("Failed to write brightness");
        }
        fclose(fp);
    } else {
        perror("Failed to open brightness file");
    }
}

