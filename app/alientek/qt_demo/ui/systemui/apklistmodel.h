/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         apklistmodel.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef APKLISTMODEL_H
#define APKLISTMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QDebug>
#include <QProcess>
#include <QCoreApplication>
#include <QFile>
#include <QDateTime>

class Apk {
public:
    explicit Apk(QString apkIconPath, QString apkName, QString programName, bool installed);
    QString getApkIconPath() const;
    QString getApkName() const;
    QString getProgramName() const;
    bool getInstalled() const;

private:
    QString m_apkIconPath;
    QString m_apkName;
    QString m_programName;
    bool m_installed;
};

class ApkListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ApkListModel(QObject *parent = 0);
    int currentIndex() const;
    int count() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE int randomIndex();
    Q_INVOKABLE void add(QString filePath);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void remove(int first, int last);
    Q_INVOKABLE void removeOne(int index);
    void setCurrentIndex(const int & i);
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)

    enum ApkRole {
        apkIconPathRole = Qt::UserRole + 1,
        apkNameRole,
        programNameRole,
        installedRole,
    };

signals:
    void currentIndexChanged();
    void countChanged();

public slots:

private:
    QHash<int, QByteArray> roleNames() const;
    void addApk(QString apkIconPath, QString apkName, QString programName, bool installed);

    int m_currentIndex;
    QList<Apk> ApkData;
};

#endif // APKLISTMODEL_H
