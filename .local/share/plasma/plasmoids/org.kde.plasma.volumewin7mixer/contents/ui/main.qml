/*
	Copyright 2014-2015 Harald Sitter <sitter@kde.org>

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation; either version 2 of
	the License or (at your option) version 3 or any later version
	accepted by the membership of KDE e.V. (or its successor approved
	by the membership of KDE e.V.), which shall act as a proxy
	defined in Section 14 of version 3 of the license.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles.Plasma 2.0 as PlasmaStyles

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

import org.kde.plasma.private.volume 0.1 as PlasmaVolume

import "./code/Utils.js" as Utils
import "./code/PulseObjectCommands.js" as PulseObjectCommands
import "lib"

DialogApplet {
	id: main

	AppletConfig { id: config }
	
	property string draggedStreamType: ''
	property QtObject draggedStream: null
	function startDrag(pulseObject, type) {
		draggedStreamType = type
		draggedStream = pulseObject
	}
	function clearDrag() {
		draggedStream = null
		draggedStreamType = ''
	}

	property string displayName: i18nd("plasma_applet_org.kde.plasma.volume", "Audio Volume")
	property string speakerIcon: Utils.iconNameForStream(sinkModel.defaultSink)
	
	compactItemIcon: speakerIcon
	onCompactItemClicked: {
		if (mouse.button == Qt.LeftButton) {
			main.toggleDialog(false)
		} else if (mouse.button == Qt.MiddleButton) {
			toggleDefaultSinksMute()
		}
	}
	onCompactItemWheel: {
		var delta = wheel.angleDelta.y || wheel.angleDelta.x
		if (delta > 0) {
			increaseDefaultSinkVolume()
		} else if (delta < 0) {
			decreaseDefaultSinkVolume()
		}
	}

	Plasmoid.icon: {
		if (mpris2Source.hasPlayer && mpris2Source.albumArt) {
			return mpris2Source.albumArt
		} else {
			return speakerIcon
		}
	}
	Plasmoid.toolTipMainText: {
		if (mpris2Source.hasPlayer && mpris2Source.track) {
			return mpris2Source.track
		} else {
			return displayName
		}
	}
	Plasmoid.toolTipSubText: {
		var lines = []
		if (mpris2Source.hasPlayer && mpris2Source.artist) {
			if (mpris2Source.isPaused) {
				lines.push(mpris2Source.artist ? i18ndc("plasma_applet_org.kde.plasma.mediacontroller", "Artist of the song", "by %1 (paused)", mpris2Source.artist) : i18nd("plasma_applet_org.kde.plasma.mediacontroller", "Paused"))
			} else if (mpris2Source.artist) {
				lines.push(i18ndc("plasma_applet_org.kde.plasma.mediacontroller", "Artist of the song", "by %1", mpris2Source.artist))
			}
		}
		if (sinkModel.defaultSink) {
			var sinkVolumePercent = Math.round(PulseObjectCommands.volumePercent(sinkModel.defaultSink.volume))
			lines.push(i18nd("plasma_applet_org.kde.plasma.volume", "Volume at %1%", sinkVolumePercent))
			lines.push(sinkModel.defaultSink.description)
		}
		return lines.join('\n')
	}


	property bool showMediaController: plasmoid.configuration.showMediaController
	property string mediaControllerLocation: plasmoid.configuration.mediaControllerLocation || 'bottom'
	property bool mediaControllerVisible: showMediaController && mpris2Source.hasPlayer
	// property int mediaControllerHeight: 56 // = 48px albumArt + 8px seekbar

	dialogContents: Item {
		id: dialogContents

		width: mixerItemRow.width
		height: config.mixerGroupHeight + (mediaControllerVisible ? config.mediaControllerHeight : 0)


		// Keyboard Navigation/Controls
		InputManager { id: inputManager }
		focus: true
		Keys.forwardTo: inputManager.hasSelection ? [inputManager.selectedMixerItem] : []
		Keys.onLeftPressed: inputManager.selectLeft()
		Keys.onRightPressed: inputManager.selectRight()
		function fireKeyOnDefault(keyName, event) {
			if (!inputManager.hasSelection) {
				inputManager.selectDefault()
				var fnName = 'on' + keyName + 'Pressed'
				inputManager.selectedMixerItem.Keys[fnName](event) // Manually trigger since it hasn't been forwarded yet.
			}
		}
		Keys.onUpPressed: fireKeyOnDefault('Up', event)
		Keys.onDownPressed: fireKeyOnDefault('Down', event)
		Keys.onPressed: fireKeyOnDefault('', event)

		Row {
			id: mixerItemRow
			anchors.right: parent.right
			width: childrenRect.width
			height: parent.height - (mediaControllerVisible ? config.mediaControllerHeight : 0)
			spacing: 10

			MixerItemGroup {
				id: sourceOutputMixerItemGroup
				height: parent.height
				title: i18n("Recording Apps")

				model: appOutputsModel
				mixerGroupType: 'SourceOutput'
			}

			MixerItemGroup {
				id: sinkInputMixerItemGroup
				height: parent.height
				title: i18n("Apps")

				model: appsModel
				mixerGroupType: 'SinkInput'
			}

			MixerItemGroup {
				id: sourceMixerItemGroup
				height: parent.height
				title: i18n("Mics")
		
				model: filteredSourceModel
				mixerGroupType: 'Source'
			}

			MixerItemGroup {
				id: sinkMixerItemGroup
				height: parent.height
				title: i18n("Speakers")
				
				model: filteredSinkModel
				mixerGroupType: 'Sink'
			}

		}

		MediaController {
			id: mediaController
			width: mixerItemRow.width
			height: config.mediaControllerHeight
		}

		PlasmaComponents.ToolButton {
			id: pinButton
			anchors.top: parent.top
			anchors.right: parent.right
			width: Math.round(units.gridUnit * 1.25)
			height: width
			checkable: true
			iconSource: "window-pin"
			onCheckedChanged: plasmoid.hideOnWindowDeactivate = !checked
		}

		states: [
			State {
				name: "mediaControllerHidden"
				when: !mediaControllerVisible
				PropertyChanges {
					target: mixerItemRow
					anchors.top: mixerItemRow.parent.top
					anchors.bottom: mixerItemRow.parent.bottom
				}
				PropertyChanges {
					target: mediaController
					visible: false
				}
			},
			State {
				name: "mediaControllerTop"
				when: mediaControllerVisible && mediaControllerLocation == 'top'
				PropertyChanges {
					target: mixerItemRow
					// anchors.top: undefined
					anchors.topMargin: config.mediaControllerHeight
					anchors.bottom: mixerItemRow.parent.bottom
				}
				PropertyChanges {
					target: mediaController
					visible: true
					anchors.left: mediaController.parent.left
					anchors.top: mediaController.parent.top
					anchors.bottom: mixerItemRow.top
				}
				PropertyChanges {
					target: pinButton
					anchors.topMargin: config.mediaControllerHeight
				}
			},
			State {
				name: "mediaControllerBottom"
				when: mediaControllerVisible && mediaControllerLocation == 'bottom'
				PropertyChanges {
					target: mixerItemRow
					anchors.top: mixerItemRow.parent.top
					// anchors.bottom: undefined
					anchors.bottomMargin: config.mediaControllerHeight
				}
				PropertyChanges {
					target: mediaController
					visible: true
					anchors.left: mediaController.parent.left
					anchors.top: mixerItemRow.bottom
					anchors.right: mediaController.parent.right
					anchors.bottom: mediaController.parent.bottom
				}
			}
		]
	}

	function increaseDefaultSinkVolume() {
		if (!sinkModel.defaultSink) {
			return
		}
		sinkModel.defaultSink.muted = false
		var volume = PulseObjectCommands.increaseVolume(sinkModel.defaultSink)
		osd.showVolume(volume)
		playFeedback()
	}

	function decreaseDefaultSinkVolume() {
		if (!sinkModel.defaultSink) {
			return
		}
		sinkModel.defaultSink.muted = false
		var volume = PulseObjectCommands.decreaseVolume(sinkModel.defaultSink)
		osd.showVolume(volume)
		playFeedback()
	}

	function toggleDefaultSinksMute() {
		if (!sinkModel.defaultSink) {
			return
		}
		var toMute = PulseObjectCommands.toggleMute(sinkModel.defaultSink)
		osd.showVolume(toMute ? 0 : sinkModel.defaultSink.volume)
		playFeedback()
	}

	function increaseDefaultSourceVolume() {
		if (!sourceModel.defaultSource) {
			return
		}
		sourceModel.defaultSource.muted = false
		var volume = PulseObjectCommands.increaseVolume(sourceModel.defaultSource)
		osd.showMicVolume(volume)
	}
	
	function decreaseDefaultSourceVolume() {
		if (!sourceModel.defaultSource) {
			return
		}
		sourceModel.defaultSource.muted = false
		var volume = PulseObjectCommands.decreaseVolume(sourceModel.defaultSource)
		osd.showMicVolume(volume)
	}

	function toggleDefaultSourceMute() {
		if (!sourceModel.defaultSource) {
			return
		}
		var toMute = PulseObjectCommands.toggleMute(sourceModel.defaultSource)
		osd.showMicVolume(toMute ? 0 : sourceModel.defaultSource.volume)
	}

	// Connections {
	// 	target: sinkModel
	// 	onDefaultSinkChanged: {
	// 		// console.log('sinkModel.onDefaultSinkChanged', sinkModel.defaultSink)
	// 		if (!sinkModel.defaultSink) {
	// 			return
	// 		}
	// 		if (plasmoid.configuration.moveAllAppsOnSetDefault) {
	// 			// console.log(appsModel, appsModel.count)
	// 			for (var i = 0; i < appsModel.count; i++) {
	// 				var stream = appsModel.get(i)
	// 				stream = stream.PulseObject
	// 				// console.log(i, stream, stream.name, stream.deviceIndex, sinkModel.defaultSink.index)
	// 				stream.deviceIndex = sinkModel.defaultSink.index
	// 			}
	// 		}
	// 	}
	// }

	PlasmaVolume.GlobalActionCollection {
		// KGlobalAccel cannot transition from kmix to something else, so if
		// the user had a custom shortcut set for kmix those would get lost.
		// To avoid this we hijack kmix name and actions. Entirely mental but
		// best we can do to not cause annoyance for the user.
		// The display name actually is updated to whatever registered last
		// though, so as far as user visible strings go we should be fine.
		// As of 2015-07-21:
		//   componentName: kmix
		//   actions: increase_volume, decrease_volume, mute
		name: "kmix"
		displayName: main.displayName
		PlasmaVolume.GlobalAction {
			objectName: "increase_volume"
			text: i18nd("plasma_applet_org.kde.plasma.volume", "Increase Volume")
			shortcut: Qt.Key_VolumeUp
			onTriggered: increaseDefaultSinkVolume()
		}
		PlasmaVolume.GlobalAction {
			objectName: "decrease_volume"
			text: i18nd("plasma_applet_org.kde.plasma.volume", "Decrease Volume")
			shortcut: Qt.Key_VolumeDown
			onTriggered: decreaseDefaultSinkVolume()
		}
		PlasmaVolume.GlobalAction {
			objectName: "mute"
			text: i18nd("plasma_applet_org.kde.plasma.volume", "Mute")
			shortcut: Qt.Key_VolumeMute
			onTriggered: toggleDefaultSinksMute()
		}
		PlasmaVolume.GlobalAction {
			objectName: "increase_microphone_volume"
			text: i18nd("plasma_applet_org.kde.plasma.volume", "Increase Microphone Volume")
			shortcut: Qt.Key_MicVolumeUp
			onTriggered: increaseDefaultSourceVolume()
		}
		PlasmaVolume.GlobalAction {
			objectName: "decrease_microphone_volume"
			text: i18nd("plasma_applet_org.kde.plasma.volume", "Decrease Microphone Volume")
			shortcut: Qt.Key_MicVolumeDown
			onTriggered: decreaseDefaultSourceVolume()
		}
		PlasmaVolume.GlobalAction {
			objectName: "mic_mute"
			text: i18nd("plasma_applet_org.kde.plasma.volume", "Mute Microphone")
			shortcut: Qt.Key_MicMute
			onTriggered: toggleDefaultSourceMute()
		}
	}

	ExecUtil {
		id: executable
	}

	PlasmaVolume.VolumeOSD {
		id: osd

		function showVolume(volume) {
			if (plasmoid.configuration.showOsd) {
				var volPercent = PulseObjectCommands.volumePercent(volume)
				try {
					// Plasma 5.19 and below
					osd.show(volPercent)
				} catch (e) { // invalid number of arguments
					// Plasma 5.20
					var maxPercent = volPercent > 100 ? 150 : 100
					osd.show(volPercent, maxPercent)
				}
			}
		}

		function showMicVolume(volume) {
			if (plasmoid.configuration.showOsd) {
				var volPercent = PulseObjectCommands.volumePercent(volume)
				osd.showMicrophone(volPercent)
			}
		}
	}

	PlasmaVolume.VolumeFeedback {
		id: feedback
	}

	function playFeedback(sinkIndex) {
		if (!plasmoid.configuration.volumeChangeFeedback) {
			return
		}
		if (sinkIndex == undefined) {
			sinkIndex = sinkModel.defaultSink.index
		}
		feedback.play(sinkIndex)
	}

	Mpris2DataSource {
		id: mpris2Source
	}

	// https://github.com/KDE/plasma-pa/tree/master/src/kcm/package/contents/ui
	DynamicFilterModel {
		id: appsModel
		sourceModel: PlasmaVolume.SinkInputModel {}
	}
	DynamicFilterModel {
		id: appOutputsModel
		sourceModel: PlasmaVolume.SourceOutputModel {}
	}
	DynamicFilterModel {
		id: filteredSourceModel
		sourceModel: PlasmaVolume.SourceModel {
			id: sourceModel
		}
	}
	DynamicFilterModel {
		id: filteredSinkModel
		sourceModel: PlasmaVolume.SinkModel {
			id: sinkModel
		}
	}
	// DynamicFilterModel {
	// 	id: filteredStreamRestoreModel
	// 	sourceModel: PlasmaVolume.StreamRestoreModel {
	// 		id: streamRestoreModel
	// 	}
	// }
	DynamicFilterModel {
		id: filteredCardModel
		sourceModel: PlasmaVolume.CardModel {
			id: cardModel
		}
	}
	function findStream(model, predicate) {
		for (var i = 0; i < model.count; i++) {
			var stream = model.get(i)
			stream = stream.PulseObject
			// console.log(i, stream, predicate(stream, i))
			if (predicate(stream, i)) {
				return i
			}
		}
		return -1
	}
	function getStream(model, predicate) {
		for (var i = 0; i < model.count; i++) {
			var stream = model.get(i)
			stream = stream.PulseObject
			// console.log(i, stream, predicate(stream, i))
			if (predicate(stream, i)) {
				return stream
			}
		}
		return null
	}

	function action_alsamixer() {
		executable.exec("konsole -e alsamixer")
	}

	function action_pavucontrol() {
		executable.exec("pavucontrol")
	}

	Component.onCompleted: {
		if (plasmoid.hasOwnProperty("activationTogglesExpanded")) {
			plasmoid.activationTogglesExpanded = true
		}

		plasmoid.setAction("pavucontrol", i18n("PulseAudio Control"), "configure")
		plasmoid.setAction("alsamixer", i18n("AlsaMixer"), "configure")

		var widgetName = i18nd("plasma_applet_org.kde.plasma.volume", "Audio Volume")
		var configureText = i18ndc("libplasma5", "%1 is the name of the applet", "%1 Settings...", widgetName) // plasma-framework
		plasmoid.setAction("configure", configureText, "configure")

		// plasmoid.action("configure").trigger()
	}
}
