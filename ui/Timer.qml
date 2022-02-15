import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.12
import QtQml.Models 2.12
import org.kde.kirigami 2.9 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.CardDelegate {
    id: timerFrame
    property int timerCount: sessionData.activeTimerCount
    property int previousCount: 0
    property bool horizontalMode: timerFrame.width >= timerFrame.height ? 1 : 0

    function getEndPos(){
        var ratio = horizontalMode ? 1.0 - timerFlick.visibleArea.widthRatio : 1.0 - timerFlick.visibleArea.heightRatio
        var endPos = horizontalMode ? timerFlick.contentWidth * ratio : timerFlick.contentHeight * ratio
        return endPos;
    }

    function scrollToEnd(){
        if (horizontalMode) {
            timerFlick.contentX = getEndPos();
        } else {
            timerFlick.contentY = getEndPos();
        }
    }

    onTimerCountChanged: {
        if(timerCount == timerViews.count){
            if(previousCount < timerCount) {
                previousCount = previousCount + 1
            }
        }
    }

    onPreviousCountChanged: {
        scrollToEnd()
    }

    Flickable {
        id: timerFlick
        anchors.fill: parent
        contentWidth: horizontalMode ? (timerViews.count == 1 ? width : width / 2.5 * timerViews.count) : parent.width
        contentHeight: horizontalMode ? parent.height : (timerViews.count == 1 ? height : height / 2.5 * timerViews.count)
        clip: true

        Grid {
            id: timerViewLayout
            width: parent.width
            height: parent.height
            spacing: Mycroft.Units.gridUnit / 3
            rows: horizontalMode ? 1 : timerViews.count
            columns: horizontalMode ? timerViews.count : 1

            Repeater {
                id: timerViews
                width: horizontalMode ? timerFlick.width : parent.width
                height: horizontalMode ? parent.height : timerFlick.height
                model: sessionData.activeTimers.timers
                property alias horizontalMode: timerFrame.horizontalMode

                delegate: TimerCard {
                }
                onItemRemoved: {
                    timerFlick.returnToBounds()
                }
            }
        }
    }
}
