/*
 * Copyright 2013  Bhushan Shah <bhush94@gmail.com>
 * Copyright 2013 Sebastian Kügler <sebas@kde.org>
 * Copyright 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 * Copyright 2019 Zlatko Barnak <zlatko@equilibriumos.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.0
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.0 as QtLayouts
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

Item {
    id: appearancePage
    width: childrenRect.width
    height: childrenRect.height

    signal configurationChanged

    property string cfg_fontFamily
    property alias cfg_boldText: boldCheckBox.checked
    property string cfg_timeFormat: ""
    property alias cfg_italicText: italicCheckBox.checked

    property alias cfg_showLocalTimezone: showLocalTimezone.checked
    property alias cfg_displayTimezoneAsCode: timezoneCodeRadio.checked

    property alias cfg_showDate: showDate.checked
    property string cfg_dateFormat: "shortDate"

    onCfg_fontFamilyChanged: {
        // HACK by the time we populate our model and/or the ComboBox is finished the value is still undefined
        if (cfg_fontFamily) {
            for (var i = 0, j = fontsModel.count; i < j; ++i) {
                if (fontsModel.get(i).value == cfg_fontFamily) {
                    fontFamilyComboBox.currentIndex = i
                    break
                }
            }
        }
    }

    ListModel {
        id: fontsModel
        Component.onCompleted: {
            var arr = [] // use temp array to avoid constant binding stuff
            arr.push({text: i18nc("Use default font", "Default"), value: ""})

            var fonts = Qt.fontFamilies()
            var foundIndex = 0
            for (var i = 0, j = fonts.length; i < j; ++i) {
                arr.push({text: fonts[i], value: fonts[i]})
            }
            append(arr)
        }
    }

    QtLayouts.ColumnLayout {
        anchors.left: parent.left

        QtControls.GroupBox {
            QtLayouts.Layout.fillWidth: true
            title: i18n("Information")
            flat: true

            QtLayouts.ColumnLayout {
                QtControls.CheckBox {
                    id: showDate
                    text: i18n("Show date")
                }



                QtControls.CheckBox {
                    id: showLocalTimezone
                    text: i18n("Show local time zone")
                }

                QtControls.Label {
                    text: i18n("Display time zone as:")
                }

                QtControls.GroupBox {
                    QtLayouts.Layout.fillWidth: true
                    flat: true
                    QtLayouts.ColumnLayout {

                        QtControls.ExclusiveGroup { id: timezoneDisplayType }

                        QtControls.RadioButton {
                            id: timezoneCityRadio
                            text: i18n("Time zone city")
                            exclusiveGroup: timezoneDisplayType
                        }

                        QtControls.RadioButton {
                            id: timezoneCodeRadio
                            text: i18n("Time zone code")
                            exclusiveGroup: timezoneDisplayType
                        }
                    }
                }

            }
        }

        QtLayouts.RowLayout {
            QtLayouts.Layout.fillWidth: true

            QtControls.Label {
                text: i18n("Font style:")
            }

            QtControls.ComboBox {
                id: fontFamilyComboBox
                QtLayouts.Layout.fillWidth: true
                // ComboBox's sizing is just utterly broken
                QtLayouts.Layout.minimumWidth: units.gridUnit * 10
                model: fontsModel
                // doesn't autodeduce from model because we manually populate it
                textRole: "text"

                onCurrentIndexChanged: {
                    var current = model.get(currentIndex)
                    if (current) {
                        cfg_fontFamily = current.value
                        appearancePage.configurationChanged()
                    }
                }
            }

            QtControls.Button {
                id: boldCheckBox
                tooltip: i18n("Bold text")
                iconName: "format-text-bold"
                checkable: true
                Accessible.name: tooltip
            }

            QtControls.Button {
                id: italicCheckBox
                tooltip: i18n("Italic text")
                iconName: "format-text-italic"
                checkable: true
                Accessible.name: tooltip
            }
        }
    }

    Component.onCompleted: {
        if (plasmoid.configuration.displayTimezoneAsCode) {
            timezoneCodeRadio.checked = true;
        } else {
            timezoneCityRadio.checked = true;
        }
    }
}
