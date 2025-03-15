/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         applistmodel.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-16
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef APPLISTMODEL_H
#define APPLISTMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QVariant>

class App {
public:
    explicit App(QVariant image, QString appName);
    QString getAppName() const;
    QVariant getImage() const;

    void setImage(QVariant image);

private:
    QString  m_appName;
    QVariant m_image;
};

class AppListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit AppListModel(QObject *parent = 0);
    int currentIndex() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE int randomIndex();
    Q_INVOKABLE QString getcurrentAppName() const;
    Q_INVOKABLE QVariant getcurrentImage() const;
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void remove(int first, int last);
    Q_INVOKABLE void removeOne(int index);
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_INVOKABLE void setCurrentIndex(const int & i);
    Q_INVOKABLE int count();
    Q_INVOKABLE void addApp(QVariant image, QString appName);

    enum AppRole {
        imageRole = Qt::UserRole + 1,
        appNameRole,
    };

signals:
    void currentIndexChanged();
    void appModelUpdate();
    void askAppToQuit(QString appName);

public slots:

private:
    QHash<int, QByteArray> roleNames() const;

    int m_currentIndex;
    QList<App> appListData;
};

#endif // APPLISTMODEL_H
