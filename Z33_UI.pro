#-------------------------------------------------
#
# Project created for Z33 Luxury Vehicle UI
# 
#-------------------------------------------------

QT += quick qml multimedia

# The CONFIG variable defines additional project configuration options.
CONFIG += c++11

# Input
SOURCES += main.cpp

RESOURCES += \
    qml.qrc \
    images/images.qrc

# Additional libraries can be added here
LIBS +=

# Default rules for deployment.
include(deployment.pri)

# Additional configurations for different platforms can be specified here