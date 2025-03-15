/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         imageanalyzer.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-20
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include <QQuickItem>
#include <QImage>
#include <QColor>
#include <QUrl>

class ImageAnalyzer : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY(qreal dominantHue READ dominantHue NOTIFY dominantHueChanged)

public:
    ImageAnalyzer(QQuickItem *parent = nullptr);
    ~ImageAnalyzer();

    qreal dominantHue() const;

signals:
    void dominantHueChanged();

public slots:
    void analyzeImage(const QUrl &imageUrl);

private:
    qreal m_dominantHue;
};
