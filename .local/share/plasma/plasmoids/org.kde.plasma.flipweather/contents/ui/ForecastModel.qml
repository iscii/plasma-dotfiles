import QtQuick 2.4

ListModel {
    id: forecastModel

    ListElement {
        timestamp: 0
        ids: 0
        description: ""
        temp_min: 0
        temp_max: 0
        temp_day: 0
        temp_night: 0
        temp_eve: 0
        temp_morn: 0
        feel_day: 0
        feel_night: 0
        feel_morn: 0
        feel_eve: 0
        icon: "na"
        sunrise: 0
        sunset: 0
        moonrise: 0
        moonset: 0
        moonphase: 0
        pressure: 0
        humidity: 0
        wind_speed: 0
        wind_deg: 0
        wind_gust: 0
        clouds: 0
        pop: 0
    }
}
