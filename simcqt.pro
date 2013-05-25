TEMPLATE = app

CONFIG(qt) {
  TARGET = SimulationCraft

  QT += core gui network webkit

  contains ( QT_MAJOR_VERSION , 5 ) {
    QT += widgets webkitwidgets
    DEFINES += QT_VERSION_5
  }
}
CONFIG(console) {
  TARGET = simc
  CONFIG+=staticlib
}

QMAKE_CXXFLAGS_RELEASE += -DNDEBUG
QMAKE_CXXFLAGS += $$OPTS

win32 {
  LIBS += -lwininet -lshell32
  RC_FILE += simcqt.rc
}

macx {
  QMAKE_INFO_PLIST = qt/Simulationcraft.plist
  ICON = qt/icon/Simcraft2.icns
  LIBS += -framework CoreFoundation -framework AppKit
}

# This will match both 'g++' and 'clang++'
COMPILER_CHECK_CXX = $$replace(QMAKE_CXX,'.*g\\+\\+'.*,'g++')

contains(COMPILER_CHECK_CXX,'g++') {
  QMAKE_CXXFLAGS_RELEASE -= -O2
  QMAKE_CXXFLAGS_RELEASE += -O3 -fomit-frame-pointer
  QMAKE_CXXFLAGS += -ffast-math -Woverloaded-virtual -msse2 -mfpmath=sse
}

win32-msvc2010 {
  QMAKE_CXXFLAGS_RELEASE -= -O2
  QMAKE_CXXFLAGS_RELEASE += -Ox -GL -GS-
  QMAKE_LFLAGS_RELEASE += /LTCG
  QMAKE_CXXFLAGS += -fp:fast -GF -arch:SSE2
}

INCLUDEPATH += engine
DEPENDPATH += engine

PRECOMPILED_HEADER = engine/simulationcraft.hpp

HEADERS += engine/simulationcraft.hpp
HEADERS += engine/sc_generic.hpp
HEADERS += engine/sc_timespan.hpp
HEADERS += engine/sc_sample_data.hpp
HEADERS += engine/sc_rng.hpp
HEADERS += engine/dbc/data_enums.hh
HEADERS += engine/dbc/data_definitions.hh
HEADERS += engine/dbc/specialization.hpp
HEADERS += engine/dbc/dbc.hpp
HEADERS += engine/utf8.h
HEADERS += engine/utf8/core.h
HEADERS += engine/utf8/checked.h
HEADERS += engine/utf8/unchecked.h

SOURCES += engine/sc_io.cpp
SOURCES += engine/sc_rng.cpp
SOURCES += engine/sc_thread.cpp
SOURCES += engine/sc_util.cpp
SOURCES += engine/action/sc_absorb.cpp
SOURCES += engine/action/sc_action_state.cpp
SOURCES += engine/action/sc_action.cpp
SOURCES += engine/action/sc_attack.cpp
SOURCES += engine/action/sc_dot.cpp
SOURCES += engine/action/sc_harmful_spell.cpp
SOURCES += engine/action/sc_heal.cpp
SOURCES += engine/action/sc_sequence.cpp
SOURCES += engine/action/sc_spell_base.cpp
SOURCES += engine/action/sc_stats.cpp
SOURCES += engine/buff/sc_buff.cpp
SOURCES += engine/player/sc_consumable.cpp
SOURCES += engine/player/sc_item.cpp
SOURCES += engine/player/sc_pet.cpp
SOURCES += engine/player/sc_player.cpp
SOURCES += engine/player/sc_set_bonus.cpp
SOURCES += engine/player/sc_unique_gear.cpp
SOURCES += engine/sim/sc_cooldown.cpp
SOURCES += engine/sim/sc_event.cpp
SOURCES += engine/sim/sc_expressions.cpp
SOURCES += engine/sim/sc_gear_stats.cpp
SOURCES += engine/sim/sc_option.cpp
SOURCES += engine/sim/sc_plot.cpp
SOURCES += engine/sim/sc_raid_event.cpp
SOURCES += engine/sim/sc_reforge_plot.cpp
SOURCES += engine/sim/sc_scaling.cpp
SOURCES += engine/sim/sc_sim.cpp
SOURCES += engine/report/sc_report_html_player.cpp
SOURCES += engine/report/sc_report_html_sim.cpp
SOURCES += engine/report/sc_report_text.cpp
SOURCES += engine/report/sc_report_xml.cpp
SOURCES += engine/report/sc_report.cpp
SOURCES += engine/report/sc_chart.cpp
SOURCES += engine/dbc/sc_const_data.cpp
SOURCES += engine/dbc/sc_item_data.cpp
SOURCES += engine/dbc/sc_spell_data.cpp
SOURCES += engine/dbc/sc_spell_info.cpp
SOURCES += engine/dbc/sc_data.cpp
SOURCES += engine/interfaces/sc_bcp_api.cpp
SOURCES += engine/interfaces/sc_chardev.cpp
SOURCES += engine/interfaces/sc_http.cpp
SOURCES += engine/interfaces/sc_js.cpp
SOURCES += engine/interfaces/sc_rawr.cpp
SOURCES += engine/interfaces/sc_wowhead.cpp
SOURCES += engine/interfaces/sc_xml.cpp
SOURCES += engine/class_modules/sc_death_knight.cpp
SOURCES += engine/class_modules/sc_druid.cpp
SOURCES += engine/class_modules/sc_enemy.cpp
SOURCES += engine/class_modules/sc_hunter.cpp
SOURCES += engine/class_modules/sc_mage.cpp
SOURCES += engine/class_modules/sc_monk.cpp
SOURCES += engine/class_modules/sc_paladin.cpp
SOURCES += engine/class_modules/sc_priest.cpp
SOURCES += engine/class_modules/sc_rogue.cpp
SOURCES += engine/class_modules/sc_shaman.cpp
SOURCES += engine/class_modules/sc_warlock.cpp
SOURCES += engine/class_modules/sc_warrior.cpp

CONFIG(console) {
  SOURCES += engine/sc_main.cpp
}

# GUI files
CONFIG(qt) {
  HEADERS += qt/sc_autoupdate.h
  HEADERS += qt/simulationcraftqt.hpp
  SOURCES += qt/main.cpp
  SOURCES += qt/sc_window.cpp
  SOURCES += qt/sc_import.cpp
  
  
  CONFIG(paperdoll) {
    DEFINES += SC_PAPERDOLL
    HEADERS += qt/simcpaperdoll.hpp
    SOURCES += qt/simcpaperdoll.cc
  }
}

CONFIG(openssl) {
  DEFINES += SC_USE_OPENSSL
  INCLUDEPATH += $$OPENSSL_INCLUDES
  LIBS += -L$$OPENSSL_LIBS -lssleay32
}

CONFIG(to_install) {
  DEFINES += SC_TO_INSTALL
}

# deployment for linux
unix:!mac {
  DISTFILES += CHANGES \
               COPYING

  # Disable strip
  QMAKE_STRIP=echo

  isEmpty(PREFIX):PREFIX = ~
  isEmpty(INSTALLPATH):INSTALLPATH = $$PREFIX/SimulationCraft
  SHAREDIR = ~/.local/share
  INSTALLS += target \
              profiles \
              data \
              icon \
              locale

  target.path = $$INSTALLPATH

  profiles.path = $$INSTALLPATH/profiles
  profiles.files += profiles/*
  profiles.commands = @echo Installing profiles to $$INSTALLPATH/profiles

  data.path = $$INSTALLPATH
  data.files += Welcome.html
  data.files += Welcome.png
  data.files += Legend.html
  data.files += READ_ME_FIRST.txt
  data.commands = @echo Installing global files to $$INSTALLPATH

  icon.path = $$INSTALLPATH
  icon.files = debian/simulationcraft.xpm
  icon.commands = @echo Installing icon to $$INSTALLPATH

  locale.path = $$INSTALLPATH/locale
  locale.files += locale/*
  locale.commands = @echo Installing localizations to $$INSTALLPATH/locale
}
