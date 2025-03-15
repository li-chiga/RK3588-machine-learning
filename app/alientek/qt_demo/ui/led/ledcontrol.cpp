/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         ledcontrol.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-05-06
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "ledcontrol.h"
#include <QFile>
#include <QDebug>
LedControl::LedControl()
{
    this->addPath("/sys/class/leds/work/brightness");
    connect(this, SIGNAL(fileChanged(QString)), this, SLOT(onFileChanged(QString)));
    system("echo none > /sys/class/leds/work/trigger");
}

void LedControl::setLedState(int state)
{
    if (state != m_ledState) {
        m_ledState = state;
        QFile file("/sys/class/leds/work/brightness");
        if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            if (state > 0) {
                file.write("1");
                ledStateChanged(On);
            } else {
                file.write("0");
                ledStateChanged(Off);
            }
            file.close();
        }
    }
}

void LedControl::onFileChanged(const QString &path)
{;
    Q_UNUSED(path)
    QFile file("/sys/class/leds/work/brightness");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString state = file.readAll();
        if (state.simplified().toInt() > 0) {
            m_ledState = On;
            emit ledStateChanged(On);
        } else {
            m_ledState = Off;
            emit ledStateChanged(Off);
        }
        file.close();
    }
}

int LedControl::ledState() const
{
    return m_ledState;
}

