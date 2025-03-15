/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         filereadwrite.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-25
*******************************************************************/
#ifndef FILEREADWRITE_H
#define FILEREADWRITE_H

#include <QObject>
#include <QFile>

enum FileStatus {
    NoExists = 0,
    OpenError,
    Opened,
    Closed,
    UnKnow
};

class FileReadWrite : public QObject
{
    Q_OBJECT

private:
    int m_fileStatus;
    QString m_content;
    QString m_currtentFileName;
    bool m_needToSaveFlag;
public:
    explicit FileReadWrite(QObject *parent = 0);
    ~FileReadWrite();
    Q_INVOKABLE int openFile(QString file);
    Q_INVOKABLE int newFile(QString file);
    Q_INVOKABLE int closeFile(QString content);
    Q_INVOKABLE QString content();
    Q_INVOKABLE void setNeedToSaveFlag(bool flag);
    int fileStatus();
    QString currtentFileName();
    bool needToSaveFlag();
    Q_PROPERTY(QString currtentFileName READ currtentFileName)
    Q_PROPERTY(int fileStatus READ fileStatus NOTIFY saveSucessed)
    Q_PROPERTY(bool needToSaveFlag READ needToSaveFlag)
    QFile myFile;
signals:
    void saveSucessed();

};
#endif // FILEREADWRITE_H
