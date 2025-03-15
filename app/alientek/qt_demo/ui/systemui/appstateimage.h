/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         appstateimage.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-18
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#ifndef APPSTATEIMAGE_H
#define APPSTATEIMAGE_H

#include <QQuickPaintedItem>
#include <QVariant>
#include <QQuickItem>
#include <QImage>
#include <QPixmap>

class AppStateImage : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QVariant source READ source WRITE setSource NOTIFY sourceChanged)
public:
    explicit AppStateImage(QQuickItem *parent = nullptr);
    QVariant source() const;

    void setSource(const QVariant &source);
protected:
    void paint(QPainter *painter) override;
signals:
    void sourceChanged();

private:
    QVariant m_source;
    QPixmap m_pixmapsrc;
};

#endif // APPSTATEIMAGE_H
