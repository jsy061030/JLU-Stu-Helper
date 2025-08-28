#include <QObject>
#include <QProcess>
#include <QDesktopServices>
#include <QQmlContext>
#include <QDir>
#include <QGuiApplication>
#include <filesystem> // C++17 文件系统库

class SystemHelper : public QObject {
    Q_OBJECT
public:
    explicit SystemHelper(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE bool startDrcom() {
        const QString appDir = QGuiApplication::applicationDirPath();
        QString executablePath;




// 根据平台构建子目录路径
#if defined(Q_OS_WIN)
        executablePath = appDir + "/drcom-jlu-qt/DrCOM_JLU_Qt.exe";
#elif defined(Q_OS_LINUX)
        executablePath = appDir + "/drcom-jlu-qt/drcom";
#elif defined(Q_OS_MACOS)
        executablePath = appDir + "/drcom-jlu-qt.app";
#endif

        // 检查文件是否存在
        if (!std::filesystem::exists(executablePath.toStdString())) {
            qWarning() << "Executable not found:" << executablePath;
            return false;
        }

// 执行命令（macOS 需用 open 命令启动 .app）
#if defined(Q_OS_MACOS)
        return QProcess::startDetached("open", {"-a", executablePath});
#else
        return QProcess::startDetached(executablePath);
#endif
    }



    Q_INVOKABLE void openWebsite(const QString &url) {
        QDesktopServices::openUrl(QUrl(url));
    }
};


