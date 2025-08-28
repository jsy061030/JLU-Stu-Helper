// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick 6.5
//import UntitledProject
import QtQuick.Controls 6.5
import QtQuick.Dialogs


Window {
    x: 0
    y: 0
    height:  1024 * 2 /3
    width: 1024 * 2 /3
    maximumHeight: 1024 * 2 /3
    minimumHeight: 1024 * 2 /3
    maximumWidth: 768 * 2 /3
    minimumWidth: 768 * 2 /3
    id: mainWindow
    visible: true
    title: "吉林大学学生工具箱"
    property int colorTheme: 1

    function setDarkTheme() {
        ;
    }
    function setLightTheme(){
        ;
    }
    // 网络请求函数
    function fetchWeather() {
        var xhr = new XMLHttpRequest()
        xhr.open('GET', 'https://www.nmc.cn/rest/weather?stationid=mxFBj')
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    weatherParser.updateData(xhr.responseText)
                } else {
                    weatherText.text = "更新失败❌"
                    errorDialog.open()
                }
            }
        }
        xhr.send()
    }
    function formatWeather(data) {
        return `温度: ${data.dayTemp}℃/${data.nightTemp}℃\n天气: ${data.condition}\n风速: ${data.wind}`
    }
    Rectangle {
        id: rectangleMain
        x: 0
        y: 0

        width: mainWindow.maximumWidth
        height: mainWindow.maximumHeight
        color: "#ffffff"

        Text {
            id: yellowpage
            x: 8
            y: 8
            text: qsTr("吉大学生黄页")
            font.pixelSize: 35
        }
        function getWeekDay(date) {
                const weekDays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
                return weekDays[date.getDay()];
            }
        Text {
            id: currentTime
            x: yellowpage.x + yellowpage.width + 5
            y: yellowpage.y + 10
            text: Qt.formatDateTime(new Date(), "MM-dd hh:mm:ss")
            font.pixelSize: 24
            Timer {
                interval: 1000 // 每秒触发
                running: true // 自动启动
                repeat: true
                id: timer1
                onTriggered: {
                    const time = new Date()
                    currentTime.text = Qt.formatDateTime(time, "MM-dd hh:mm:ss")
                    delete time
                }

            }
        }


        Text {
            id: weekWhat
            x: currentTime.x + currentTime.width + 5
            y: yellowpage.y + 10
            text: qsTr(rectangleMain.getWeekDay(new Date()))
            font.pixelSize: 24
        }

        Rectangle {
            id: rectangle
            x: 0
            y: 49
            width: rectangleMain.width
            height: rectangleMain.height
            color: "gray"

            Text {
                id: weatherText
                x: 8
                y: 16
                text: weatherParser.weatherInfo
                font.pixelSize: 17
                // property var weatherParser
                Timer {
                    id: weatherTimer
                    interval: 3600000 // 每小时更新
                    running: true
                    triggeredOnStart: true // 启动时立即加载一次
                    onTriggered: fetchWeather()
                }
                MessageDialog {
                    id: errorDialog
                    title: "网络错误"
                    buttons: MessageDialog.Ok
                    text: "天气数据获取失败，请检查网络连接"
                }
                Connections {
                    target: weatherParser
                    function onDataUpdated() {
                        weatherText.text = formatWeather(weatherParser.weatherInfo)
                    }
                }

            }

            Text {
                id: courseText
                x: 8
                y: weatherText.y + weatherText.height + 5
                text: qsTr("今日课表")
                font.pixelSize: 17
            }

            Rectangle {
                id: rectangle_color_yellow
                x: 479
                y: -35
                width: 25
                height: 25
                color: "black"

                MouseArea {
                    id: mouseArea
                    x: 0
                    y: 0
                    width: 25
                    height: 25
                    onClicked: {
                        mainWindow.colorTheme = 1 - mainWindow.colorTheme

                        if (mainWindow.colorTheme == 1)
                            mainWindow.setDarkTheme();
                        else
                            mainWindow.setLightTheme();
                    }

                }
            }
        }

        Text {
            id: text3
            x: 8
            y: 554
            text: qsTr("快捷入口")
            font.pixelSize: 24
        }
        Button {
            id: button_login
            x: 8
            y: 602
            width: 150
            text: qsTr("校园网登录")
            MessageDialog {
                id: loginError
                title: "Error"
                buttons: MessageDialog.Ok
                text: "启动失败。请查看drcom-jlu-qt文件夹下的文件是否完整。\n\nWindows系统请先安装drcom-jlu-qt目录下的vc_redist.exe。"
            }
            onClicked: {
                    if (!systemHelper.startDrcom()) {
                        console.error("启动 drcom 失败！")
                    }
                    loginError.open()
            }
        }
        Button {
            id: button_iedu
            x: button_login.x + button_login.width + 20
            y: button_login.y
            width: 150
            text: qsTr("教务系统")
            onClicked: systemHelper.openWebsite("http://iedu.jlu.edu.cn")
            font.pointSize: 12
        }
        Button {
            id: button_icourses
            x: button_iedu.x + button_iedu.width + 20
            y: button_login.y
            width: 150
            text: qsTr("选课系统")
            onClicked: systemHelper.openWebsite("http://icourses.jlu.edu.cn")
            font.pointSize: 12
        }

        Button {
            id: button_library
            x: button_login.x
            y: button_login.y + button_login.height + 5
            width: 150
            onClicked: systemHelper.openWebsite("http://lib.jlu.edu.cn")
            text: qsTr("在线图书馆")
        }
    }


}

