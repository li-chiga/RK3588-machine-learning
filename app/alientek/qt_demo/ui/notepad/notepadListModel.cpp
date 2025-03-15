/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         notepadListModel.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-25
*******************************************************************/
#include "notepadListModel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QDateTime>

Notepad::Notepad(QUrl path, QString title, QString content, QString lastModified) {
    m_path = path;
    m_title = title;
    m_content = content;
    m_lastModified = lastModified;
}

QUrl Notepad::getpath() const {
    return m_path;
}

QString Notepad::gettitle() const {
    return m_title;
}

QString Notepad::getcontent() const {
    return m_content;
}

QString Notepad::getlastModified() const {
    return m_lastModified;
}

void Notepad::settitle(QString title) {
    m_title = title;
}

NotepadListModel::NotepadListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
}

int NotepadListModel::currentIndex() const {
    return m_currentIndex;
}

int NotepadListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return notepadData.count();
}

QVariant NotepadListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= notepadData.count())
        return QVariant();
    const Notepad &s = notepadData.at(index.row());
    switch (role) {
    case pathRole:
        return s.getpath();
    case titleRole:
        return s.gettitle();
    case contentRole:
        return s.getcontent();
    case lastModifiedRole:
        return s.getlastModified();
    default:
        return QVariant();
    }
}

int NotepadListModel::randomIndex()
{
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % notepadData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString NotepadListModel::getcurrentTitle() const
{
    return notepadData.at(m_currentIndex).gettitle();
}

QUrl NotepadListModel::getcurrentPath() const {
    return notepadData.at(m_currentIndex).getpath();
}

void NotepadListModel::add(QString paths)
{
    if (notepadData.count() > 0)
        this->remove(0, notepadData.count() - 1);
    revert();

    int count, index;
    QString  title;
    QString content;
    QString lastModified;
    QDir dir(paths);

    if(!dir.exists()) {
        qDebug()<< paths + " does not exist";
        return;
    }

    QStringList filter;
    filter<<"*.txt"<<"*.text";

    QDirIterator it(paths, filter, QDir::Files | QDir::NoSymLinks);
    QList<QUrl> pathList;

    while (it.hasNext()){
        it.next();

        QFileInfo fileif = it.fileInfo();
        lastModified = fileif.lastModified().toString("MM-dd hh:mm");
#ifdef WIN32
        QUrl notepadPath = QString::fromUtf8((fileif.filePath().toUtf8().data()));
#else
        QUrl notepadPath = QString::fromUtf8((QString("file:///" + fileif.filePath()).toUtf8().data()));
#endif
        pathList.append(notepadPath);
    }

    count = pathList.count();
    for (index = 0; index < count; index ++) {

        title = pathList.at(index).fileName(QUrl::FullyDecoded);
#ifdef WIN32
        QFile file(pathList.at(index).toString());
#else
        QFile file(pathList.at(index).toString().mid(8));
#endif
        if (!file.exists())
            qDebug() << title << "does not exists" << endl;
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << title << "open failed" << endl;
        }

        content = QString(file.readLine()).trimmed();

        if (content.length() > 20)
            content = content.mid(0, 20) + "...";
        else
            content = content.mid(0, content.length());

        addNotepad(pathList.at(index), title, content, lastModified);
        file.close();
    }

    if (m_currentIndex < 0 && notepadData.count()) {
        setCurrentIndex(0);
    }
    revert();
    emit countChanged();
}

void NotepadListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    notepadData.move(from, to);
    endMoveRows();
}

void NotepadListModel::remove(int first, int last)
{
    if ((first < 0) && (first >= notepadData.count()))
        return;
    if ((last < 0) && (last >= notepadData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        notepadData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= notepadData.count()) {
        setCurrentIndex(notepadData.count() - 1);
    }
    emit countChanged();
}

void NotepadListModel::removeOne(int index)
{
#ifdef WIN32
    QFile file(notepadData.at(index).getpath().toString());
#else
    QFile file(notepadData.at(index).getpath().toString().mid(8));
#endif
    beginRemoveRows(QModelIndex(), index, index);
    notepadData.removeAt(index);
    if (file.remove())
        qDebug() << "delete ok" <<endl;
    endRemoveRows();
    if (m_currentIndex >= notepadData.count()) {
        setCurrentIndex(notepadData.count() - 1);
    }
}

void NotepadListModel::setCurrentTitle(QString title)
{
    Notepad s = notepadData.at(m_currentIndex);
    s.settitle(title);
    notepadData.replace(m_currentIndex, s);
}

int NotepadListModel::count()
{
    return notepadData.count();
}

void NotepadListModel::setCurrentIndex(const int & i)
{
    if (i >= notepadData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < notepadData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> NotepadListModel::roleNames() const
{
    QHash<int, QByteArray> role;
    role[pathRole] = "path";
    role[titleRole] = "title";
    role[contentRole] = "content";
    role[lastModifiedRole] = "lastModified";
    return role;
}

void NotepadListModel::addNotepad(QUrl path, QString title, QString content, QString lastModified) {
    beginInsertRows(QModelIndex(), notepadData.count(), notepadData.count());
    notepadData.append(Notepad(path, title, content, lastModified));
    endInsertRows();
    emit countChanged();
}

