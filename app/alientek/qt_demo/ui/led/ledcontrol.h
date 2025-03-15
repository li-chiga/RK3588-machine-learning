/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         ledcontrol.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-05-06
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef LEDCONTROL_H
#define LEDCONTROL_H

#include <QFileSystemWatcher>
#include <QObject>

class LedControl : public QFileSystemWatcher
{
    Q_OBJECT
    Q_ENUMS(LedState)
public:
    LedControl();
    Q_INVOKABLE void setLedState(int state);
    Q_PROPERTY(int ledState READ ledState WRITE setLedState NOTIFY ledStateChanged)
    enum LedState {
        Off = 0,
        On = 1
    };
    int ledState() const;
    void resetLedState();

signals:
    void ledStateChanged(LedState ledState);
private slots:
    void onFileChanged(const QString &path);
private:
    int m_ledState;

};

#endif // LEDCONTROL_H
