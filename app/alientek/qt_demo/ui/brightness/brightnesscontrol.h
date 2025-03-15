/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         brightnesscontrol.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-21
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef BRIGHTNESSCONTROL_H
#define BRIGHTNESSCONTROL_H

#include <QObject>
#include <QFileSystemWatcher>

class BrightnessControl : public QFileSystemWatcher
{
    Q_OBJECT
    Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
public:
    explicit BrightnessControl(QObject *parent = nullptr);
    Q_INVOKABLE void writeBrightness(int brightness);
    int brightness() const;
    void setBrightness(int newBrightness);
    void readBrightness();

signals:
    void brightnessChanged();
private slots:
    void onFileChanged(const QString &path);

private:
    int m_brightness;
    QString m_brightnessPath;

};

#endif // BRIGHTNESSCONTROL_H
