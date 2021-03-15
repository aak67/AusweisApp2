/*
 * \copyright Copyright (c) 2018-2021 Governikus GmbH & Co. KG, Germany
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import Governikus.Global 1.0
import Governikus.Style 1.0
import Governikus.TitleBar 1.0
import Governikus.View 1.0
import Governikus.Type.ApplicationModel 1.0
import Governikus.Type.LogModel 1.0


SectionPage
{
	id: root

	signal keyPressed(int key)

	Accessible.name: qsTr("Log viewer")
	Accessible.description: qsTr("This is the log viewer of the AusweisApp2.")

	Keys.onPressed: keyPressed(event.key)

	titleBarAction: TitleBarAction {
		//: LABEL DESKTOP_QML
		text: qsTr("Logs")
		helpTopic: "applicationLog"
	}

	TabbedPane {
		id: tabbedPane

		anchors.fill: parent
		anchors.margins: Constants.pane_padding

		sectionsModel: LogModel.logFiles
		onCurrentIndexChanged: LogModel.setLogfile(currentIndex)

		contentDelegate: logSectionDelegate
		contentPadding: 0

		footerItem: Item {
			height: buttonLayout.implicitHeight

			ColumnLayout {
				id: buttonLayout

				anchors {
					left: parent.left
					right: parent.right
					rightMargin: Constants.groupbox_spacing
				}
				spacing: Constants.groupbox_spacing

				GButton {
					id: saveLog

					Layout.fillWidth: true

					icon.source: "qrc:///images/desktop/material_save.svg"
					//: LABEL DESKTOP_QML
					text: qsTr("Save log")
					enabled: tabbedPane.sectionsModel.length > 0
					tintIcon: true
					onClicked: {
						let filenameSuggestion = LogModel.createLogFileName(LogModel.getCurrentLogfileDate())
						appWindow.openSaveFileDialog(LogModel.saveCurrentLogfile, filenameSuggestion, qsTr("Logfiles"), "log")
					}
				}

				GButton {
					id: removeLog

					Layout.fillWidth: true

					icon.source: "qrc:///images/material_delete.svg"
					//: LABEL DESKTOP_QML
					text: qsTr("Delete log")
					enableButton: tabbedPane.currentIndex > 0
					disabledTooltipText: qsTr("The current log will be automatically deleted at exit.")

					tintIcon: true
					onClicked: {
						confirmationPopup.deleteAll = false
						confirmationPopup.open()
					}
				}

				GButton {
					id: removeAllLogs

					Layout.fillWidth: true

					icon.source: "qrc:///images/trash_icon_all.svg"
					//: LABEL DESKTOP_QML
					text: qsTr("Delete old logs")
					enableButton: tabbedPane.sectionsModel.length > 1
					tintIcon: true
					onClicked: {
						confirmationPopup.deleteAll = true
						confirmationPopup.open()
					}
				}

				GButton {
					property QtObject detachedLogViewItem: null

					Layout.fillWidth: true

					icon.source: "qrc:///images/desktop/material_open_in_browser.svg"
					text: qsTr("Detach log viewer")
					tintIcon: true

					onClicked: appWindow.showDetachedLogView()
				}
			}
		}
	}

	Component {
		id: logSectionDelegate

		Item {
			height: tabbedPane.availableHeight
			width: parent.width

			GListView {
				id: logView

				anchors {
					fill: parent
					topMargin: Constants.component_spacing
					leftMargin: Constants.component_spacing
					bottomMargin: Constants.component_spacing
				}

				activeFocusOnTab: true

				displayMarginBeginning: Constants.pane_padding
				displayMarginEnd: Constants.pane_padding

				model: LogModel
				spacing: Constants.text_spacing
				delegate: LogViewDelegate {
					width: logView.width - 2 * Constants.pane_padding
				}

				Connections {
					target: LogModel
					onFireNewLogMsg: if (logView.atYEnd) logView.positionViewAtEnd()
				}

				Connections {
					target: root
					onKeyPressed: logView.handleKeyPress(key)
				}
			}

			FocusFrame {
				scope: logView
				framee: logView
				borderColor: Style.color.focus_indicator
			}
		}
	}

	ConfirmationPopup {
		id: confirmationPopup

		property bool deleteAll: true

		width: ApplicationModel.scaleFactor * 600

		title: (deleteAll ?
				//: LABEL DESKTOP_QML
				qsTr("Delete old logs") :
				//: LABEL DESKTOP_QML
				qsTr("Delete selected log")
			   )
		//: INFO DESKTOP_QML All logfiles are about to be removed, user confirmation required.
		text: (deleteAll ? qsTr("All old logs will be deleted.")
						 //: INFO DESKTOP_QML The current logfile is about to be removed, user confirmation required.
						 : qsTr("The log will be deleted.")
			   )
		onConfirmed: deleteAll ? LogModel.removeOtherLogfiles() : LogModel.removeCurrentLogfile()
	}
}
