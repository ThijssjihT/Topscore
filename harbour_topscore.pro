# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour_topscore

CONFIG += sailfishapp

SOURCES += src/harbour_topscore.cpp

DISTFILES += qml/harbour_topscore.qml \
    qml/assets/1.svg \
    qml/assets/2.svg \
    qml/assets/3.svg \
    qml/assets/4.svg \
    qml/assets/5.svg \
    qml/assets/6.svg \
    qml/cover/CoverPage.qml \
    qml/pages/Scores.qml \
    qml/pages/Settings.qml \
    qml/pages/Topscore.qml \
    rpm/harbour_topscore.changes.in \
    rpm/harbour_topscore.changes.run.in \
    rpm/harbour_topscore.spec \
    translations/*.ts \
    harbour_topscore.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
# TRANSLATIONS += translations/harbour_topscore-de.ts
