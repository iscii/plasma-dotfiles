import QtQuick 2.4
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: 'settings-configure'
        source: 'config/ConfigGeneral.qml'
    }
}
