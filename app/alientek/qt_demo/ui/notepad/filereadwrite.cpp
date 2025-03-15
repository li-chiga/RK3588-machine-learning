/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         filereadwrite.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-25
*******************************************************************/
#include "filereadwrite.h"
#include <QDebug>

FileReadWrite::FileReadWrite(QObject *parent) : QObject (parent), m_fileStatus(UnKnow),
    m_needToSaveFlag(false)
{
}

FileReadWrite::~FileReadWrite()
{

}

int FileReadWrite::fileStatus()
{
    return m_fileStatus;
}

QString FileReadWrite::content()
{
    return m_content;
}

QString FileReadWrite::currtentFileName()
{
    return m_currtentFileName;
}

bool FileReadWrite::needToSaveFlag()
{
    return m_needToSaveFlag;
}

void FileReadWrite::setNeedToSaveFlag(bool flag)
{
    m_needToSaveFlag = flag;
}

int FileReadWrite::openFile(QString file)
{
    m_needToSaveFlag =  false;
#if WIN32
    m_currtentFileName = file;
#else
    m_currtentFileName = file.mid(8);
#endif
    myFile.setFileName(m_currtentFileName);

    if (!myFile.exists()) {
        m_fileStatus = NoExists;
        return m_fileStatus;
    }

    if (!myFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        m_fileStatus = OpenError;
        return m_fileStatus;
    }

    m_content = QString(myFile.readAll());
    myFile.close();
    m_fileStatus = Closed;

    return m_fileStatus;
}

int FileReadWrite::closeFile(QString content)
{
    myFile.setFileName(m_currtentFileName);

    if (!myFile.exists()) {
        m_fileStatus = NoExists;
        return m_fileStatus;
    }

    if (!myFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        m_fileStatus = OpenError;
        return m_fileStatus;
    }

    QByteArray strBytes = content.toUtf8();

    myFile.write(strBytes, strBytes.length());

    myFile.close();

    m_fileStatus = Closed;

    if (!m_needToSaveFlag)
        myFile.remove();

    return m_fileStatus;
}

int FileReadWrite::newFile(QString file)
{
    m_needToSaveFlag =  false;
    m_currtentFileName = file;
    myFile.setFileName(m_currtentFileName);

    if (!myFile.open(QIODevice::ReadWrite | QIODevice::Text)) {
        m_fileStatus = OpenError;
        return m_fileStatus;
    }

    m_content = QString(myFile.readAll());
    myFile.close();
    m_fileStatus = Closed;

    return m_fileStatus;
}
