/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         VolumeControl.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-28
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef VOLUMECONTROL_H
#define VOLUMECONTROL_H

#include <QObject>
#include <QFileSystemWatcher>
#include  "volumecontrolthread.h"

class VolumeControl : public QFileSystemWatcher
{
    Q_OBJECT
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
public:
    explicit VolumeControl(QObject *parent = nullptr);
    Q_INVOKABLE void writeVolume(int volume);
    int volume() const;
    void setVolume(int newVolume);
    void readVolume();

signals:
    void volumeChanged();
    void triggerShow();

private:
    int m_volume;
    QString m_volumePath;
    VolumeControlThread * m_volumeControlThread;
private slots:
    void onFileChanged(const QString &path);
};

#endif // VOLUMECONTROL_H
