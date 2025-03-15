/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         volumecontrolthread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef VOLUMECONTROLTHREAD_H
#define VOLUMECONTROLTHREAD_H

#include <QObject>
#include <QThread>
#include <pthread.h>
#include <unistd.h>
#include <sys/epoll.h>
#include <sys/poll.h>
#include <linux/input.h>
#include <fcntl.h>
#include <dirent.h>
#include <QTimer>
struct position {
    int x, y;
    int synced;
    struct input_absinfo xi, yi;
};

struct ev {
    struct pollfd *fd;

    struct virtualkey *vks;
    int vk_count;

    char deviceName[64];

    int ignored;

    struct position p, mt_p;
    int down;
};

#define MAX_DEVICES 16
static unsigned ev_count = 0;
static struct pollfd ev_fds[MAX_DEVICES];
static struct ev evs[MAX_DEVICES];

class VolumeControlThread : public QThread
{
    Q_OBJECT
    enum VolumeType {
        VolumeNone = 0,
        VolumeUp = 1,
        VolumeDown
    };
public:
    explicit VolumeControlThread(QObject *parent = nullptr);
private:
    int m_volumeType = 0;
    int ev_init();
    int ev_get(struct input_event *ev, unsigned dont_wait);
    QTimer *m_timer;
    QString m_volumePath;
    int m_volume;

    void readVolume();
    void writeVolume(int volume);
protected:
    void run() override;
private slots:
    void timerTimeOut();
    void onStartTimer(bool flag);
signals:
    void startTimer(bool flag);
    void triggerShow();
};

#endif // VOLUMECONTROLTHREAD_H
