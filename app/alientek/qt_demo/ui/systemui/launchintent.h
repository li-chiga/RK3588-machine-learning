#ifndef LAUNCHINTENT_H
#define LAUNCHINTENT_H

#include <QObject>

class LaunchIntent : public QObject
{
    Q_OBJECT
public:
    explicit LaunchIntent(QObject *parent = nullptr);

signals:
    void noAppFile();

public slots:
    void lauchApp(const QString &appName);

};

#endif // LAUNCHINTENT_H
