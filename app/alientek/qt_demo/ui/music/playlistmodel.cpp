/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         playlistmodel.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-29
*******************************************************************/
#include "playlistmodel.h"
#include <QDir>
#include <QDebug>
#include <QDirIterator>
#include <QByteArray>
#include <iostream>
#include <locale>
#include <cstdlib>
#if WIN32
#include <windows.h>
#endif

#include <iostream>
#include <fstream>
#include <locale>
#include <codecvt>

using namespace std;
song::song(QUrl path, QString title, QString author, QString songName) {
    m_author = author;
    m_path = path;
    m_title = title;
    m_songName = songName;
}

QString song::getauthor() const {
    return m_author;
}

QUrl song::getpath() const {
    return m_path;
}

QString song::gettitle() const {
    return m_title;
}

QString song::getsongname() const
{
    return m_songName;
}

void song::setauthor(QString author) {
    m_author = author;
}

void song::settitle(QString title) {
    m_title = title;
}

playListModel::playListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
}

int playListModel::currentIndex() const {
    return m_currentIndex;
}

QString playListModel::songName() const
{
    return m_songName;
}

int playListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return playListData.count();
}

QVariant playListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= playListData.count())
        return QVariant();
    const song &s = playListData.at(index.row());
    switch (role) {
    case pathRole:
        return s.getpath();
    case authorRole:
        return s.getauthor();
    case titleRole:
        return s.gettitle();
    default:
        return QVariant();
    }
}

int playListModel::randomIndex() {
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % playListData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString playListModel::getcurrentTitle() const {
    return playListData.at(m_currentIndex).gettitle();
}

QString playListModel::getcurrentAuthor() const {
    return playListData.at(m_currentIndex).getauthor();
}

QString playListModel::getcurrentSongName() const
{
    return playListData.at(m_currentIndex).getsongname();
}

QUrl playListModel::getcurrentPath() const {
    return playListData.at(m_currentIndex).getpath();
}

void playListModel::add(QString paths) {
    revert();
    artistDir = paths + "/resource/artist/";

    QAudioDecoder ad;
    QString author, title;

    paths = paths + "/resource/audio/";
    QDir dir(paths);
    if(!dir.exists()){
        qDebug()<< paths + "/src/audio Dir not exist";
        return ;
    }

    QStringList filter;
    filter<<"*.mp3"<<"*.flac"<<"*.wav";
    /* QDirIterator: : Subdirectories the fourth parameter can set up a file
     * the iterator marks accords with a condition to access a folder in the file,
     * but will be slowly
     */

    QDir dir2(dir.absolutePath());
    if (dir2.exists()) {
        QFileInfoList files = dir2.entryInfoList(filter, QDir::Files, QDir::Name);
        for (int i = 0; i < files.count(); i++) {
#ifdef WIN32
            QUrl songsPath = QString::fromUtf8((files.at(i).filePath().toUtf8().data()));

#else
            QUrl songsPath = QString::fromUtf8((QString("file:///" + files.at(i).filePath()).toUtf8().data()));
#endif
            ad.setSourceFilename(songsPath.toLocalFile());
            MP3INFO mysong = GetAllInfo(files.at(i).filePath());
            title = mysong.Name;
            author = mysong.Singer;
            addSong(songsPath, title, author, files.at(i).baseName());
        }
    }
    /*
    count = pathList.count();
    for (index = 0; index < count; index ++) {
        ad.setSourceFilename(pathList.at(index).toLocalFile());
        MP3INFO mysong = GetAllInfo(fileName[index]);
        qDebug() << index;
        title = mysong.Name;
        author = mysong.Singer;
#if 0
        if (ad.metaData("Title").isNull()) {
            title = pathList.at(index).fileName(QUrl::FullyDecoded).remove(-4, 4);
            //title = pathList.at(index).fileName(QUrl::FullyDecoded).remove(-4, 4);
        } else {
            title = ad.metaData("Title").toString();
        }
        if (ad.metaData("Author").isNull()) {
            author = tr("匿名");
        } else {
            author = ad.metaData("Author").toStringList().first();
        }
#endif
        addSong(pathList.at(index), title, author);
    }
    */
    if (m_currentIndex < 0 && playListData.count()) {
        setCurrentIndex(0);
    }
    revert();
}

void playListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    playListData.move(from, to);
    endMoveRows();
}

void playListModel::remove(int first, int last) {
    if ((first < 0) && (first >= playListData.count()))
        return;
    if ((last < 0) && (last >= playListData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        playListData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= playListData.count()) {
        setCurrentIndex(playListData.count() - 1);
    }
}

void playListModel::setCurrentTitle(QString title) {
    QModelIndex mi = createIndex(m_currentIndex, 0, (void *) 0);
    QVector<int> role;
    role.append(titleRole);
    song s = playListData.at(m_currentIndex);
    s.settitle(title);
    playListData.replace(m_currentIndex, s);
    emit dataChanged(mi, mi, role);
}

void playListModel::setCurrentAuthor(QString author) {
    QModelIndex mi = createIndex(m_currentIndex, 0, (void *) 0);
    QVector<int> role;
    role.append(authorRole);
    song s = playListData.at(m_currentIndex);
    s.setauthor(author);
    playListData.replace(m_currentIndex, s);
    emit dataChanged(mi, mi, role);
}

bool playListModel::checkTheAlbumImageIsExists(QUrl file)
{
    return QFile::exists(file.toLocalFile());
}

void playListModel::setCurrentIndex(const int & i) {
    if (i >= playListData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        if (playListData.count() > 0)
            m_songName = playListData[m_currentIndex].getsongname();
        emit songNameChanged();
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < playListData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        m_songName = playListData[i].getsongname();
        emit currentIndexChanged();
        emit songNameChanged();
    }
}

QHash<int, QByteArray> playListModel::roleNames() const {
    QHash<int, QByteArray> role;
    role[authorRole] = "author";
    role[pathRole] = "path";
    role[titleRole] = "title";
    return role;
}

void playListModel::addSong(QUrl path, QString title, QString author, QString songName) {
    beginInsertRows(QModelIndex(), playListData.count(), playListData.count());
    playListData.append(song(path, title, author, songName));
    endInsertRows();
}

MP3INFO playListModel::GetAllInfo(QString filePath) {

    QString songName = "";
    std::string utf8Path = filePath.toUtf8().constData();
    fp = fopen(utf8Path.c_str(), "r");

    if (NULL == fp){
        qDebug() << "open read file error";
        MP3INFO falseInfo;
        falseInfo.pic_flag = false;
        return falseInfo;
    }
    fseek(fp, 0,SEEK_SET);
    fread(&Header,1,3,fp);

    unsigned int i = 10;
    MP3INFO mp3info_struct;
    mp3info_struct.Url = filePath;
    mp3info_struct.number = 1;

    QFile file(filePath);
    if(file.exists()) {
        QFileInfo fileInfo(file);
        songName = fileInfo.baseName();
        //qDebug() << songName;
    }

    if(Header[0] == 'I' && Header[1] == 'D' && Header[2] == '3') {
        //qDebug()<<"open ID3 correct!";
    } else {
        //qDebug()<<"open ID3 incorrect!";
        mp3info_struct.Picture_type = " ";
        mp3info_struct.beginNum = 0;
        mp3info_struct.lenth = 0;
        mp3info_struct.Picture_url = " ";
        mp3info_struct.Name = songName;
        mp3info_struct.Singer = "未知歌手";
        mp3info_struct.Album = "未知专辑";
        mp3info_struct.pic_flag = true;
        return mp3info_struct;
    }

    QFile dir(artistDir);
    if(!dir.exists()) {
        qDebug() << artistDir <<"Dir not exist";
        return mp3info_struct;
    }

    while(i < (mp3_TagSize - 10)) {
        frameIDStruct m_struct;

        fseek(fp, i, SEEK_SET);
        fread(&FrameId, 1, 4, fp);
        fseek(fp, 4 + i, SEEK_SET);
        fread(&frameSize, 1, 4, fp);
        framecount = frameSize[0] * 0x1000000 + frameSize[1] * 0x10000 + frameSize[2] * 0x100 + frameSize[3];
        //qDebug()<<"framecount:"<<framecount;
        QString aa;
        aa = FrameId[0];
        aa += FrameId[1];
        aa += FrameId[2];
        aa += FrameId[3];
        //qDebug()<<"aa:"<<aa;
        m_struct.beginNum = i + 10;
        m_struct.FrameId = aa;
        i = 10 + i + framecount;
        m_struct.endNum = i;
        if (m_struct.FrameId == "APIC") {
            break;
        } else {
            if (i > 1000) {
                mp3info_struct.Picture_type = " ";
                mp3info_struct.beginNum = 0;
                mp3info_struct.lenth = 0;
                mp3info_struct.Picture_url = " ";
                mp3info_struct.Name = songName;
                mp3info_struct.Singer = "未知歌手";
                mp3info_struct.Album = "未知专辑";
                mp3info_struct.pic_flag = true;
                return mp3info_struct;
            }
        }
    }
    i = 10;
    while(i < (mp3_TagSize - 10)) {
        frameIDStruct m_struct;

        fseek(fp, i, SEEK_SET);
        fread(&FrameId, 1, 4, fp);
        fseek(fp, 4 + i, SEEK_SET);
        fread(&frameSize, 1, 4, fp);
        framecount = frameSize[0] * 0x1000000 + frameSize[1] * 0x10000 + frameSize[2] * 0x100 + frameSize[3];
        //qDebug()<<"framecount:"<<framecount;
        QString aa;
        aa = FrameId[0];
        aa += FrameId[1];
        aa += FrameId[2];
        aa += FrameId[3];
        //qDebug()<<"aa:"<<aa;
        m_struct.beginNum = i + 10;
        m_struct.FrameId = aa;
        i = 10 + i + framecount;
        m_struct.endNum = i;
        m_IDmap.insert(aa, m_struct);
        int lenth = m_struct.endNum - m_struct.beginNum;
        if (m_struct.FrameId == "APIC") {
            QFile file(artistDir + songName + ".jpg");
            QFile file2(artistDir + songName + ".png");
            if (file.exists() || file2.exists())
                break;
            unsigned char temp[20] = {0};
            fseek(fp, m_struct.beginNum,SEEK_SET);
            fread(&temp, 1, 20, fp);
            int tank = 0;
            int j = 0;
            int pictureFlag = 0;
            while(1) {
                if((temp[j] == 0xff) && (temp[j + 1] == 0xd8)) { //jpeg
                    tank = j;
                    pictureFlag=1;
                    mp3info_struct.Picture_type = ".jpg";
                    //qDebug()<<"j:"<<j;
                    break;
                } else if((temp[j] == 0x89) && (temp[j + 1] == 0x50)) { //png
                    tank = j;
                    pictureFlag = 2;
                    mp3info_struct.Picture_type = ".png";
                    qDebug()<<"png";
                    //qDebug()<<"j:"<<j;
                    break;
                }
                j++;
            }
            //qDebug()<<"frameSize:"<<i;
            unsigned char t[lenth] ;
            fseek(fp, m_struct.beginNum+tank, SEEK_SET);
            mp3info_struct.beginNum = m_struct.beginNum + tank;
            mp3info_struct.lenth = lenth;
            fread(&t, 1, lenth, fp);
            if (pictureFlag == 1)  {  //jpeg
                QString temp_1;
                temp_1 = artistDir + songName;
                temp_1 += ".jpg";
                //qDebug() << temp_1;
                mp3info_struct.Picture_url = temp_1;
                std::string str_temp = temp_1.toStdString();
                const char *ch = str_temp.c_str();
                FILE *fpw = fopen( ch, "wb" );
                fwrite(&t,lenth,1,fpw);
                fclose(fpw);
            } else if(pictureFlag == 2) {  // png
                QString temp_1;
                temp_1 = artistDir + songName;
                temp_1 += ".png";
                mp3info_struct.Picture_url = temp_1;
                std::string str_temp = temp_1.toStdString();
                const char *ch = str_temp.c_str();
                FILE *fpw = fopen( ch, "wb" );
                fwrite(&t, lenth, 1, fpw);
                fclose(fpw);
                fclose(fp);
            }
        } else if(m_struct.FrameId == "TIT2") {  //title
            QFile file(filePath);
            if(!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
                qDebug()<<"Can't open the file!";
                MP3INFO falseInfo;
                falseInfo.pic_flag = false;
                return falseInfo;
            }
            QTextStream stream(&file);
            stream.seek(m_struct.beginNum + 1);
            QString all = stream.readLine(lenth - 1);
            QTextCodec *codec = QTextCodec::codecForName("UTF-8");
            QString ua = codec->toUnicode(all.toLocal8Bit().data());
            QString unser = ua.mid(0,(int)(lenth/2-1));
            mp3info_struct.Name = unser;
            //mp3info_struct.beginNum = m_struct.beginNum;
            //mp3info_struct.lenth = lenth;
            file.close();
        } else if (m_struct.FrameId == "TPE1") {      // singer

            QFile file(filePath);
            if(!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
                qDebug()<<"Can't open the file!";
                MP3INFO falseInfo;
                falseInfo.pic_flag = false;
                return falseInfo;
            }
            QTextStream stream(&file);
            stream.seek(m_struct.beginNum + 1);
            QString all= stream.readLine(lenth - 1);
            QTextCodec *codec = QTextCodec::codecForName("UTF-8");
            QString ua = codec->toUnicode(all.toLocal8Bit().data());
            QString unser = ua.mid(0,(int)(lenth / 2 - 1));
            mp3info_struct.Singer = unser;
            //mp3info_struct.beginNum = m_struct.beginNum;
            //mp3info_struct.lenth = lenth;
            file.close();
        } else if (m_struct.FrameId == "TALB") {  // 专辑
            QFile file(filePath);
            if(!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
                qDebug()<<"Can't open the file!";
                MP3INFO falseInfo;
                falseInfo.pic_flag = false;
                return falseInfo;
            }
            QTextStream stream(&file);
            stream.seek(m_struct.beginNum + 1);
            QString all= stream.readLine(lenth - 1);
            QTextCodec *codec = QTextCodec::codecForName("UTF-8");
            QString ua = codec->toUnicode(all.toLocal8Bit().data());
            QString unser = ua.mid(0,(int)(lenth/2-1));
            mp3info_struct.Album = unser;
            //mp3info_struct.beginNum = m_struct.beginNum;
            //mp3info_struct.lenth = lenth;
            file.close();
        }
        //qDebug()<<"frameSize:"<<i;
        if(aa == "APIC")
            break;
    }
    mp3info_struct.pic_flag = true;
    system("sync");
    return mp3info_struct;
}

