/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         apklistmodel.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "apklistmodel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QDateTime>
#include <QTextCodec>

Apk::Apk(QString apkIconPath, QString apkName, QString programName, bool installed) {
    m_apkIconPath = apkIconPath;
    m_apkName = apkName;
    m_programName = programName;
    m_installed = installed;
}

QString Apk::getApkIconPath() const
{
    return m_apkIconPath;
}

QString Apk::getApkName() const
{
    return m_apkName;
}

QString Apk::getProgramName() const
{
    return m_programName;
}

bool Apk::getInstalled() const
{
    return m_installed;
}

ApkListModel::ApkListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
}

int ApkListModel::currentIndex() const {
    return m_currentIndex;
}


int ApkListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return ApkData.count();
}

QVariant ApkListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= ApkData.count())
        return QVariant();
    const Apk &s = ApkData.at(index.row());
    switch (role) {
    case apkIconPathRole:
        return s.getApkIconPath();
    case apkNameRole:
        return s.getApkName();
    case programNameRole:
        return s.getProgramName();
    case installedRole:
        return s.getInstalled();
    default:
        return QVariant();
    }
}

int ApkListModel::randomIndex()
{
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % ApkData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

void ApkListModel::add(QString filePath)
{
    if (ApkData.count() > 0)
        this->remove(0, ApkData.count() - 1);
    revert();

    QList<Apk> tmpApkData;
    tmpApkData.clear();

    QFile file(filePath);
    QFileInfo fileInfo(file);

    if(!file.exists()) {
        qDebug()<< "read" + filePath + "failed" << Qt::endl;
        return ;
    }
    QString str;
    if (file.open(QIODevice::ReadOnly)) {
        QTextCodec* textCode = QTextCodec::codecForName("UTF-8");
        assert(textCode != nullptr);
        str = textCode->toUnicode(file.readAll());
    } else {
        qDebug()<< "open" + filePath + "failed" << Qt::endl;
        return;
    }

    QStringList strList = str.split("\n");

    foreach (QString tmpStr, strList) {
        QStringList list = tmpStr.split(" ");
        if (list.length() == 3 ) {
            QDir dir(fileInfo.absolutePath());
            dir.cdUp();
            QFile file (dir.absolutePath() + "/apps/" + list[2]);
            bool installed = false;
            if (file.exists()) {
                installed = true;
            }
            tmpApkData.append(Apk("file://" + dir.absolutePath() + "/" + list[0], list[1], list[2], installed));
        }
    }

    foreach (Apk apk, tmpApkData) {
        addApk(apk.getApkIconPath(), apk.getApkName(), apk.getProgramName(), apk.getInstalled());
    }

    if (m_currentIndex < 0 && ApkData.count()) {
        setCurrentIndex(0);
    }
    revert();
    emit countChanged();
}

void ApkListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    ApkData.move(from, to);
    endMoveRows();
}

void ApkListModel::remove(int first, int last)
{
    if ((first < 0) && (first >= ApkData.count()))
        return;
    if ((last < 0) && (last >= ApkData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        ApkData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= ApkData.count()) {
        setCurrentIndex(ApkData.count() - 1);
    }
    emit countChanged();
}

void ApkListModel::removeOne(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    ApkData.removeAt(index);
    endRemoveRows();
    if (m_currentIndex >= ApkData.count()) {
        setCurrentIndex(ApkData.count() - 1);
    }
}

int ApkListModel::count() const
{
    return ApkData.count();
}

void ApkListModel::setCurrentIndex(const int & i)
{
    if (i >= ApkData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < ApkData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> ApkListModel::roleNames() const
{
    QHash<int, QByteArray> role;
    role[apkIconPathRole] = "apkIconPath";
    role[apkNameRole] = "apkName";
    role[programNameRole] = "programName";
    role[installedRole] = "installed";
    return role;
}

void ApkListModel::addApk(QString apkIconPath, QString apkName, QString programName, bool installed) {
    beginInsertRows(QModelIndex(), ApkData.count(), ApkData.count());
    ApkData.append(Apk(apkIconPath, apkName, programName, installed));
    endInsertRows();
    emit countChanged();
}
