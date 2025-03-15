/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         volumemonitor.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-28
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef VOLUMEMONITOR_H
#define VOLUMEMONITOR_H

#include <QObject>
#include <QFileSystemWatcher>

class VolumeMonitor : public QFileSystemWatcher
{
    Q_OBJECT
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY volumeChanged)
public:
    explicit VolumeMonitor(QObject *parent = nullptr);
    Q_INVOKABLE void writeVolume(qreal volume);
    qreal volume() const;
    void setVolume(qreal newVolume);
    void readVolume();

signals:
    void volumeChanged();

private:
    qreal m_volume;
    QString m_volumePath;

private slots:
    void onFileChanged(const QString &path);

};

#endif // VOLUMEMONITOR_H
