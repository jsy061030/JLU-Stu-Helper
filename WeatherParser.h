#ifndef WEATHERPARSER_H
#define WEATHERPARSER_H

#include <QObject>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class WeatherParser : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString weatherInfo READ weatherInfo NOTIFY weatherInfoChanged)

public:
    explicit WeatherParser(QObject *parent = nullptr);

    Q_INVOKABLE void updateData(const QByteArray &jsonData);
    QString weatherInfo() const;

signals:
    void weatherInfoChanged();

private:
    QString parseWeatherData(const QJsonObject &jsonObject);
    QString m_weatherInfo;
};

#endif // WEATHERPARSER_H
