import QtQuick 2.4
import QtQml 2.0
import QtQuick.Particles 2.15
import "../ui"

Item {
    anchors.fill: parent
    property int ids: parent.parent.currentId
    property bool drops: false
    property int dropSpeed: 0
    property int dropQuantity: 0
    property string sourcePathToDrop: ""
    property int dropNumbers: 0
    property bool clouds: false
    property int cloudsPower: 0
    property bool clear: false
    property bool thunder: false
    property int thunderPower: 0
    property bool fog: false
    property string time: parent.parent.currentIcon
    WeatherModel {
        id: weatherModel
    }

    Component.onCompleted: {
        for (var i = 0; i < weatherModel.count; ++i) {
            if (weatherModel.get(i).ids === ids) {
                if (weatherModel.get(i).drops === true) {
                    drops = true
                    dropSpeed = weatherModel.get(i).dropSpeed
                    dropQuantity = weatherModel.get(i).dropQuantity
                    sourcePathToDrop = weatherModel.get(i).sourcePathToDrop
                    dropNumbers = weatherModel.get(i).dropNumbers
                }
                if (weatherModel.get(i).clouds === true) {
                    clouds = true
                    cloudsPower = weatherModel.get(i).cloudsPower
                }
                if (weatherModel.get(i).clear === true) {
                    clear = true
                }
                if (weatherModel.get(i).thunder === true) {
                    thunder = true
                    thunderPower = weatherModel.get(i).thunderPower
                }
                if (weatherModel.get(i).fog === true) {
                    fog = true
                }
            }
        }
    }

    Rectangle {
        id: dropContainer
        width: parent.width
        color: "transparent"
        anchors.fill: parent
        radius: units.largeSpacing
        clip: true
        ParticleSystem {
            id: dropSys
            running: drops
        }

        Wander {
            id: dropWanderer
            system: dropSys
            anchors.fill: parent
            xVariance: 360 / (dropWanderer.affectedParameter + 1)
            pace: 20 * (dropWanderer.affectedParameter + 1)
        }

        Emitter {
            group: "A"
            id: dropParticles
            width: parent.width
            system: dropSys
            emitRate: dropQuantity // Quantity
            lifeSpan: dropContainer.height * 2 / dropSpeed * 1000
            velocity: PointDirection {
                y: dropSpeed //Speed
                yVariation: 40 //Speed variation
            }
            acceleration: PointDirection {
                y: 1
            }
            size: 32
            sizeVariation: -1
            height: 1
        }
        ItemParticle {
            groups: ["A"]
            id: rain
            system: dropSys
            delegate: rainDelegate
            fade: false
        }

        Component {
            id: rainDelegate
            Rectangle {
                id: container
                width: 32
                height: 32
                color: 'transparent'
                Image {
                    anchors.fill: parent
                    fillMode: Image.Pad
                    source: sourcePathToDrop + '/drop-' + Math.ceil(
                                Math.random() * dropNumbers) + '.png'
                }
            }
        }
    }
    Rectangle {
        id: cloudContainer
        width: parent.width
        height: parent.height
        radius: units.largeSpacing
        color: "transparent"
        anchors.centerIn: parent
        clip: true
        ParticleSystem {
            id: cloudSys
            running: clouds || fog
        }

        Wander {
            id: cloudWanderer
            system: cloudSys
            anchors.fill: parent
            xVariance: 360 / (cloudWanderer.affectedParameter + 1)
            pace: 1 * (cloudWanderer.affectedParameter + 1)
        }

        Emitter {
            id: cloudParticles
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            system: cloudSys
            emitRate: fog ? 1 : cloudsPower * 0.05
            lifeSpan: 80000
            velocity: PointDirection {
                x: 15 //Speed
                xVariation: 5 //Speed variation
            }
            acceleration: PointDirection {
                x: 0
            }
            size: 1
            sizeVariation: -1
            width: 1
            x: -100
        }

        ItemParticle {
            id: cloud
            system: cloudSys
            delegate: cloudDelegate
            fade: false
        }

        Component {
            id: cloudDelegate
            Rectangle {
                id: container
                width: 300
                height: 200
                color: 'transparent'
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: fog ? 'fog/fog-' + Math.ceil(Math.random() * 12) :
                                  /*time.endsWith(
                                      "d") ? */ 'showers/cloud-' + Math.ceil(
                                      Math.random(
                                          ) * 15) + '.png' /* : 'showers-night/cloud-'
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       + Math.ceil(Math.random(
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ) * 15) + '.png'*/
                }
            }
        }
    }
    Rectangle {
        id: sunRect
        visible: clear
        clip: true
        radius: units.largeSpacing
        color: "transparent"
        property int hour: Qt.formatTime(dataSource.data.Local.DateTime, "hh")
        anchors.fill: parent
        onHourChanged: {
            changeSun(sunContainer)
        }
        Rectangle {
            id: sun
            radius: units.largeSpacing
            color: "transparent"
            anchors.fill: parent
            clip: true
            Image {
                source: changeSun(sunContainer)
                id: sunContainer
                width: parent.width
                height: 622 * units.devicePixelRatio
                fillMode: Image.PreserveAspectFit
                clip: true
                opacity: 0.8
                SequentialAnimation {
                    loops: Animation.Infinite
                    running: sunRect.hour > 6
                             && sunRect.hour < 18 ? true : false
                    NumberAnimation {
                        target: sunContainer
                        properties: "opacity"
                        from: 0.3
                        to: 1
                        duration: 15000
                    }
                    NumberAnimation {
                        target: sunContainer
                        properties: "opacity"
                        from: 1
                        to: 0.3
                        duration: 15000
                    }
                    PauseAnimation {
                        duration: 10000
                    }
                }
            }
        }
        function changeSun(image) {
            var now = new Date()
            var hours = now.getHours()
            image.source = "sun/sun-" + hours + ".png"
            return image.source
        }
    }
    Rectangle {
        id: thunderRect
        visible: thunder
        radius: units.largeSpacing
        color: "transparent"
        anchors.fill: parent
        Image {
            id: flash1
            source: ""
            SequentialAnimation {
                id: flashAnimation
                loops: 1
                running: false
                NumberAnimation {
                    target: flash1
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 10
                }
                NumberAnimation {
                    target: flash1
                    properties: "opacity"
                    from: 1
                    to: 0
                    duration: 1500
                }
            }
        }
        Timer {
            running: true
            repeat: true
            triggeredOnStart: true
            interval: ((Math.random() * (15 - 1) + 1) - thunderPower) * 1000
            onTriggered: {
                flash1.source = "thunderstorms/lightning-" + Math.ceil(
                            Math.random() * 4) + ".png"
                flashAnimation.start()
            }
        }
    }
}
