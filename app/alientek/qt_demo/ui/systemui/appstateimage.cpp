/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         appstateimage.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-18
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "appstateimage.h"
#include <QPainter>
#include <QPainterPath>
#include <QDebug>
#include <QRectF>
AppStateImage::AppStateImage(QQuickItem *parent) : QQuickPaintedItem(parent)
{
    setFlag(ItemHasContents, true);
    connect(this, SIGNAL(sourceChanged()), this, SLOT(update()));
}

QVariant AppStateImage::source() const
{
    return m_source;
}

void AppStateImage::setSource(const QVariant &source)
{
    if (source.isNull())
        return;
    if(m_source != source) {
        QImage image;
        bool isLoaded = image.loadFromData(source.toByteArray());
        if (isLoaded) {
            m_source = source;
            m_pixmapsrc = QPixmap::fromImage(image);
            qDebug() << "app image changed!";
        }
    }

    emit sourceChanged();

}

void AppStateImage::paint(QPainter *painter)
{
    if (painter == nullptr) {
        return;
    }
    if (m_pixmapsrc.isNull())
        return;

    painter->drawPixmap(0, 0, this->width(), this->height(), m_pixmapsrc);
}

