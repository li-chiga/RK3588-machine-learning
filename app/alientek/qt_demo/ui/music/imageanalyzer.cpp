/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         imageanalyzer.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-20
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "imageanalyzer.h"

ImageAnalyzer::ImageAnalyzer(QQuickItem *parent)
    : QQuickItem(parent),
      m_dominantHue(0)
{

}

ImageAnalyzer::~ImageAnalyzer()
{

}

void ImageAnalyzer::analyzeImage(const QUrl &imageUrl)
{
    QString localFilePath = imageUrl.toLocalFile();
    QImage image(localFilePath);
    if (!image.isNull()) {
        QColor dominantColor = image.scaled(1, 1).pixelColor(0, 0);
        m_dominantHue = dominantColor.hueF();
        emit dominantHueChanged();
    }
}

qreal ImageAnalyzer::dominantHue() const
{
    return m_dominantHue;
}
