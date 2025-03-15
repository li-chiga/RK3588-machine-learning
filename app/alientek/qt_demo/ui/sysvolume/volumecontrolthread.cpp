/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         volumecontrolthread.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "volumecontrolthread.h"
#include <QCoreApplication>
#include <QDebug>


VolumeControlThread::VolumeControlThread(QObject *parent)
    : QThread{parent}
{
    m_volumePath = QCoreApplication::applicationDirPath() + "/resource/volume";
    m_timer = new QTimer(this);
    m_timer->setInterval(30);
    connect(m_timer, SIGNAL(timeout()), this, SLOT(timerTimeOut()));
    connect(this, SIGNAL(startTimer(bool)), this, SLOT(onStartTimer(bool)));
}

int VolumeControlThread::ev_init()
{
    DIR *dir;
    struct dirent *de;
    int fd;
    char name[80];
    dir = opendir("/dev/input");
    if(dir != 0) {
        while((de = readdir(dir))) {
            if(strncmp(de->d_name, "event", 5))
                continue;
            fd = openat(dirfd(dir), de->d_name, O_RDONLY);
            if(fd < 0) continue;
            else {
                if (ioctl(fd, EVIOCGNAME(sizeof(name) - 1), &name) < 1) {
                    name[0] = '\0';
                }
                if (strcmp(name, "adc-keys")) {
                    close(fd);
                    continue;
                }
            }
            ev_fds[ev_count].fd = fd;
            ev_fds[ev_count].events = POLLIN;
            evs[ev_count].fd = &ev_fds[ev_count];

            ev_count++;
            if(ev_count == MAX_DEVICES) break;
            break;
        }
    }

    return 0;
}

int VolumeControlThread::ev_get(input_event *ev, unsigned int dont_wait)
{
    int r;
    unsigned n;

    do {
        r = poll(ev_fds, ev_count, dont_wait ? 0 : -1);

        if(r > 0) {
            for(n = 0; n < ev_count; n++) {
                if(ev_fds[n].revents & POLLIN) {
                    r = read(ev_fds[n].fd, ev, sizeof(*ev));
                    if(r == sizeof(*ev)) {
                        //if (!vk_modify(&evs[n], ev))
                        return 0;
                    }
                }
            }
        }
    } while(dont_wait == 0);

    return -1;
}

void VolumeControlThread::readVolume()
{
    const char *path = m_volumePath.toUtf8().constData();
    FILE *fp = fopen(path, "r");
    if (fp) {
        int volume;
        if (fscanf(fp, "%d", &volume) == 1) {
            m_volume = volume;
        }
        fclose(fp);
    }
}

void VolumeControlThread::writeVolume(int volume)
{
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

void VolumeControlThread::run()
{
    struct input_event ev;

    if (ev_init() != 0)
        goto err_out;

    for ( ; ; ) {
        if (ev_get(&ev, 0) == 0) {
            if (EV_KEY == ev.type) {
                if (ev.value == 0) {
                    switch(ev.code) {
                    case KEY_VOLUMEUP:
                        emit triggerShow();
                        m_volumeType = VolumeNone;
                        emit startTimer(false);
                        break;
                    case KEY_VOLUMEDOWN:
                        emit triggerShow();
                        m_volumeType = VolumeNone;
                        emit startTimer(false);
                        break;
                    }
                }
                else if (ev.value == 1) {
                    switch(ev.code) {
                    case KEY_VOLUMEUP:
                        m_volumeType = VolumeUp;
                        emit startTimer(true);
                        break;
                    case KEY_VOLUMEDOWN:
                        m_volumeType = VolumeDown;
                        emit startTimer(true);
                        break;
                    }
                }
            }
        }
    }

err_out:
    qDebug("no keys ！！");
}

void VolumeControlThread::timerTimeOut()
{
    readVolume();
    if (m_volumeType == VolumeUp) {
        if (m_volume + 1 >= 100)
            m_volume = 100;
        else
            m_volume += 1;

    }
    if (m_volumeType == VolumeDown) {
        if (m_volume - 1 <= 0)
            m_volume = 0;
        else
            m_volume -= 1;
    }
    writeVolume(m_volume);
}

void VolumeControlThread::onStartTimer(bool flag)
{
    if (flag)
        m_timer->start();
    else
        m_timer->stop();
}
