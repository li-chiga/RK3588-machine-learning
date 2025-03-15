/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         VolumeMonitor.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-28
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "volumemonitor.h"
#include <QDebug>
#include <QCoreApplication>

VolumeMonitor::VolumeMonitor(QObject *parent)
    : QFileSystemWatcher(parent)
{
    m_volumePath = QCoreApplication::applicationDirPath() + "/resource/volume";
    this->addPath(m_volumePath);
    connect(this, SIGNAL(fileChanged(QString)), this, SLOT(onFileChanged(QString)));
    readVolume();
}

qreal VolumeMonitor::volume() const
{
    return m_volume;
}

void VolumeMonitor::setVolume(qreal newVolume)
{
    if (newVolume <= 0)
        newVolume = 0;
    if (newVolume >= 1)
        newVolume = 1.0;
    if (m_volume == newVolume)
        return;
    m_volume = newVolume;
    emit volumeChanged();
}

void VolumeMonitor::readVolume()
{
    const char *path = m_volumePath.toUtf8().constData();
    FILE *fp = fopen(path, "r");
    if (fp) {
        int volume;
        if (fscanf(fp, "%d", &volume) == 1) {
            qreal tmp = volume;
            setVolume(tmp / 100.0);
        }
        fclose(fp);
    }
}

void VolumeMonitor::onFileChanged(const QString &path)
{
    Q_UNUSED(path)
    readVolume();
}

void VolumeMonitor::writeVolume(qreal volume)
{
    setVolume(volume);

    if (volume <= 0)
        volume = 0;
    if (volume >= 1)
        volume = 1.0;

    int tmpVolume = volume * 100;
    const char *path = m_volumePath.toUtf8().constData();
    FILE *fp = fopen(path, "w");
    if (fp) {
        if (fprintf(fp, "%d", tmpVolume) > 0) {
        } else {
            qDebug() << "Failed to write " << m_volumePath;
        }
        fclose(fp);
    } else {
        qDebug() << "Failed to open " << m_volumePath;
    }
}

