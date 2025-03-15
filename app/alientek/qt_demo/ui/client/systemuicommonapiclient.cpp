/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   client
* @brief         systemuicommonapiclient.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-31
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "systemuicommonapiclient.h"
#include <QDebug>
#include <QRemoteObjectSourceLocation>
#include <QRandomGenerator>
#include <QBuffer>
QString SystemUICommonApiClient::appName() const
{
    return m_appName;
}

void SystemUICommonApiClient::setAppName(const QString &appName)
{
    m_appName = appName;
    emit appNameChanged();
}

SystemUICommonApiClient::SystemUICommonApiClient(QObject *parent) : QObject(parent), m_appName("")
{
    timer = new QTimer();
    timer->start(100);
    connect(timer, SIGNAL(timeout()), this, SLOT(timerTimeOut()));
    m_remoteObjectNode = new QRemoteObjectNode(this);
    m_remoteObjectNode->connectToNode(QUrl("local:interfaces"));

    m_systemUICommonApiReplica = m_remoteObjectNode->acquire<SystemUICommonApiReplica>();

    connect(m_systemUICommonApiReplica, SIGNAL(serverSendVariant(QString, int, int, QVariant)), this, SLOT(onServerVariant(QString, int, int, QVariant)));
}

void SystemUICommonApiClient::sendVariantToServer(int type, QVariant variant)
{
    QByteArray byteArray;
    if (variant.canConvert<QImage>()) {
        QBuffer buffer;
        buffer.open(QIODevice::WriteOnly);
        variant.value<QImage>().save(&buffer, "JPG");
        byteArray = buffer.data();
        m_systemUICommonApiReplica->onServerVariant(m_appName, type, Command::CommandNone, byteArray);
        buffer.close();
        return;
    }

    m_systemUICommonApiReplica->onServerVariant(m_appName, type, Command::CommandNone, variant);
}

void SystemUICommonApiClient::onServerVariant(const QString &appName, int type, int cmd, QVariant variant)
{
    if (appName == m_appName && type == IosIDL::ActivateControl) {
        if (cmd == Command::IsRunningInBackground)
            m_systemUICommonApiReplica->onServerVariant(m_appName, IosIDL::ActivateControl, Command::IsRunningInBackground, QVariant::Invalid);
        if (cmd == Command::Show)
            emit actionCommand(Command::Show);
        if (cmd == Command::IsActive) {
            m_systemUICommonApiReplica->onServerVariant(m_appName, IosIDL::ActivateControl, Command::IsActive, QVariant::Invalid);
        }
        if (cmd == Command::Quit) {
            emit actionCommand(Command::Quit);
        }
    }
    if (appName == m_appName && type == IosIDL::Messages) {
        if (variant.toString().contains("property:")) {
            QStringList stringList = variant.toString().split(" ");
            if (stringList.length() == 8) {
                emit appAppPropertyChanged(stringList[1].toDouble(), stringList[2].toDouble(),
                                           stringList[3].toDouble(), stringList[4].toDouble(),
                                           stringList[5], stringList[6].toInt(), stringList[7].toInt());
            }
        }
    }

}

void SystemUICommonApiClient::timerTimeOut()
{
    timer->stop();
    delete timer;
    m_systemUICommonApiReplica->onServerVariant(m_appName, IosIDL::ActivateControl, Command::Hide, QVariant::Invalid);
}

void SystemUICommonApiClient::askSystemUItohideOrShow(int show)
{
    m_systemUICommonApiReplica->onServerVariant(m_appName, IosIDL::ActivateControl, show, QVariant::Invalid);
}


