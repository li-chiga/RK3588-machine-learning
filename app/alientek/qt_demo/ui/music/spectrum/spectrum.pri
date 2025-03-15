SOURCES  += $$PWD/engine.cpp \
            $$PWD/frequencyspectrum.cpp \
            $$PWD/spectrumanalyser.cpp \
            $$PWD/tonegenerator.cpp \
            $$PWD/utils.cpp \
            $$PWD/wavfile.cpp \
            $$PWD/spectrograph.cpp

HEADERS  += $$PWD/engine.h \
            $$PWD/frequencyspectrum.h \
            $$PWD/spectrum.h \
            $$PWD/spectrumanalyser.h \
            $$PWD/tonegenerator.h \
            $$PWD/utils.h \
            $$PWD/wavfile.h \
            $$PWD/spectrograph.h

fftreal_dir = 3rdparty/fftreal

INCLUDEPATH += $${fftreal_dir}
