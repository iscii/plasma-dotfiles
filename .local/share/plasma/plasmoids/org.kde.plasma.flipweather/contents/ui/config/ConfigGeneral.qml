import QtQuick 2.4
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0 as QQC2
import org.kde.kirigami 2.7 as Kirigami
import QtQuick.Dialogs 1.2
import ".."

ColumnLayout {
    Layout.fillWidth: true
    property string cfg_apikey: plasmoid.configuration.apikey
    property string cfg_city: plasmoid.configuration.city
    property double cfg_lat: plasmoid.configuration.lat
    property double cfg_lon: plasmoid.configuration.lon
    property int cfg_units: plasmoid.configuration.units
    property int cfg_pressure: plasmoid.configuration.pressure
    property int cfg_forecastdays: plasmoid.configuration.forecastdays
    property alias cfg_showtoday: showtoday.checked
    property int cfg_updateinterval: plasmoid.configuration.updateinterval
    property alias cfg_is24: is24.checked
    property bool isSearch: false
    CityModel {
        id: cityModel
    }
    Component.onCompleted: {
        cityModel.clear()
    }

    Kirigami.FormLayout {
        Layout.alignment: Qt.AlignTop
        QQC2.TextField {
            Kirigami.FormData.label: i18n("Your API key:")
            text: cfg_apikey
            onTextChanged: {
                cfg_apikey = text
            }
        }
        QQC2.Label {
            text: i18n("<a href='#'>Get it here!</a>")
            MouseArea {
                anchors.fill: parent
                cursorShape: "PointingHandCursor"
                onClicked: {
                    Qt.openUrlExternally(
                                "https://home.openweathermap.org/users/sign_in")
                }
            }
        }
        Kirigami.ActionTextField {
            Kirigami.FormData.label: i18n("Location:")
            text: cfg_city != "N/A" ? cfg_city : i18n("Choose location")
            readOnly: true
            rightActions: [
                Kirigami.Action {
                    icon.name: "edit-entry"
                    onTriggered: {
                        citydialog.open()
                    }
                }
            ]
        }
        QQC2.ComboBox {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Units:")
            id: units
            model: [i18n("metric"), i18n("imperial")]
            currentIndex: cfg_units
            onActivated: {
                cfg_units = currentIndex
            }
        }
        QQC2.ComboBox {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Pressure:")
            id: pressure
            model: [i18n("hPa"), i18n("mmHg")]
            currentIndex: cfg_pressure
            onActivated: {
                cfg_pressure = currentIndex
            }
        }
        QQC2.ComboBox {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Number of forecast days:")
            id: forecastdays
            currentIndex: model.indexOf(cfg_forecastdays)
            model: [3, 4, 5, 6, 7]
            onActivated: {
                cfg_forecastdays = currentText
            }
        }
        QQC2.CheckBox {
            id: showtoday
            text: i18n("Show forecast for today")
        }
        QQC2.SpinBox {
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Update interval:")
            id: updateinterval
            implicitWidth: forecastdays.width
            implicitHeight: forecastdays.height
            textFromValue: function () {
                return value + " " + i18n("minutes")
            }
            from: 5
            to: 60
            stepSize: 5
            value: cfg_updateinterval
            onValueChanged: {
                cfg_updateinterval = value
            }
        }
        QQC2.CheckBox {
            text: i18n("Use 24-hours")
            id: is24
        }
    }
    Dialog {
        id: citydialog
        width: 513
        property double lat1
        property double lon1
        property string place1
        property double lat2
        property double lon2
        property string place2
        height: 350 //parent.height + units.largeSpacing
        standardButtons:
            /*tabview.currentIndex == 1 && place2 == ""
                         || place1 == "" ? StandardButton.Cancel : */ StandardButton.Cancel
                                                                      | StandardButton.Ok
        onAccepted: {
            if (tabview.currentIndex == 0) {
                cfg_city = place1
                cfg_lat = lat1
                cfg_lon = lon1
            } else {
                cfg_city = place2
                cfg_lat = lat2
                cfg_lon = lon2
            }
        }
        TabView {
            id: tabview
            width: parent.width
            height: parent.height
            frameVisible: false
            Tab {
                width: parent.width
                height: parent.height - units.smallSpacing
                title: i18n("Search place")
                ColumnLayout {
                    Layout.topMargin: units.smallSpacing
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    RowLayout {
                        Layout.topMargin: units.largeSpacing
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Kirigami.ActionTextField {
                            id: input
                            Layout.topMargin: units.largeSpacing
                            Layout.fillWidth: true
                            placeholderText: i18n("Enter the name of the place and wait a few seconds")
                            focusSequence: "Ctrl+F"
                            onTextChanged: {
                                if (input.text !== "") {
                                    if (input.text.length > 1) {
                                        treshholdTimer.restart()
                                    }
                                } else {
                                    cityModel.clear()
                                }
                            }
                            rightActions: [
                                Kirigami.Action {
                                    icon.name: isSearch ? "edit-download" : "edit-clear"
                                    visible: input.text !== ""
                                    onTriggered: {
                                        input.text = ""
                                        cityModel.clear()
                                    }
                                }
                            ]
                        }
                        Timer {
                            id: treshholdTimer
                            running: false
                            repeat: false
                            interval: 1000
                            onTriggered: {
                                searchCity()
                            }
                        }
                    }
                    TableView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        height: parent.height
                        width: parent.width
                        id: citytable
                        model: cityModel
                        enabled: !isSearch
                        onClicked: {
                            citydialog.place1 = model.get(
                                        citytable.currentRow).name
                            citydialog.lat1 = model.get(
                                        citytable.currentRow).lat
                            citydialog.lon1 = model.get(
                                        citytable.currentRow).lon
                        }

                        TableViewColumn {
                            id: name
                            title: i18n("Place")
                            role: "name"
                            width: parent.width / 5.1
                        }
                        TableViewColumn {
                            role: "country"
                            title: i18n("Country")
                            width: parent.width / 5.1
                        }
                        TableViewColumn {
                            title: i18n("Latitude")
                            role: "lat"
                            width: parent.width / 5.1
                        }
                        TableViewColumn {
                            title: i18n("Longitude")
                            role: "lon"
                            width: parent.width / 5.1
                        }
                        TableViewColumn {
                            title: i18n("State")
                            role: "state"
                            width: parent.width / 5.1
                        }
                    }
                    function searchCity() {
                        isSearch = true
                        var url = "http://api.openweathermap.org/geo/1.0/direct?q="
                                + input.text + "&limit=99&appid=" + cfg_apikey + ""
                        var xmlhttp = new XMLHttpRequest
                        xmlhttp.open("GET", url)
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState === xmlhttp.DONE) {
                                if (xmlhttp.status === 200) {
                                    var myArr = JSON.parse(xmlhttp.responseText)
                                    var servers = myArr
                                    cityModel.clear()
                                    if (servers.length > 0) {
                                        for (var i = 0; i < servers.length; i++) {
                                            var locale = Qt.locale(
                                                        ).name.split("_")[0]
                                            if (locale in servers[i].local_names) {
                                                servers[i].name = servers[i].local_names[locale]
                                            }
                                            cityModel.append(servers[i])
                                        }
                                    }
                                }
                            }
                            isSearch = false
                        }
                        xmlhttp.send()
                    }
                }
            }
            Tab {
                width: parent.width
                height: parent.height
                title: i18n("Enter coordinates")
                Kirigami.FormLayout {
                    Layout.alignment: Qt.AlignTop
                    QQC2.TextField {
                        id: latitude
                        Kirigami.FormData.label: i18n("Latitude")
                        validator: RegExpValidator {
                            regExp: /^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)/
                        }
                        onTextChanged: citydialog.lat2 = parseInt(text)
                    }
                    QQC2.TextField {
                        id: longitude
                        Kirigami.FormData.label: i18n("Longitude")
                        validator: RegExpValidator {
                            regExp: /\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/
                        }
                        onTextChanged: citydialog.lon2 = parseInt(text)
                    }
                    QQC2.TextField {
                        id: placename
                        Kirigami.FormData.label: i18n("Place")
                        onTextChanged: citydialog.place2 = text
                    }
                }
            }
        }
    }

    QQC2.Label {
        text: i18n("Use double click to toggle animation!")
        Layout.alignment: Qt.AlignBottom
    }
}
