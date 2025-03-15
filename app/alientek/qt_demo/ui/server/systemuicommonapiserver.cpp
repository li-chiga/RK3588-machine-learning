/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   server
* @brief         systemuicommonApi.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-31
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "systemuicommonapiserver.h"
#include <QDebug>
#include <QEventLoop>
#include <QTimer>
SystemUICommonApiServer::SystemUICommonApiServer(QObject *parent):
    SystemUICommonApiSource(parent),
    m_appIsRunning(false),
    m_currtentLauchAppName(""),
    m_currtentAppIsActive(false)
{
    m_remoteObjectHost = new QRemoteObjectHost(this);
    m_remoteObjectHost->setHostUrl(QUrl("local:interfaces"));
    m_remoteObjectHost->enableRemoting(this);
    detectIfTheAppIsActiveTimer =  new QTimer(this);
    detectAppIsAlreadyRunningTimer =  new QTimer(this);
    detectIfTheAppIsActiveTimer->setInterval(2000);
    detectAppIsAlreadyRunningTimer->setInterval(20); // default 1000
    connect(detectIfTheAppIsActiveTimer, SIGNAL(timeout()), this, SLOT(timeOutDetectIfTheAppIsActive()));
    connect(detectAppIsAlreadyRunningTimer, SIGNAL(timeout()), this, SLOT(timeOutDetectIsAlreadyRunning()));
    launchIntent = new LaunchIntent(this);
    connect(launchIntent, SIGNAL(noAppFile()), this, SLOT(noAppFile()));
}


void SystemUICommonApiServer::setAppProperty(qreal x, qreal y, qreal iconWidth, qreal iconHeight, QString iconPath, int type, int currtentPage)
{
    m_appX = x;
    m_appY = y;
    m_iconWidth = iconWidth;
    m_iconHeight = iconHeight;
    m_iconPath = iconPath;
    m_type = type;
    m_currtentPage = currtentPage;
}

QString SystemUICommonApiServer::currtentLauchAppName()
{
    return m_currtentLauchAppName;
}

void SystemUICommonApiServer:: onServerVariant(const QString &appName, int type, int cmd, QVariant variant)
{
    if (m_currtentLauchAppName == appName && type == IosIDL::ActivateControl) {
        if (cmd == Command::IsRunningInBackground) {
            setFirstTimeStart(false);
            detectAppIsAlreadyRunningTimer->stop();
            setAppIsRunning(true);
            setCurrtentAppIsActive(true);
            serverSendVariant(m_currtentLauchAppName, IosIDL::ActivateControl, Command::Show, QVariant::Invalid);
            detectIfTheAppIsActiveTimer->stop();
            detectIfTheAppIsActiveTimer->start();
            //serverSendVariant(m_currtentLauchAppName, IosIDL::ActivateControl, "isRunning");
        }

        if (cmd == Command::IsActive) {
            setCurrtentAppIsActive(true);
            setFirstTimeStart(false);
            detectIfTheAppIsActiveTimer->stop();
            detectIfTheAppIsActiveTimer->start();
        }
    }

    if (cmd == Command::Hide) {
        detectAppIsAlreadyRunningTimer->stop();
        setFirstTimeStart(false);
        emit appAsktoHideOrShow(Command::Hide);
        QString ms = "property: " + QString::number(m_appX) + " " + QString::number(m_appY)
                     + " " + QString::number(m_iconWidth) + " " + QString::number(m_iconHeight) + " "
                     + m_iconPath + " "  + QString::number(m_type) + " "  + QString::number(m_currtentPage);
        serverSendVariant(appName, IosIDL::Messages, Command::CommandNone, ms);
        setCurrtentAppIsActive(true);
        detectIfTheAppIsActiveTimer->stop();
        detectIfTheAppIsActiveTimer->start();
    }
    if (cmd == Command::Show) {
        setFirstTimeStart(false);
        emit appAsktoHideOrShow(Command::Show);
        detectAppIsAlreadyRunningTimer->stop();
        detectIfTheAppIsActiveTimer->stop();
    }
    if (type == IosIDL::Image) {
        emit appStateImageChanged(appName, variant);
    }
}

void SystemUICommonApiServer::quitNotification(QString appName)
{
    serverSendVariant(appName, IosIDL::ActivateControl, Command::Quit, QVariant::Invalid);
}

void SystemUICommonApiServer::setCurrtentLauchAppName(const QString &appName)
{
    if (appName != m_currtentLauchAppName) {
        m_currtentLauchAppName = appName;
        emit currtentLauchAppNameChanged();
        detectAppIsAlreadyRunningTimer->stop();
        if (m_currtentLauchAppName != "") {
            detectAppIsAlreadyRunningTimer->start();
            setFirstTimeStart(true);
        }

        setAppIsRunning(false);
        setCurrtentAppIsActive(false);
    }
}

void SystemUICommonApiServer::timeOutDetectIfTheAppIsActive()
{
    serverSendVariant(m_currtentLauchAppName, IosIDL::ActivateControl, Command::IsActive, QVariant::Invalid);
    if (!m_currtentAppIsActive) {
        detectIfTheAppIsActiveTimer->stop();
        setAppIsRunning(false);
        setFirstTimeStart(true);
        setCurrtentLauchAppName("null");
    }
    setCurrtentAppIsActive(false);

}

void SystemUICommonApiServer::timeOutDetectIsAlreadyRunning()
{
    detectAppIsAlreadyRunningTimer->stop();
    setFirstTimeStart(true);
    launchIntent->lauchApp(m_currtentLauchAppName);
    detectIfTheAppIsActiveTimer->stop();
    detectIfTheAppIsActiveTimer->start();
}

void SystemUICommonApiServer::noAppFile()
{
    setFirstTimeStart(true);
    setCurrtentLauchAppName("null");
    emit appIsUnistalled();
}

bool SystemUICommonApiServer::firstTimeStart() const
{
    return m_firstTimeStart;
}

void SystemUICommonApiServer::setFirstTimeStart(bool newFirstTimeStart)
{
    if (m_firstTimeStart == newFirstTimeStart)
        return;
    m_firstTimeStart = newFirstTimeStart;
    emit firstTimeStartChanged();
}

bool SystemUICommonApiServer::currtentAppIsActive() const
{
    return m_currtentAppIsActive;
}

void SystemUICommonApiServer::setCurrtentAppIsActive(bool newCurrtentAppIsActive)
{
    if (m_currtentAppIsActive == newCurrtentAppIsActive)
        return;
    m_currtentAppIsActive = newCurrtentAppIsActive;
    emit currtentAppIsActiveChanged();
}

bool SystemUICommonApiServer::appIsRunning() const
{
    return m_appIsRunning;
}

void SystemUICommonApiServer::setAppIsRunning(bool newAppIsRunning)
{
    if (m_appIsRunning == newAppIsRunning)
        return;
    m_appIsRunning = newAppIsRunning;
    emit appIsRunningChanged();
}
