#include "WeatherParser.h"
#include <QDebug>

WeatherParser::WeatherParser(QObject *parent)
    : QObject(parent), m_weatherInfo("正在获取天气数据...")
{
}

void WeatherParser::updateData(const QByteArray &jsonData)
{
    QJsonDocument doc = QJsonDocument::fromJson(jsonData);
    if (doc.isNull()) {
        m_weatherInfo = "数据解析失败";
        emit weatherInfoChanged();
        return;
    }

    QJsonObject root = doc.object();
    if (!root.contains("data") || !root["data"].isObject()) {
        m_weatherInfo = "数据格式错误";
        emit weatherInfoChanged();
        return;
    }

    QJsonObject data = root["data"].toObject();
    QString newInfo = parseWeatherData(data);

    if (m_weatherInfo != newInfo) {
        m_weatherInfo = newInfo;
        emit weatherInfoChanged();
    }
}

QString WeatherParser::weatherInfo() const
{
    return m_weatherInfo;
}

QString WeatherParser::parseWeatherData(const QJsonObject &data)
{
    // 解析实时天气数据
    if (!data.contains("real") || !data["real"].isObject()) {
        return "缺少实时天气数据";
    }

    QJsonObject realData = data["real"].toObject();

    // 获取温度
    double temperature = 0.0;
    if (realData.contains("weather") && realData["weather"].isObject()) {
        QJsonObject weather = realData["weather"].toObject();
        temperature = weather["temperature"].toDouble(0.0);
    }

    // 获取天气状况
    QString condition = "未知";
    if (realData.contains("weather") && realData["weather"].isObject()) {
        QJsonObject weather = realData["weather"].toObject();
        condition = weather["info"].toString("未知");
    }

    // 获取风速
    QString windInfo = "未知";
    if (realData.contains("wind") && realData["wind"].isObject()) {
        QJsonObject wind = realData["wind"].toObject();
        QString direct = wind["direct"].toString("");
        double speed = wind["speed"].toDouble(0.0);
        windInfo = QString("%1 %2m/s").arg(direct).arg(speed);
    }

    return QString("温度: %1°C | 天气: %2 | 风速: %3")
        .arg(temperature)
        .arg(condition)
        .arg(windInfo);
}
