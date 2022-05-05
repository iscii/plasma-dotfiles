import QtQuick 2.4

Flipable {
    id: container
    property bool flipped: false
    property int xAxis: 1
    property int yAxis: 0
    property int zAxis: 0
    property int angle: flipped ? -180 : 180

    width: front.width
    height: front.height
    z: 1
    function flipableClick() {
        container.opacity = 1
        container.flipped = !container.flipped
        time.start()
    }

    transform: Rotation {
        id: rotation
        origin.x: container.width / 2
        origin.y: container.height / 2
        axis.x: container.xAxis
        axis.y: container.yAxis
        axis.z: container.zAxis
    }

    states: [
        State {
            name: "back"
            when: container.flipped
            PropertyChanges {
                target: rotation
                angle: container.angle
            }
        }
    ]

    transitions: Transition {

        SequentialAnimation {
            ParallelAnimation {

                NumberAnimation {
                    target: rotation
                    properties: "angle"
                    duration: 500
                }
            }
        }
    }
    Timer {
        id: time
        interval: 500
        repeat: false
        onTriggered: {
            container.opacity = 0
            container.flipped = false
        }
    }
}
