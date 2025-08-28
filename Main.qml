import QtQuick 6.5
import QtQuick.Controls.Basic
import QtQuick.Controls 6.5
import QtQuick.Dialogs



Window {
    id: mainWindow
    width: 680
    height: 580
    visible: true
    title: "吉林大学学生黄页"
    minimumWidth: 680
    minimumHeight: 580

    // 主题颜色
    property color primaryColor: "#2c3e50"
    property color secondaryColor: "#3498db"
    property color backgroundColor: "#ecf0f1"
    property color textColor: "#2c3e50"

    // 获取天气数据函数
    function fetchWeather() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'https://www.nmc.cn/rest/weather?stationid=mxFBj');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    weatherParser.updateData(xhr.responseText);
                } else {
                    weatherInfoText.text = "更新失败，请检查网络";
                    console.error("HTTP错误:", xhr.status);
                }
            }
        };
        xhr.send();
    }

    // 获取星期几
    function getWeekDay(date) {
        const weekDays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
        return weekDays[date.getDay()];
    }

    Rectangle {
        anchors.fill: parent
        color: backgroundColor

        // 顶部标题栏
        Rectangle {
            id: header
            width: parent.width
            height: 60
            color: primaryColor

            Text {
                anchors.centerIn: parent
                text: "吉林大学学生工具箱"
                color: "white"
                font.pixelSize: 24
                font.bold: true
            }

            // 日期和时间显示
            Row {
                anchors {
                    right: parent.right
                    rightMargin: 20
                    verticalCenter: parent.verticalCenter
                }
                spacing: 10

                Text {
                    id: dateText
                    color: "white"
                    text: Qt.formatDateTime(new Date(), "yyyy-MM-dd")
                    font.pixelSize: 14
                }

                Text {
                    id: timeText
                    color: "white"
                    text: Qt.formatDateTime(new Date(), "hh:mm:ss")
                    font.pixelSize: 14
                }

                Text {
                    id: weekDayText
                    color: "white"
                    text: getWeekDay(new Date())
                    font.pixelSize: 14
                }
            }

            // 时间更新定时器
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    var currentDate = new Date();
                    timeText.text = Qt.formatDateTime(currentDate, "hh:mm:ss");
                    weekDayText.text = getWeekDay(currentDate);
                }
            }
        }

        // 主内容区域
        Column {
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 20
            }
            spacing: 20

            // 天气信息卡片
            Rectangle {
                width: parent.width
                height: 120
                radius: 8
                color: "white"
                border.color: "#ddd"

                Text {
                    id: weatherTitle
                    anchors {
                        top: parent.top
                        left: parent.left
                        margins: 15
                    }
                    text: "今日天气 (长春)"
                    font.pixelSize: 18
                    font.bold: true
                    color: textColor
                }

                Text {
                    id: weatherInfoText
                    anchors {
                        top: weatherTitle.bottom
                        left: parent.left
                        right: parent.right
                        margins: 15
                    }
                    text: weatherParser.weatherInfo
                    font.pixelSize: 16
                    color: textColor
                    wrapMode: Text.Wrap
                }

                // 天气更新按钮
                Button {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        margins: 10
                    }
                    text: "更新天气"
                    onClicked: fetchWeather()
                }

                // 天气自动更新定时器
                Timer {
                    interval: 3600000 // 1小时
                    running: true
                    repeat: true
                    onTriggered: fetchWeather()
                }

                Component.onCompleted: fetchWeather()
            }

            // 快捷入口区域
            Text {
                text: "快捷入口"
                font.pixelSize: 20
                font.bold: true
                color: textColor
            }

            Grid {
                width: parent.width
                columns: 3
                spacing: 15

                // 校园网登录按钮
                Button {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: 50
                    text: "校园网登录"
                    onClicked: {
                        if (!systemHelper.startDrcom()) {
                            loginErrorDialog.open();
                        }
                    }

                    MessageDialog {
                        id: loginErrorDialog
                        title: "启动失败"
                        buttons: MessageDialog.Ok
                        text: "请检查drcom-jlu-qt文件夹下的文件是否完整。\nWindows系统请先安装drcom-jlu-qt目录下的vc_redist.exe。"
                    }
                }

                // 教务系统按钮
                Button {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: 50
                    text: "教务系统"
                    onClicked: systemHelper.openWebsite("http://iedu.jlu.edu.cn")
                }

                // 选课系统按钮
                Button {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: 50
                    text: "选课系统"
                    onClicked: systemHelper.openWebsite("http://icourses.jlu.edu.cn")
                }

                // 在线图书馆按钮
                Button {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: 50
                    text: "在线图书馆"
                    onClicked: systemHelper.openWebsite("http://lib.jlu.edu.cn")
                }
            }
        }
    }

    // 全局错误对话框
    MessageDialog {
        id: errorDialog
        title: "网络错误"
        buttons: MessageDialog.Ok
        text: "天气数据获取失败，请检查网络连接"
    }
}
