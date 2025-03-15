/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   server
* @brief         systemuicommonapi.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-31
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef SYSTEMUICOMMONAPISERVER_H
#define SYSTEMUICOMMONAPISERVER_H

#include <QRemoteObjectHost>
#include <QTimer>
#include <QImage>
#include "rep_systemuicommonapi_source.h"
#include "launchintent.h"

class SystemUICommonApiServer : public SystemUICommonApiSource
{
    Q_OBJECT
    Q_ENUMS(IosIDL)
    Q_ENUMS(Command)
public:
    explicit SystemUICommonApiServer(QObject * parent = nullptr);
    Q_INVOKABLE void setAppProperty(qreal x, qreal y, qreal iconWidth, qreal iconHeight, QString iconPath, int type, int currtentPage);
    Q_PROPERTY(QString currtentLauchAppName READ currtentLauchAppName WRITE setCurrtentLauchAppName NOTIFY currtentLauchAppNameChanged)
    Q_PROPERTY(bool appIsRunning READ appIsRunning WRITE setAppIsRunning NOTIFY appIsRunningChanged)
    Q_PROPERTY(bool firstTimeStart READ firstTimeStart WRITE setFirstTimeStart NOTIFY firstTimeStartChanged)
    Q_PROPERTY(bool currtentAppIsActive READ currtentAppIsActive WRITE setCurrtentAppIsActive NOTIFY currtentAppIsActiveChanged)

    QString currtentLauchAppName();
    void setCurrtentLauchAppName(const QString &appName);

    bool appIsRunning() const;
    void setAppIsRunning(bool newAppIsRunning);

    bool currtentAppIsActive() const;
    void setCurrtentAppIsActive(bool newCurrtentAppIsActive);

    bool firstTimeStart() const;
    void setFirstTimeStart(bool newFirstTimeStart);

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

public slots:
    virtual void onServerVariant(const QString &appName, int type, int cmd, QVariant variant) override;
    void quitNotification(QString appName);
private slots:
    void timeOutDetectIfTheAppIsActive();
    void timeOutDetectIsAlreadyRunning();
    void noAppFile();
private:
    QRemoteObjectHost * m_remoteObjectHost = nullptr;
    bool m_appIsRunning;
    QString m_currtentLauchAppName;
    qreal m_appX = 0.0;
    qreal m_appY = 0.0;
    qreal m_iconWidth = 0.0;
    qreal m_iconHeight = 0.0;
    QString m_iconPath;
    int m_type;
    int m_currtentPage;
    QTimer *detectIfTheAppIsActiveTimer;
    QTimer *detectAppIsAlreadyRunningTimer;
    bool m_currtentAppIsActive;
    LaunchIntent *launchIntent;
    bool m_firstTimeStart = true;


signals:
    void appAsktoHideOrShow(int action);
    void currtentLauchAppNameChanged();
    void appIsRunningChanged();
    void currtentAppIsActiveChanged();
    void firstTimeStartChanged();
    void appIsUnistalled();
    void appStateImageChanged(QString appName, QVariant image);
};

#endif // SYSTEMUICOMMONAPISERVER_H
