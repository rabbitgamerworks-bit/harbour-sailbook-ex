TARGET = harbour-sailbook

CONFIG += sailfishapp sailfishapp_i18n

# APP_VERSION retrieved from .spec file
DEFINES += APP_VERSION=\\\"$${VERSION}\\\"

SOURCES += src/harbour-sailbook.cpp

DISTFILES += \
    qml/harbour-sailbook.qml \
    qml/cover/CoverPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/ResultPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AboutPage.qml \
    qml/components/Avatar.qml \
    qml/components/NavigationButton.qml \
    qml/js/backend.js \
    qml/js/themes.js \
    qml/images/*.svg \
    rpm/harbour-sailbook.spec \
    rpm/harbour-sailbook.changes \
    harbour-sailbook.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

TRANSLATIONS += \
    translations/harbour-sailbook-de.ts \
    translations/harbour-sailbook-fi.ts \
    translations/harbour-sailbook-it.ts \
    translations/harbour-sailbook-hu.ts \
    translations/harbour-sailbook-es.ts \
    translations/harbour-sailbook-nl.ts \
    translations/harbour-sailbook-zh_CN.ts \
    translations/harbour-sailbook-pt_BR.ts \
    translations/harbour-sailbook-nl_BE.ts \
    translations/harbour-sailbook-sv.ts \
    translations/harbour-sailbook-fr.ts
