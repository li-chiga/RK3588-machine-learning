/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         notepadListModel.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-25
*******************************************************************/
#ifndef NOTEPADLISTMODEL_H
#define NOTEPADLISTMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QUrl>

class Notepad {
public:
    explicit Notepad(QUrl path, QString title, QString content, QString lastModified);
    QString getcontent() const;
    QString getlastModified() const;
    QString gettitle() const;
    QUrl getpath() const;
    void settitle(QString title);

private:
    QString  m_title;
    QUrl m_path;
    QString m_content;
    QString m_lastModified;
};

class NotepadListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit NotepadListModel(QObject *parent = 0);
    int currentIndex() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE int randomIndex();
    Q_INVOKABLE QString getcurrentTitle() const;
    Q_INVOKABLE QUrl getcurrentPath() const;
    Q_INVOKABLE void add(QString paths);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void remove(int first, int last);
    Q_INVOKABLE void removeOne(int index);
    Q_INVOKABLE void setCurrentTitle(QString title);
    Q_INVOKABLE int count();
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    void setCurrentIndex(const int & i);

    enum NotepadRole {
        pathRole = Qt::UserRole + 1,
        titleRole,
        contentRole,
        lastModifiedRole,
    };

signals:
    void currentIndexChanged();
    void countChanged();

public slots:

private:
    QHash<int, QByteArray> roleNames() const;
    void addNotepad(QUrl path, QString title, QString content, QString lastModified);

    int m_currentIndex;
    QList<Notepad> notepadData;

};

#endif // NOTEPADLISTMODEL_H
