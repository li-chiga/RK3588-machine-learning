/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         audiospectrumanalyzer.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-23
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include <QObject>
#include <QMediaPlayer>
#include <QAudioProbe>
#include <QAudioBuffer>
#include "engine.h"
#include "spectrum.h"
#include "spectrograph.h"
class AudioSpectrumAnalyzer : public QObject
{
    Q_OBJECT

public:
    explicit AudioSpectrumAnalyzer(QObject *parent = nullptr);
    ~AudioSpectrumAnalyzer();
signals:
    void signalGetMediaData(const QAudioBuffer &audioBuffer);
    void barValueChanged(const double &value);
public slots:
    void setMediaPlayer(const QVariant &mediaPlayer);
    void spectrumChanged(qint64 position, qint64 length, const FrequencySpectrum &spectrum);
    void reset();
private:
    QAudioProbe *audioProbe;
    Engine*     m_engine;  // 频谱
    Spectrograph*   m_spectrograph;// 频谱仪计算，包括bar的值计算，bar取值0.0～1.0
};
