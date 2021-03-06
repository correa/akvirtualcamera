# akvirtualcamera, virtual camera for Mac and Windows.
# Copyright (C) 2020  Gonzalo Exequiel Pedone
#
# akvirtualcamera is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# akvirtualcamera is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with akvirtualcamera. If not, see <http://www.gnu.org/licenses/>.
#
# Web-Site: http://webcamoid.github.io/

exists(commons.pri) {
    include(commons.pri)
} else {
    exists(../../commons.pri) {
        include(../../commons.pri)
    } else {
        error("commons.pri file not found.")
    }
}

include(../cmio.pri)
include(../../VCamUtils/VCamUtils.pri)

CONFIG -= qt link_prl
CONFIG += \
    unversioned_libname \
    unversioned_soname

DESTDIR = $${OUT_PWD}/$${BIN_DIR}

INCLUDEPATH += \
    .. \
    ../..

LIBS = \
    -L$${OUT_PWD}/../../VCamUtils/$${BIN_DIR} -lVCamUtils \
    -L$${OUT_PWD}/../VCamIPC/$${BIN_DIR} -lVCamIPC \
    -framework CoreFoundation \
    -framework CoreMedia \
    -framework CoreMediaIO \
    -framework CoreVideo \
    -framework Foundation \
    -framework IOKit \
    -framework IOSurface

TARGET = $${CMIO_PLUGIN_NAME}
TEMPLATE = lib

HEADERS += \
    src/plugin.h \
    src/plugininterface.h \
    src/utils.h \
    src/device.h \
    src/object.h \
    src/stream.h \
    src/objectinterface.h \
    src/objectproperties.h \
    src/clock.h \
    src/queue.h

SOURCES += \
    src/plugin.cpp \
    src/plugininterface.cpp \
    src/utils.cpp \
    src/device.cpp \
    src/object.cpp \
    src/stream.cpp \
    src/objectinterface.cpp \
    src/objectproperties.cpp \
    src/clock.cpp

QMAKE_SUBSTITUTES += Info.plist.in

OTHER_FILES = \
    Info.plist.in

CONTENTSPATH = $${CMIO_PLUGIN_NAME}.plugin/Contents
MACBINPATH = $${CONTENTSPATH}/MacOS
RESOURCESPATH = $${CONTENTSPATH}/Resources

INSTALLS += \
    targetLib \
    infoPlist \
    resources

targetLib.files = $$shell_path($${OUT_PWD}/../../$${MACBINPATH}/$${CMIO_PLUGIN_NAME})
targetLib.path = $${PREFIX}/$${MACBINPATH}
targetLib.CONFIG += no_check_exist

infoPlist.files = $$shell_path($${OUT_PWD}/Info.plist)
infoPlist.path = $${PREFIX}/$${CONTENTSPATH}
infoPlist.CONFIG += no_check_exist

resources.files = $$shell_path($${PWD}/../../share/TestFrame/TestFrame.bmp)
resources.path = $${PREFIX}/$${RESOURCESPATH}

QMAKE_POST_LINK = \
    $$sprintf($$QMAKE_MKDIR_CMD, $$shell_path($${OUT_PWD}/../../$${MACBINPATH})) $${CMD_SEP} \
    $$sprintf($$QMAKE_MKDIR_CMD, $$shell_path($${OUT_PWD}/../../$${RESOURCESPATH})) $${CMD_SEP} \
    $(COPY) $$shell_path($${OUT_PWD}/Info.plist) $$shell_path($${OUT_PWD}/../../$${CONTENTSPATH}) $${CMD_SEP} \
    $(COPY) $$shell_path($${OUT_PWD}/$${BIN_DIR}/lib$${CMIO_PLUGIN_NAME}.$${QMAKE_EXTENSION_SHLIB}) $$shell_path($${OUT_PWD}/../../$${MACBINPATH}/$${CMIO_PLUGIN_NAME}) $${CMD_SEP} \
    $(COPY) $$shell_path($${PWD}/../../share/TestFrame/TestFrame.bmp) $$shell_path($${OUT_PWD}/../../$${RESOURCESPATH})
