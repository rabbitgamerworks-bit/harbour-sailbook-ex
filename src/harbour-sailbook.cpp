#include <sailfishapp.h>
#include <QGuiApplication>
#include <QNetworkAccessManager>
#include <QNetworkProxyFactory>
#include <QNetworkRequest>
#include <QQmlEngine>
#include <QQmlNetworkAccessManagerFactory>
#include <QQuickView>
#include <QScopedPointer>

// Identifies Sailbook honestly to the services it talks to (Wikimedia asks
// every client for a descriptive User-Agent). No browser impersonation.
class SailbookNetworkAccessManager : public QNetworkAccessManager
{
public:
    using QNetworkAccessManager::QNetworkAccessManager;

protected:
    QNetworkReply *createRequest(Operation op, const QNetworkRequest &original, QIODevice *data) override
    {
        QNetworkRequest request(original);
        request.setHeader(QNetworkRequest::UserAgentHeader,
                          QStringLiteral("Sailbook/" APP_VERSION " (Sailfish OS; https://github.com/rabbitgamerworks-bit/harbour-sailbook-ex)"));
        return QNetworkAccessManager::createRequest(op, request, data);
    }
};

class SailbookNetworkFactory : public QQmlNetworkAccessManagerFactory
{
public:
    QNetworkAccessManager *create(QObject *parent) override
    {
        return new SailbookNetworkAccessManager(parent);
    }
};

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setApplicationVersion(QStringLiteral(APP_VERSION));

    // Respect the system / environment proxy settings.
    QNetworkProxyFactory::setUseSystemConfiguration(true);

    SailbookNetworkFactory networkFactory;
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->engine()->setNetworkAccessManagerFactory(&networkFactory);
    view->setSource(SailfishApp::pathToMainQml());
    view->show();

    return app->exec();
}
