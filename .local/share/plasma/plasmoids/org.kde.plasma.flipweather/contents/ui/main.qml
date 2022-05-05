import QtQuick 2.4
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import QtGraphicalEffects 1.0
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

Item {
    id: root

    width: 415 * units.devicePixelRatio
    height: 320 * units.devicePixelRatio
    onWidthChanged: {
        parent.parent.width = parent.parent ? 415 * units.devicePixelRatio : 0
    }
    onHeightChanged: {
        parent.parent.height = parent.parent ? 320 * units.devicePixelRatio : 0
    }
    property string startcolor: "transparent"
    property string endcolor: "white"
    property bool showSeconds: false
    property int timeFontSize: 117 * units.devicePixelRatio
    property int infoFontSize: 14 * units.devicePixelRatio
    Plasmoid.backgroundHints: "NoBackground"
    property string cfg_apikey: plasmoid.configuration.apikey
    property string cfg_city: plasmoid.configuration.city
    property double cfg_lat: plasmoid.configuration.lat
    property double cfg_lon: plasmoid.configuration.lon
    property int cfg_units: plasmoid.configuration.units
    property int cfg_pressure: plasmoid.configuration.pressure
    property int cfg_forecastdays: plasmoid.configuration.forecastdays
    property bool cfg_showtoday: plasmoid.configuration.showtoday
    property bool cfg_is24: plasmoid.configuration.is24
    property string locale: Qt.locale().name.split("_")[0]
    property int currentId: 0
    property string currentDescription: ""
    property string currentTemp: ""
    property string currentWindSpeed: ""
    property string currentWindDirection: ""
    property string currentPressure: ""
    property string currentHumidity: ""
    property string currentIcon: "na"
    property int forecastindex: -1
    Component.onCompleted: {
        if (cfg_city != "N/A")
            getCurrentWeather()
    }
    onCurrentIdChanged: {
        dropLoader.source = ""
        paintAnimation()
    }

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 500
    }
    FontLoader {
        id: comfortaa
        source: "../fonts/Comfortaa.ttf"
    }

    Connections {
        target: plasmoid.configuration

        function onApikeyChanged(cfg_apikey) {
            delayTimer.restart()
        }
        function onLatChanged(cfg_lat) {
            delayTimer.restart()
        }

        function onLonChanged(cfg_lon) {
            delayTimer.restart()
        }

        function onCityChanged(cfg_city) {
            delayTimer.restart()
        }
        function onUnitsChanged(cfg_units) {
            delayTimer.restart()
        }
        function onForecastdaysChanged(cfg_forecastdays) {
            delayTimer.restart()
        }
        function onShowtodayChanged(cfg_showtoday) {
            delayTimer.restart()
        }
        //        function onIs24Changed(cfg_is24) {
        //            delayTimer.restart()
        //        }
    }

    ForecastModel {
        id: forecastModel
    }

    Rectangle {
        id: main
        height: 200 * units.devicePixelRatio
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        radius: units.largeSpacing
        color: "black"
        opacity: 0.5
        transform: Translate {
            y: hours.height / 4
        }

        Rectangle {
            id: topop
            anchors.top: parent.top
            width: parent.width
            height: 60 * units.devicePixelRatio
            radius: units.largeSpacing
            color: "white"
            visible: false
        }
        LinearGradient {
            id: filltop
            anchors.fill: topop
            visible: false
            source: topop
            start: Qt.point(0, 0)
            end: Qt.point(0, topop.height)
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: startcolor
                }
                GradientStop {
                    position: 0.8
                    color: endcolor
                }
            }
        }
        OpacityMask {
            z: 1
            anchors.fill: topop
            source: filltop
            maskSource: topop
        }
    }
    PlasmaComponents.Button {
        text: i18n("Configure weather")
        anchors.centerIn: parent
        transform: Translate {
            y: hours.height / 5
        }
        visible: cfg_city == "N/A"
        z: 999
        onClicked: plasmoid.action("configure").trigger()
    }

    RowLayout {
        id: info
        visible: cfg_city != "N/A"
        Layout.fillWidth: true
        width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: units.smallSpacing * 2
        Layout.alignment: Qt.AlignHCenter
        height: 60 * units.devicePixelRatio
        z: 3
        anchors.bottom: main.bottom
        transform: Translate {
            y: hours.height / 5
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignLeft
            PlasmaComponents.Label {
                text: cfg_city
                font.family: comfortaa.name
                font.weight: "Bold"
                id: city
                z: 99
                color: "white"
                font.pixelSize: infoFontSize
            }
            PlasmaComponents.Label {
                id: temperature
                text: i18n("Temperature: ") + currentTemp
                z: 99
                font.family: comfortaa.name
                color: "white"
                font.weight: "Bold"
                font.pixelSize: infoFontSize
            }
            PlasmaComponents.Label {
                text: currentDescription
                z: 99
                font.family: comfortaa.name
                color: "white"
                font.weight: "Bold"
                font.pixelSize: infoFontSize
            }
        }

        ColumnLayout {
            id: rightColumn
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: units.smallSpacing
            anchors.right: parent.right
            onWidthChanged: {
                Layout.alignment = Qt.AlignRight
                Layout.rightMargin = units.smallSpacing
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignRight
                text: i18n("Humidity: ") + currentHumidity
                id: temp
                font.family: comfortaa.name
                z: 99
                color: "white"
                font.weight: "Bold"
                font.pixelSize: infoFontSize
            }
            RowLayout {
                spacing: units.smallSpacing
                Layout.alignment: Qt.AlignRight
                PlasmaComponents.Label {
                    width: parent.width
                    color: "white"
                    font.weight: "Bold"
                    text: i18n("Wind: ") + currentWindSpeed + " "
                    font.family: comfortaa.name
                    font.pixelSize: infoFontSize
                }
                Item {
                    id: imgcon
                    width: 14 * units.devicePixelRatio
                    height: 14 * units.devicePixelRatio
                    Image {
                        anchors.fill: parent
                        source: Qt.resolvedUrl("../images/wd.svg")
                        fillMode: Image.PreserveAspectFit
                        clip: true
                        smooth: true
                        transform: Rotation {
                            angle: currentWindDirection
                            origin.x: imgcon.width / 2
                            origin.y: imgcon.height / 2
                        }
                    }
                }
            }
            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignRight
                width: parent.width
                font.family: comfortaa.name
                color: "white"
                font.weight: "Bold"
                text: i18n("Pressure: ") + formatPressure(currentPressure)
                horizontalAlignment: Text.AlignRight
                font.pixelSize: infoFontSize
            }
        }
    }
    RowLayout {
        id: mainrow
        anchors.centerIn: parent
        height: hours.height
        spacing: units.largeSpacing * 2.5
        transform: Translate {
            y: Math.round(-root.height / 2 + hours.height / 2)
        }

        Flip {
            id: hours
            property bool is24: cfg_is24
            property bool ishours: true
            property int hhh: parseInt(Qt.formatTime(
                                           dataSource.data.Local.DateTime,
                                           "hh"))
            property int time: is24 ? Qt.formatTime(
                                          dataSource.data.Local.DateTime,
                                          "hh") : hhh - 12 < 1 ? hhh : hhh - 12
            property int mintime: cfg_is24 ? 0 : 1
            property int maxtime: cfg_is24 ? 23 : 12
        }

        Flip {
            property bool ishours: false
            property int time: Qt.formatTime(dataSource.data.Local.DateTime,
                                             "mm")
            property int mintime: 0
            property int maxtime: 59
        }
    }
    RowLayout {
        id: bottom
        width: parent.width
        Layout.alignment: Qt.AlignBottom
        Layout.fillHeight: false
        anchors.bottom: root.bottom
        Rectangle {
            width: bottom.width
            height: 60 * units.devicePixelRatio
            radius: units.largeSpacing
            color: "black"
            opacity: 0.5
            Rectangle {
                id: botgr
                height: 25
                width: parent.width
                anchors.top: parent.top
                radius: units.largeSpacing
                color: "white"
            }
            LinearGradient {
                id: filltop5
                anchors.fill: botgr
                visible: false
                source: topop
                start: Qt.point(0, 0)
                end: Qt.point(0, botgr.height)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: startcolor
                    }
                    GradientStop {
                        position: 0.8
                        color: endcolor
                    }
                }
            }
            OpacityMask {
                z: 1
                anchors.fill: botgr
                source: filltop5
                maskSource: botgr
            }
        }
    }
    Rectangle {
        id: forecast
        anchors.bottom: root.bottom
        anchors.right: root.right
        width: root.width
        height: 70 * units.devicePixelRatio
        color: "transparent"
        transform: Translate {
            y: -bottom.height / 4
        }
        z: 99
        GridLayout {
            width: parent.width
            height: parent.height
            id: dailyForecastView
            rows: 1
            columnSpacing: 0
            rowSpacing: units.smallSpacing
            Repeater {
                id: dayRepeater
                model: forecastModel

                Item {
                    id: dayItem
                    visible: cfg_city != "N/A"
                    implicitWidth: dayItemLayout.implicitWidth
                    implicitHeight: cfg_forecastdays > 5 ? 80 * units.devicePixelRatio : 83
                                                           * units.devicePixelRatio
                    Layout.fillWidth: true
                    ColumnLayout {
                        id: dayItemLayout
                        anchors.fill: parent
                        spacing: 0
                        Image {
                            id: dayItemIcon
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignCenter
                            source: "../images/" + model.icon + ".png"
                            fillMode: Image.PreserveAspectFit
                        }
                        PlasmaComponents.Label {
                            property var locale: Qt.locale()
                            property date date: new Date(model.timestamp * 1000)
                            text: model.index == 0
                                  && cfg_showtoday ? i18n("today") : date.toLocaleDateString(
                                                         locale, "ddd") || ""
                            font.family: comfortaa.name
                            font.pixelSize: cfg_forecastdays > 5 ? 11 * units.devicePixelRatio : 13
                                                                   * units.devicePixelRatio
                            Layout.alignment: Qt.AlignHCenter
                            color: "white"
                            font.weight: "Bold"
                        }

                        PlasmaComponents.Label {
                            text: Math.round(model.temp_max) + "/" + formatTemp(
                                      model.temp_min)
                            font.family: comfortaa.name
                            font.pixelSize: cfg_forecastdays > 5 ? 11 * units.devicePixelRatio : 13
                                                                   * units.devicePixelRatio
                            Layout.alignment: Qt.AlignHCenter
                            color: "white"
                            font.weight: "Bold"
                        }
                    }
                    MouseArea {
                        id: tooltiparea
                        property int index: model.index
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            forecastindex = model.index
                            tooltip.visible = true
                        }
                        onExited: {
                            tooltip.visible = false
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        id: tooltip
        visible: false
        anchors.top: parent.bottom
        color: "#80000000"
        width: parent.width
        height: 170 * units.devicePixelRatio
        anchors.topMargin: units.largeSpacing
        radius: units.largeSpacing
        ColumnLayout {
            anchors.fill: parent
            Rectangle {
                id: titl
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                Layout.topMargin: units.smallSpacing * 2
                width: parent.width
                height: 20 * units.devicePixelRatio
                color: "transparent"
                PlasmaComponents.Label {
                    width: parent.width
                    color: "white"
                    font.family: comfortaa.name
                    font.weight: "Bold"
                    font.pixelSize: infoFontSize
                    horizontalAlignment: Text.AlignHCenter
                    property var locale: Qt.locale()
                    property date date: new Date(forecastModel.get(
                                                     forecastindex).timestamp * 1000)
                    text: i18n("Weather forecast for ") + date.toLocaleDateString(
                              locale, Locale.ShortFormat)
                }
            }
            RowLayout {
                id: info2
                Layout.fillWidth: true
                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.smallSpacing * 2
                Layout.alignment: Qt.AlignHCenter
                z: 3
                anchors.top: titl.bottom

                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft

                    PlasmaComponents.Label {
                        text: i18n("Morning: ") + formatTemp(
                                  forecastModel.get(forecastindex).temp_morn)
                        font.family: comfortaa.name
                        font.weight: "Bold"
                        id: forecastmorningtemp
                        z: 99
                        color: "white"
                        font.pixelSize: infoFontSize
                    }
                    PlasmaComponents.Label {
                        text: i18n("Day: ") + formatTemp(
                                  forecastModel.get(forecastindex).temp_day)
                        font.family: comfortaa.name
                        font.weight: "Bold"
                        id: forecastdaytemp
                        z: 99
                        color: "white"
                        font.pixelSize: infoFontSize
                    }
                    PlasmaComponents.Label {
                        text: i18n("Evening: ") + formatTemp(
                                  forecastModel.get(forecastindex).temp_eve)
                        font.family: comfortaa.name
                        font.weight: "Bold"
                        id: forecastevetemp
                        z: 99
                        color: "white"
                        font.pixelSize: infoFontSize
                    }
                    PlasmaComponents.Label {
                        text: i18n("Night: ") + formatTemp(
                                  forecastModel.get(forecastindex).temp_night)
                        font.family: comfortaa.name
                        font.weight: "Bold"
                        id: forecastnighttemp
                        z: 99
                        color: "white"
                        font.pixelSize: infoFontSize
                    }

                    PlasmaComponents.Label {
                        property var locale: Qt.locale()
                        property date date: new Date(forecastModel.get(
                                                         forecastindex).sunrise * 1000)
                        text: cfg_is24 ? i18n("Sunrise: ") + date.toLocaleTimeString(
                                             locale, "hh:mm") : i18n(
                                             "Sunrise: ") + date.toLocaleTimeString(
                                             locale, "hh:mm ap")
                        font.family: comfortaa.name
                        font.weight: "Bold"
                        id: sunrise
                        z: 99
                        color: "white"
                        font.pixelSize: infoFontSize
                    }
                    PlasmaComponents.Label {
                        property var locale: Qt.locale()
                        property date date: new Date(forecastModel.get(
                                                         forecastindex).sunset * 1000)
                        text: cfg_is24 ? i18n("Sunset: ") + date.toLocaleTimeString(
                                             locale, "hh:mm") : i18n(
                                             "Sunset: ") + date.toLocaleTimeString(
                                             locale, "hh:mm ap")
                        font.family: comfortaa.name
                        font.weight: "Bold"
                        id: sunset
                        z: 99
                        color: "white"
                        font.pixelSize: infoFontSize
                    }
                }

                ColumnLayout {
                    id: rightColumn2
                    Layout.alignment: Qt.AlignRight
                    anchors.right: parent.right
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        text: forecastModel.get(forecastindex).description
                        font.family: comfortaa.name
                        font.weight: "Bold"
                        id: forecastdescription
                        horizontalAlignment: Text.AlignRight
                        z: 99
                        color: "white"
                        font.pixelSize: infoFontSize
                    }
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        text: i18n("Humidity: ") + forecastModel.get(
                                  forecastindex).humidity + "%"
                        id: temp2
                        font.family: comfortaa.name
                        z: 99
                        color: "white"
                        font.weight: "Bold"
                        font.pixelSize: infoFontSize
                    }
                    RowLayout {
                        spacing: units.smallSpacing
                        Layout.alignment: Qt.AlignRight
                        PlasmaComponents.Label {
                            width: parent.width
                            color: "white"
                            z: 99
                            font.weight: "Bold"
                            text: i18n("Wind: ") + formatSpeed(
                                      forecastModel.get(
                                          forecastindex).wind_speed) + " "
                            font.family: comfortaa.name
                            font.pixelSize: infoFontSize
                        }
                        Item {
                            z: 99
                            id: imgcon2
                            width: infoFontSize
                            height: infoFontSize
                            Image {
                                anchors.fill: parent
                                source: Qt.resolvedUrl("../images/wd.svg")
                                fillMode: Image.PreserveAspectFit
                                clip: true
                                smooth: true
                                transform: Rotation {
                                    angle: forecastModel.get(
                                               forecastindex).wind_deg
                                    origin.x: imgcon2.width / 2
                                    origin.y: imgcon2.height / 2
                                }
                            }
                        }
                    }

                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        width: parent.width
                        font.family: comfortaa.name
                        color: "white"
                        z: 99
                        font.weight: "Bold"
                        text: i18n("Clouds: ") + forecastModel.get(
                                  forecastindex).clouds + "%"
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: infoFontSize
                    }
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        width: parent.width
                        font.family: comfortaa.name
                        color: "white"
                        z: 99
                        font.weight: "Bold"
                        text: i18n("Pressure: ") + formatPressure(
                                  forecastModel.get(forecastindex).pressure)
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: infoFontSize
                    }
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        width: parent.width
                        font.family: comfortaa.name
                        color: "white"
                        z: 99
                        font.weight: "Bold"
                        text: i18n("Precipitation: ") + Math.round(
                                  forecastModel.get(
                                      forecastindex).pop * 100) + "%"
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: infoFontSize
                    }
                }
                Rectangle {
                    id: clip
                    anchors.centerIn: parent
                    width: 100 * units.devicePixelRatio
                    height: 100 * units.devicePixelRatio
                    radius: 50 * units.devicePixelRatio
                    z: 0
                    opacity: 0.8
                    color: "transparent"
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: 100 * units.devicePixelRatio
                            height: 100 * units.devicePixelRatio
                            radius: 50 * units.devicePixelRatio
                        }
                    }
                    Image {
                        source: "../images/full.png"
                        width: 100 * units.devicePixelRatio
                        height: 100 * units.devicePixelRatio
                        z: 0
                        fillMode: Image.PreserveAspectFit
                        opacity: 0.8
                    }
                    Rectangle {
                        width: 100 * units.devicePixelRatio
                        height: 100 * units.devicePixelRatio
                        radius: 50 * units.devicePixelRatio
                        opacity: 0.8
                        z: 0
                        color: "black"
                        transform: Translate {
                            x: calculatePhase(100 * units.devicePixelRatio)
                        }
                    }
                }
            }
        }
    }

    Item {
        visible: cfg_city != "N/A"
        anchors.centerIn: parent
        transform: Translate {
            y: Math.round(-root.height / 2 + hours.height * 1.25)
        }
        height: 165 * units.devicePixelRatio
        width: 256 * units.devicePixelRatio
        Image {
            source: "../images/" + currentIcon + ".png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            opacity: 0.8
        }
    }
    Loader {
        id: dropLoader
        active: plasmoid.configuration.animate
        anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    MouseArea {
        anchors.fill: root
        hoverEnabled: true
        onDoubleClicked: {
            if (plasmoid.configuration.animate == true) {
                plasmoid.configuration.animate = false
            } else {
                plasmoid.configuration.animate = true
            }

            console.log(plasmoid.configuration.animate)
        }
    }
    function getCurrentWeather() {
        if (cfg_city != "N/A" && cfg_apikey != "") {
            var units = cfg_units == 0 ? "metric" : "imperial"
            var url = "https://api.openweathermap.org/data/2.5/onecall?lat=" + cfg_lat
                    + "&lon=" + cfg_lon + "&units=" + units + "&lang=" + locale
                    + "&exclude=hourly,minutely,alerts&appid=" + cfg_apikey + ""
            console.log(url)
            var xmlhttp = new XMLHttpRequest
            xmlhttp.open("GET", url)
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState === xmlhttp.DONE) {
                    if (xmlhttp.status === 200) {
                        var response = JSON.parse(xmlhttp.responseText)
                        currentId = response.current.weather[0].id
                        currentDescription = response.current.weather[0].description
                        currentTemp = formatTemp(response.current.temp)
                        currentWindSpeed = formatSpeed(
                                    response.current.wind_speed)
                        currentWindDirection = response.current.wind_deg
                        currentPressure = response.current.pressure
                        currentHumidity = response.current.humidity + "%"
                        currentIcon = response.current.weather[0].icon
                        var forecast = response.daily
                        forecastModel.clear()
                        var limit = cfg_showtoday ? cfg_forecastdays : cfg_forecastdays + 1
                        for (var i = 0; i < limit; i++) {
                            forecastModel.append({
                                                     "timestamp": forecast[i].dt,
                                                     "ids": forecast[i].weather[0]["id"],
                                                     "description": forecast[i].weather[0].description,
                                                     "icon": forecast[i].weather[0].icon,
                                                     "temp_min": forecast[i].temp.min,
                                                     "temp_max": forecast[i].temp.max,
                                                     "temp_day": forecast[i].temp.day,
                                                     "temp_night": forecast[i].temp.night,
                                                     "temp_eve": forecast[i].temp.eve,
                                                     "temp_morn": forecast[i].temp.morn,
                                                     "feel_day": forecast[i].feels_like.day,
                                                     "feel_night": forecast[i].feels_like.night,
                                                     "feel_eve": forecast[i].feels_like.eve,
                                                     "feel_morn": forecast[i].feels_like.morn,
                                                     "sunrise": forecast[i].sunrise,
                                                     "sunset": forecast[i].sunset,
                                                     "moonrise": forecast[i].moonrise,
                                                     "moonset": forecast[i].moonset,
                                                     "moonphase": forecast[i].moon_phase,
                                                     "pressure": forecast[i].pressure,
                                                     "humidity": forecast[i].humidity,
                                                     "wind_speed": forecast[i].wind_speed,
                                                     "wind_deg": forecast[i].wind_deg,
                                                     "clouds": forecast[i].clouds,
                                                     "pop": forecast[i].pop
                                                 })
                        }
                        if (!cfg_showtoday) {
                            forecastModel.remove(0)
                        }
                        if (plasmoid.configuration.animate == true)
                            paintAnimation()
                    }
                }
            }
            xmlhttp.send()
        }
    }
    function formatTemp(temp) {
        if (cfg_units == 0) {
            return Math.round(temp) + "°C"
        } else {
            return Math.round(temp) + "°F"
        }
    }
    function formatSpeed(speed) {
        if (cfg_units == 0) {
            return speed + i18n("m/s")
        } else {
            return speed + i18n("m/h")
        }
    }
    function formatPressure(pressure) {
        if (cfg_pressure == 1) {
            return Math.round(pressure * 0.75006168282261) + i18n("mmHg")
        } else {
            return pressure + i18n("hPa")
        }
    }

    function paintAnimation() {
        dropLoader.source = "../animations/Weather.qml"
    }

    function calculatePhase(width) {
        var phase = forecastModel.get(forecastindex).moonphase
        if (phase < 0.5) {
            return phase * width * 2
        } else {
            return ((phase * width) - width) * 2
        }
    }

    PlasmaNM.NetworkStatus {
        id: networkStatus
        onNetworkStatusChanged: {
            if (networkStatus.networkStatus == i18nd(
                        "plasma_applet_org.kde.plasma.networkmanagement",
                        "Connected")) {
                getCurrentWeather()
            } else {
                console.log("Connection lost")
            }
        }
    }

    Timer {
        id: updateTimer
        running: true
        repeat: true
        interval: plasmoid.configuration.updateinterval * 60000
        onTriggered: {
            getCurrentWeather()
        }
    }
    Timer {
        id: delayTimer
        running: false
        repeat: false
        interval: 0
        onTriggered: {
            getCurrentWeather()
        }
    }
}
