import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.11 as Kirigami
import Mycroft 1.0 as Mycroft

ItemDelegate {
    id: timerCard
    implicitHeight: timerViews.height
    implicitWidth: timerViews.count == 1 ? timerViews.width : timerViews.width / 2.5
    property color primaryColor: "#F7458E"
    property color secondaryColor: "#F7958E"
    property color expiredColor: "white"

    background: Rectangle {
        color: "#313131"
        border.color: "#212121"
        border.width: 1
        radius: 15
    }

    contentItem: Item {

        Item {
            id: topArea
            width: parent.width
            height: parent.height * 0.15
            anchors.top: parent.top

            Label {
               color: timerCard.secondaryColor
               fontSizeMode: Text.Fit
               minimumPixelSize: 5
               font.pixelSize: 72
               anchors.fill: parent
               anchors.margins: 10
               verticalAlignment: Text.AlignVCenter
               horizontalAlignment: Text.AlignHCenter
               text: modelData.timerName
            }
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: topArea.bottom
            anchors.bottom: bottomArea.top
            anchors.bottomMargin: parent.height * 0.10
            anchors.topMargin: parent.height * 0.10

            Rectangle {
                id: dialArea
                width: parent.height * 0.95
                height: width
                anchors.centerIn: parent

                color: "transparent"

                RoundProgress {
                    id: dddial
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    text: modelData.timeDelta
                    value: parseFloat(modelData.percentRemaining).toFixed(2);
                }
            }
        }

        Item {
            id: bottomArea
            width: parent.width
            height: parent.height * 0.15
            anchors.bottom: parent.bottom

            RowLayout {
                anchors.fill: parent

                Button {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    background: Rectangle {
                        color: "transparent"
                        border.color: timerCard.primaryColor
                        radius: 6
                    }

                    contentItem: Item {
                        Kirigami.Icon {
                            anchors.centerIn: parent
                            source: Qt.resolvedUrl("icons/close.svg")
                            width: parent.height * 0.75
                            height: parent.height * 0.75
                            color: "white"
                        }
                    }

                    onClicked: {
                        if (timerViews.count == 1) {
                            Mycroft.MycroftController.sendText("cancel all timers")
                        }
                        triggerGuiEvent("timerskill.gui.stop.timer", {"timer": modelData})
                    }
                }
            }
        }
    }
}
