/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         audiospectrumanalyzer.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2023-10-23
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "audiospectrumanalyzer.h"
#include <QDebug>
AudioSpectrumAnalyzer::AudioSpectrumAnalyzer(QObject *parent) : QObject(parent)
{
}

AudioSpectrumAnalyzer::~AudioSpectrumAnalyzer()
{
}

void AudioSpectrumAnalyzer::setMediaPlayer(const QVariant &mediaPlayer)
{
    QMediaPlayer *player = qvariant_cast<QMediaPlayer*>(mediaPlayer);
    if (!player) {
        qDebug() << "Unable to find media player in qml";
        return;
    }
    m_spectrograph = new Spectrograph(this);
    m_spectrograph->setParams(SpectrumNumBands, SpectrumLowFreq, SpectrumHighFreq);
    connect(m_spectrograph, SIGNAL(barValueChanged(double)), this, SIGNAL(barValueChanged(double)));
    audioProbe = new QAudioProbe(this);
    m_engine = new Engine(this);
    connect(m_engine, QOverload<qint64, qint64, const FrequencySpectrum&>::of(&Engine::spectrumChanged),
            this, QOverload<qint64, qint64, const FrequencySpectrum&>::of(&AudioSpectrumAnalyzer::spectrumChanged));
    connect(this, QOverload<const QAudioBuffer&>::of(&AudioSpectrumAnalyzer::signalGetMediaData),
            m_engine, QOverload<const QAudioBuffer&>::of(&Engine::dealMediaData));

    QObject::connect(audioProbe, &QAudioProbe::audioBufferProbed, [=](const QAudioBuffer &audioBuffer)
    {
        emit signalGetMediaData(audioBuffer);
    });

    audioProbe->setSource(player);  // Returns true, hopefully.
}

void AudioSpectrumAnalyzer::spectrumChanged(qint64 position, qint64 length,
                                            const FrequencySpectrum &spectrum)
{
    m_spectrograph->spectrumChanged(spectrum);
}

void AudioSpectrumAnalyzer::reset()
{
    if (m_engine)
        m_engine->reset();
}

