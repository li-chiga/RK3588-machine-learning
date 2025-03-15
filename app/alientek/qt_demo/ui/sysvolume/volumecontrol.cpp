/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         VolumeControl.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-28
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "volumecontrol.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/inotify.h>
#include <QDebug>
#include <QCoreApplication>
#define EVENT_SIZE  (sizeof (struct inotify_event))
#define BUF_LEN     (1024 * (EVENT_SIZE + 16))
VolumeControl::VolumeControl(QObject *parent)
    : QFileSystemWatcher{parent}
{
    m_volumePath = QCoreApplication::applicationDirPath() + "/resource/volume";
    this->addPath(m_volumePath);
    connect(this, SIGNAL(fileChanged(QString)), this, SLOT(onFileChanged(QString)));
    readVolume();
    m_volumeControlThread = new VolumeControlThread(this);
    m_volumeControlThread->start();
    connect(m_volumeControlThread, SIGNAL(triggerShow()), this, SIGNAL(triggerShow()));
}

int VolumeControl::volume() const
{
    return m_volume;
}

void VolumeControl::setVolume(int newVolume)
{
    if (newVolume <= 0)
        newVolume = 0;
    if (newVolume >= 100)
        newVolume = 100;
    if (m_volume == newVolume)
        return;
    m_volume = newVolume;
    emit volumeChanged();
}

void VolumeControl::readVolume()
{
    const char *path = m_volumePath.toUtf8().constData();
    FILE *fp = fopen(path, "r");
    if (fp) {
        int volume;
        if (fscanf(fp, "%d", &volume) == 1) {
            int tmp = volume;
            setVolume(tmp);
        }
        fclose(fp);
    }
}

void VolumeControl::onFileChanged(const QString &path)
{
    Q_UNUSED(path)
    emit triggerShow();
    readVolume();
}

void VolumeControl::writeVolume(int volume)
{
    setVolume(volume);

    if (volume <= 0)
        volume = 0;
    if (volume >= 100)
        volume = 100;

    const char *path = m_volumePath.toUtf8().constData();
    FILE *fp = fopen(path, "w");
    if (fp) {
        if (fprintf(fp, "%d", volume) > 0) {
        } else {
            qDebug() << "Failed to write " << m_volumePath;
        }
        fclose(fp);
    } else {
        qDebug() << "Failed to open " << m_volumePath;
    }
}

