#include <sailfishapp.h>
#include <QGuiApplication>
#include <QNetworkAccessManager>
#include <QNetworkCookie>
#include <QNetworkCookieJar>
#include <QRegularExpression>
#include <QNetworkProxyFactory>
#include <QNetworkRequest>
#include <QQmlEngine>
#include <QQmlNetworkAccessManagerFactory>
#include <QQuickView>
#include <QScopedPointer>

// Never stores or sends cookies for Facebook / Meta: when Sailbook reads the
// page address behind a pasted share link, Facebook cannot recognise or track
// the user, and there is no session that could ever be logged in.
static bool isMetaHost(const QUrl &url)
{
    static const QRegularExpression meta(QStringLiteral(
        "(^|\\.)(facebook\\.com|fb\\.com|fb\\.me|fb\\.watch|fbcdn\\.net|messenger\\.com|instagram\\.com|meta\\.com)$"),
        QRegularExpression::CaseInsensitiveOption);
    return meta.match(url.host()).hasMatch();
}

class SailbookCookieJar : public QNetworkCookieJar
{
public:
    using QNetworkCookieJar::QNetworkCookieJar;

    QList<QNetworkCookie> cookiesForUrl(const QUrl &url) const override
    {
        return isMetaHost(url) ? QList<QNetworkCookie>() : QNetworkCookieJar::cookiesForUrl(url);
    }

    bool setCookiesFromUrl(const QList<QNetworkCookie> &cookies, const QUrl &url) override
    {
        return isMetaHost(url) ? false : QNetworkCookieJar::setCookiesFromUrl(cookies, url);
    }
};

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
        SailbookNetworkAccessManager *manager = new SailbookNetworkAccessManager(parent);
        manager->setCookieJar(new SailbookCookieJar(manager));
        return manager;
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
