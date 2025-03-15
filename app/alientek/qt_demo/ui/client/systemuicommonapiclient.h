/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   client
* @brief         systemuicommonapiclient.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-31
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef SYSTEMUICOMMONAPICLIENT_H
#define SYSTEMUICOMMONAPICLIENT_H

#include <QObject>
#include <QTimer>
#include <QImage>
#include "rep_systemuicommonapi_replica.h"
#include <QRemoteObjectNode>
class SystemUICommonApiClient : public QObject
{
    Q_OBJECT
    Q_ENUMS(IosIDL)
    Q_ENUMS(Command)
public:
    QString appName() const;
    void setAppName(const QString &appName);
    explicit SystemUICommonApiClient(QObject *parent = nullptr);
    Q_PROPERTY(QString appName READ appName WRITE setAppName NOTIFY appNameChanged)
    Q_INVOKABLE void sendVariantToServer(int type, QVariant Variant);
    /* 通信类型 */
    enum IosIDL {
        IosIDLNone = 0,
        ActivateControl, /* 活动类型*/
        Image,      /* 图片类型 */
        Messages    /* 消息类型 */
    };

    enum Command {
        CommandNone = 0,
        Show, /* 显示 */
        Quit,  /* 退出 */
        IsRunningInBackground, /* 后台 */
        IsActive, /* 活跃 */
        Hide/* 隐藏 */
    };
signals:
    void appNameChanged();
    void actionCommand(Command cmd);
    void appAppPropertyChanged(qreal iconX, qreal iconY, qreal iconWidth, qreal iconHeight, QString iconPath, int callType, int currtentPage);
private:
    QRemoteObjectNode * m_remoteObjectNode = nullptr;
    SystemUICommonApiReplica * m_systemUICommonApiReplica = nullptr;
    QString m_appName;
    QTimer *timer;
public slots:
    void askSystemUItohideOrShow(int show);
private slots:
    void onServerVariant(const QString &appName, int type, int cmd, QVariant variant);
    void timerTimeOut();
};

#endif // SYSTEMUICOMMONAPICLIENT_H
