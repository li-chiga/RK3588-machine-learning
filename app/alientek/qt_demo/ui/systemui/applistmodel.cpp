/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         applistmodel.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-16
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "applistmodel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
App::App(QVariant image, QString appName) {
    m_image = image;
    m_appName = appName;
}

QVariant App::getImage() const {
    return m_image;
}

void App::setImage(QVariant image)
{
    m_image = image;
}

QString App::getAppName() const {
    return m_appName;
}

AppListModel::AppListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
    appListData.clear();
}

int AppListModel::currentIndex() const {
    return m_currentIndex;
}

int AppListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return appListData.count();
}

QVariant AppListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= appListData.count())
        return QVariant();
    const App &s = appListData.at(index.row());
    switch (role) {
    case imageRole:
        return s.getImage();
    case appNameRole:
        return s.getAppName();
    default:
        return QVariant();
    }
}

int AppListModel::randomIndex() {
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % appListData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString AppListModel::getcurrentAppName() const {
    return appListData.at(m_currentIndex).getAppName();
}

QVariant AppListModel::getcurrentImage() const {
    return appListData.at(m_currentIndex).getImage();
}

void AppListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    appListData.move(from, to);
    endMoveRows();
}

void AppListModel::remove(int first, int last) {
    revert();
    if ((first < 0) && (first >= appListData.count()))
        return;
    if ((last < 0) && (last >= appListData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        appListData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= appListData.count()) {
        setCurrentIndex(appListData.count() - 1);
    }
    //revert();
}

void AppListModel::removeOne(int index) {
    //revert();
    beginRemoveRows(QModelIndex(), index, index);
    appListData.removeAt(index);
    endRemoveRows();
    if (m_currentIndex >= appListData.count()) {
        setCurrentIndex(appListData.count() - 1);
    }
    //revert();
}

void AppListModel::setCurrentIndex(const int & i) {
    if (i >= appListData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < appListData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> AppListModel::roleNames() const {
    QHash<int, QByteArray> role;
    role[appNameRole] = "appName";
    role[imageRole] = "image";
    return role;
}

void AppListModel::addApp(QVariant image, QString appName) {
    QVector <int> RoleName;
    RoleName.clear();
    RoleName.append(AppRole::imageRole);
    RoleName.append(AppRole::appNameRole);
    for (int i = 0; i < appListData.count(); ++i) {
        App app = appListData.at(i);
        if (app.getAppName() == appName) {
            app.setImage(image);
            appListData.replace(i, app);
            emit dataChanged(index(i, 0), index(i, 0), RoleName);
            emit appModelUpdate();
            return;
        }
    }

    //revert();
    beginInsertRows(QModelIndex(), appListData.count(), appListData.count());
    appListData.append(App(image, appName));
    endInsertRows();
    emit appModelUpdate();
    //revert();
}

int AppListModel::count()
{
    return appListData.count();
}
