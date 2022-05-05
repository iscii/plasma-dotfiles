import QtQuick 2.4
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import QtGraphicalEffects 1.0

Item {
    width: Math.round(background.width)
    height: Math.round(background.height)
    property string startcolor: "white"
    property string endcolor: "black"
    property int shift: -testLabel.y / 2
    Component.onCompleted: {
        shift = -testLabel.y / 2
    }

    TextMetrics {
        id: textmetrics
        text: formatTime(time)
        font.pixelSize: timeFontSize
        font.family: comfortaa.name
        font.letterSpacing: 0
        font.kerning: true
        font.hintingPreference: Font.PreferFullHinting
    }

    Rectangle {
        id: background
        height: textmetrics.boundingRect.height + units.largeSpacing
        width: textmetrics.boundingRect.height + units.largeSpacing
        color: "white"
        radius: units.smallSpacing * 2
        anchors.centerIn: parent
        anchors.margins: 0
        Rectangle {
            id: topback
            anchors {
                top: background.top
                left: background.left
                right: background.right
            }
            anchors.margins: 0
            width: background.width
            height: background.height / 2
            color: "transparent"
            Rectangle {
                id: topop
                clip: true
                height: Math.round(timeLabel.paintedHeight / 2)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                PlasmaComponents.Label {
                    opacity: 0
                    id: testLabel
                    text: formatTime(time)
                    renderType: Text.NativeRendering
                    font: textmetrics.font
                    width: textmetrics.tightBoundingRect.width
                    height: textmetrics.tightBoundingRect.height
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    lineHeightMode: Text.FixedHeight
                    lineHeight: textmetrics.tightBoundingRect.height
                }
                LinearGradient {
                    anchors.fill: parent
                    source: parent
                    start: Qt.point(0, 0)
                    end: Qt.point(0, topop.height)
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: "white"
                        }
                        GradientStop {
                            position: 1.0
                            color: "grey"
                        }
                    }
                }
                PlasmaComponents.Label {
                    opacity: 1
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    z: 99
                    id: timeLabel
                    renderType: Text.NativeRendering
                    text: formatTime(time)
                    font: textmetrics.font
                    color: "black"
                    width: topop.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    onTextChanged: {
                        flipable.flipableClick()
                    }
                    transform: Translate {
                        y: shift
                    }
                }
            }
        }
        Rectangle {
            id: bottomback

            anchors {
                left: background.left
                right: background.right
                bottom: background.bottom
            }
            width: background.width
            height: Math.round(background.height / 2)
            color: "grey"
            radius: units.smallSpacing * 2
            clip: true
            LinearGradient {
                anchors.fill: parent
                source: parent
                start: Qt.point(0, 0)
                end: Qt.point(0, parent.height)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "white"
                    }
                    GradientStop {
                        position: 1.0
                        color: "grey"
                    }
                }
            }
            Rectangle {
                id: botop
                anchors.left: parent.left
                anchors.right: parent.right
                height: timeLabel2.paintedHeight / 2
                implicitWidth: parent.width
                anchors.top: parent.top
                color: "transparent"
                radius: units.smallSpacing * 2

                PlasmaComponents.Label {
                    opacity: 1
                    id: timeLabel2
                    renderType: Text.NativeRendering
                    anchors.bottom: botop.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    text: flipable.flipped ? formatTime(time - 1) == "0-1"
                                             || formatTime(
                                                 time - 1) == "00" ? maxtime : formatTime(
                                                                         time - 1) : formatTime(
                                                                         time)
                    font: textmetrics.font
                    color: "black"
                    width: parent.width
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    transform: Translate {
                        y: shift
                    }
                }
            }
            PlasmaComponents.Label {
                text: flipable.flipped ? Qt.formatTime(
                                             dataSource.data.Local.DateTime,
                                             "AP") == "AM" ? "PM" : "AM" : Qt.formatTime(
                                                                 dataSource.data.Local.DateTime,
                                                                 "AP")
                renderType: Text.NativeRendering
                visible: !cfg_is24 && formatAP()
                anchors.left: parent.left
                anchors.leftMargin: units.smallSpacing * 2
                anchors.bottom: bottomback.bottom
                anchors.bottomMargin: units.smallSpacing
                font.weight: Font.Bold
            }
            LinearGradient {
                id: fillbot
                anchors.fill: botop
                visible: false
                source: botop
                start: Qt.point(0, 0)
                end: Qt.point(0, botop.height)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: startcolor
                    }
                    GradientStop {
                        position: 0.3
                        color: endcolor
                    }
                }
            }
            OpacityMask {
                z: 1
                anchors.fill: botop
                source: fillbot
                maskSource: botop
            }
        }
        Rectangle {
            height: background.height
            width: background.width
            color: "transparent"
            CustomizeFlipable {
                id: flipable
                flipped: false
                anchors.fill: parent
                front: Rectangle {
                    id: fliptop2
                    radius: units.smallSpacing * 2
                    color: "white"
                    width: parent.width
                    height: Math.round(background.height / 2)
                    clip: true
                    LinearGradient {
                        id: filltop2
                        anchors.fill: parent
                        //    visible: false
                        source: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: "white"
                            }
                            GradientStop {
                                position: 1.0
                                color: "grey"
                            }
                        }
                    }
                    Rectangle {
                        id: fliptop
                        radius: units.smallSpacing * 2
                        implicitHeight: Math.round(
                                            timeLabel222.paintedHeight / 2)
                        implicitWidth: parent.width
                        anchors.bottom: parent.bottom
                        color: "transparent"
                        PlasmaComponents.Label {
                            opacity: 1
                            id: timeLabel222
                            renderType: Text.NativeRendering
                            text: flipable.flipped ? formatTime(
                                                         time - 1) == "0-1"
                                                     || formatTime(time - 1)
                                                     == "00" ? maxtime : formatTime(
                                                                   time - 1) : formatTime(
                                                                   time)
                            font: textmetrics.font
                            color: "black"
                            width: parent.width
                            height: parent.height
                            Layout.fillWidth: true
                            horizontalAlignment: "AlignHCenter"
                            verticalAlignment: "AlignTop"
                            transform: Translate {
                                y: shift
                            }
                        }
                    }
                }
                back: Rectangle {
                    id: flipbottom
                    radius: units.smallSpacing * 2
                    color: "white"
                    width: parent.width
                    height: Math.round(parent.height / 2)
                    clip: true
                    LinearGradient {
                        anchors.fill: parent
                        source: parent
                        start: Qt.point(0, 0)
                        end: Qt.point(0, parent.height)
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: "white"
                            }
                            GradientStop {
                                position: 1.0
                                color: "grey"
                            }
                        }
                    }
                    Rectangle {
                        id: flipbot
                        implicitHeight: Math.round(
                                            timeLabel223.paintedHeight / 2)
                        implicitWidth: parent.width
                        anchors.top: parent.top
                        color: "transparent"
                        PlasmaComponents.Label {
                            opacity: 1
                            id: timeLabel223
                            renderType: Text.NativeRendering
                            text: formatTime(time)
                            font: textmetrics.font
                            color: "black"
                            width: parent.width
                            height: parent.height
                            Layout.fillWidth: true
                            horizontalAlignment: "AlignHCenter"
                            verticalAlignment: "AlignBottom"
                            transform: Translate {
                                y: shift
                            }
                        }
                    }
                    PlasmaComponents.Label {
                        text: Qt.formatTime(dataSource.data.Local.DateTime,
                                            "AP")
                        visible: !cfg_is24 && formatAP()
                        renderType: Text.NativeRendering
                        anchors.left: parent.left
                        anchors.leftMargin: units.smallSpacing * 2
                        anchors.bottom: flipbottom.bottom
                        font.weight: Font.Bold
                    }
                    LinearGradient {
                        id: fillflipbot
                        anchors.fill: flipbot
                        visible: false
                        source: flipbot
                        start: Qt.point(0, 0)
                        end: Qt.point(0, flipbot.height)
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: startcolor
                            }
                            GradientStop {
                                position: 0.3
                                color: endcolor
                            }
                        }
                    }
                    OpacityMask {
                        z: 1
                        anchors.fill: flipbot
                        source: fillflipbot
                        maskSource: flipbot
                    }
                }
            }
        }
        Rectangle {
            id: centerline
            width: parent.width
            height: 1
            color: "grey"
            anchors.centerIn: parent
            opacity: 0.5
        }
        LinearGradient {
            id: fill
            anchors.fill: centerline
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: startcolor
                }
                GradientStop {
                    position: 1.0
                    color: endcolor
                }
            }
        }
        OpacityMask {
            z: 999
            anchors.fill: centerline
            source: fill
            maskSource: centerline
        }
    }
    function formatTime(time) {
        var ptime = parseInt(time)
        if (ptime > maxtime) {
            time = mintime
        }
        ptime = parseInt(time)
        if (ptime < 10) {
            return "0" + ptime
        }
        return ptime
    }
    function formatAP() {
        return ishours
    }
}
