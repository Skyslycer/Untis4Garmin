import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;

module Untis4GarminActions {
    const monthDays = [
        31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ];

    public function nextDay() as Void {
        dateD++;
        if (dateD > monthDays[dateM - 1]) {
            dateM++;
            if (dateM > 12) {
                dateYe++;
                if (dateYe % 4 == 0) {
                    monthDays[1] = 29;
                } else {
                    monthDays[1] = 28;
                }
                    dateM = 1;
            }
            dateD = 1;
        }

        updateTimetable = true;
        lessonNumber = 0;
        updateLessonNumber = false;
        WatchUi.requestUpdate();
    }

    public function previousDay() as Void {
        dateD--;
        if (dateD < 1) {
            dateM--;
            if (dateM < 1) {
                dateYe--;
                if (dateYe % 4 == 0) {
                    monthDays[1] = 29;
                } else {
                    monthDays[1] = 28;
                }
                dateM = 12;
            }
            dateD = monthDays[dateM - 1];
        }

        updateTimetable = true;
        lessonNumber = 0;
        updateLessonNumber = false;
        WatchUi.requestUpdate();
    }

    public function nextLesson() as Void {
        var timetableData = apiClient.timetableData;
        var info = Toybox.Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var timetableAvailable = apiClient.timetableAvailable;
        if ((dateD == info.day && dateM == info.month && dateYe == info.year) && apiClient.timetableAvailable == false) {
            var storageDateString = Lang.format("$1$$2$$3$$4$$5$", [dateYe, "-", dateM, "-", dateD]);
            timetableData = Storage.getValue(storageDateString);
            if (timetableData != null) {
                timetableAvailable = true;
            }
        }
        if (timetableAvailable && lessonNumber < timetableData.size()) {
            lessonNumber++;
            updateLessonNumber = false;
        } else {
            nextDay();
        }
        WatchUi.requestUpdate();
    }

    public function previousLesson() as Void {
        if (lessonNumber > 0) {
            lessonNumber--;
            updateLessonNumber = false;
        } else {
            previousDay();
        }
        WatchUi.requestUpdate();
    }

    public function refresh() as Void {
        updateTimetable = true;
        lessonNumber = 0;
        updateLessonNumber = false;
        WatchUi.requestUpdate();
    }

    public function today() as Void {
        var info = Toybox.Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        timeH = info.hour;
        timeM = info.min;
        dateD = info.day;
        dateM = info.month;
        dateYe = info.year;

        updateTimetable = true;
        updateLessonNumber = true;
        WatchUi.requestUpdate();
    }

}