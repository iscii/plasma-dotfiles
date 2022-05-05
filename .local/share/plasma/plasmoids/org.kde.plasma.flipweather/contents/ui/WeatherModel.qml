import QtQuick 2.4

ListModel {
    id: weatherModel

    ListElement {
        ids: 200
        group: "2xx"
        name: "Thunderstorm"
        description: "thunderstorm with light rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 160
        dropQuantity: 8
        thunder: true
        thunderPower: 2
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 201
        group: "2xx"
        name: "Thunderstorm"
        description: "thunderstorm with rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 200
        dropQuantity: 18
        thunder: true
        thunderPower: 2
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 202
        group: "2xx"
        name: "Thunderstorm"
        description: "thunderstorm with heavy rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 240
        dropQuantity: 36
        thunder: true
        thunderPower: 2
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 210
        group: "2xx"
        name: "Thunderstorm"
        description: "light thunderstorm"
        drops: false
        thunder: true
        thunderPower: 1
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 211
        group: "2xx"
        name: "Thunderstorm"
        description: "thunderstorm"
        drops: false
        thunder: true
        thunderPower: 2
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 212
        group: "2xx"
        name: "Thunderstorm"
        description: " heavy thunderstorm"
        drops: false
        thunder: true
        thunderPower: 3
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 221
        group: "2xx"
        name: "Thunderstorm"
        description: " ragged thunderstorm"
        drops: false
        thunder: true
        thunderPower: 4
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 230
        group: "2xx"
        name: "Thunderstorm"
        description: "thunderstorm with light drizzle"
        drops: true
        sourcePathToDrop: "drizzle"
        dropNumbers: 3
        dropSpeed: 200
        dropQuantity: 16
        thunder: true
        thunderPower: 2
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 231
        group: "2xx"
        name: "Thunderstorm"
        description: "thunderstorm with drizzle"
        drops: true
        sourcePathToDrop: "drizzle"
        dropNumbers: 3
        dropSpeed: 240
        dropQuantity: 24
        thunder: true
        thunderPower: 2
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 232
        group: "2xx"
        name: "Thunderstorm"
        description: "thunderstorm with heavy drizzle"
        drops: true
        sourcePathToDrop: "drizzle"
        dropNumbers: 3
        dropSpeed: 280
        dropQuantity: 48
        thunder: true
        thunderPower: 2
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 300
        group: "3xx"
        name: "Drizzle"
        description: "light intensity drizzle"
        drops: true
        sourcePathToDrop: "drizzle"
        dropNumbers: 3
        dropSpeed: 200
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 301
        group: "3xx"
        name: "Drizzle"
        description: "drizzle"
        drops: true
        sourcePathToDrop: "drizzle"
        dropNumbers: 3
        dropSpeed: 240
        dropQuantity: 24
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 302
        group: "3xx"
        name: "Drizzle"
        description: "heavy intensity drizzle"
        drops: true
        sourcePathToDrop: "drizzle"
        dropNumbers: 3
        dropSpeed: 280
        dropQuantity: 48
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 310
        group: "3xx"
        name: "Drizzle"
        description: "light intensity drizzle rain"
        drops: true
        sourcePathToDrop: "drizzlerain"
        dropNumbers: 6
        dropSpeed: 200
        dropQuantity: 8
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 311
        group: "3xx"
        name: "Drizzle"
        description: "drizzle rain"
        drops: true
        sourcePathToDrop: "drizzlerain"
        dropNumbers: 6
        dropSpeed: 240
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 312
        group: "3xx"
        name: "Drizzle"
        description: "heavy intensity drizzle rain"
        drops: true
        sourcePathToDrop: "drizzlerain"
        dropNumbers: 6
        dropSpeed: 280
        dropQuantity: 32
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 313
        group: "3xx"
        name: "Drizzle"
        description: "shower rain and drizzle"
        drops: true
        sourcePathToDrop: "drizzlerain"
        dropNumbers: 6
        dropSpeed: 320
        dropQuantity: 48
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 314
        group: "3xx"
        name: "Drizzle"
        description: "heavy shower rain and drizzle"
        drops: true
        sourcePathToDrop: "drizzlerain"
        dropNumbers: 6
        dropSpeed: 320
        dropQuantity: 64
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 321
        group: "3xx"
        name: "Drizzle"
        description: "shower drizzle"
        drops: true
        sourcePathToDrop: "drizzle"
        dropNumbers: 3
        dropSpeed: 320
        dropQuantity: 72
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 500
        group: "5xx"
        name: "Rain"
        description: "light rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 200
        dropQuantity: 4
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 501
        group: "5xx"
        name: "Rain"
        description: "moderate rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 240
        dropQuantity: 8
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 502
        group: "5xx"
        name: "Rain"
        description: "heavy intensity rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 260
        dropQuantity: 12
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 503
        group: "5xx"
        name: "Rain"
        description: "very heavy rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 280
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 504
        group: "5xx"
        name: "Rain"
        description: "extreme rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 360
        dropQuantity: 36
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 511
        group: "5xx"
        name: "Rain"
        description: "freezing rain"
        drops: true
        sourcePathToDrop: "sleet"
        dropNumbers: 6
        dropSpeed: 200
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 520
        group: "5xx"
        name: "Rain"
        description: "light intensity shower rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 320
        dropQuantity: 8
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 521
        group: "5xx"
        name: "Rain"
        description: "shower rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 320
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 522
        group: "5xx"
        name: "Rain"
        description: "heavy intensity shower rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 320
        dropQuantity: 24
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 531
        group: "5xx"
        name: "Rain"
        description: "ragged shower rain"
        drops: true
        sourcePathToDrop: "rain"
        dropNumbers: 3
        dropSpeed: 360
        dropQuantity: 32
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 600
        group: "6xx"
        name: "Snow"
        description: "light snow"
        drops: true
        sourcePathToDrop: "snow"
        dropNumbers: 3
        dropSpeed: 80
        dropQuantity: 4
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 601
        group: "6xx"
        name: "Snow"
        description: "snow"
        drops: true
        sourcePathToDrop: "snow"
        dropNumbers: 3
        dropSpeed: 80
        dropQuantity: 8
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 602
        group: "6xx"
        name: "Snow"
        description: "heavy snow"
        drops: true
        sourcePathToDrop: "snow"
        dropNumbers: 3
        dropSpeed: 120
        dropQuantity: 12
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 611
        group: "6xx"
        name: "Snow"
        description: "sleet"
        drops: true
        sourcePathToDrop: "sleet"
        dropNumbers: 6
        dropSpeed: 120
        dropQuantity: 12
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 612
        group: "6xx"
        name: "Snow"
        description: "light shower sleet"
        drops: true
        sourcePathToDrop: "sleet"
        dropNumbers: 6
        dropSpeed: 320
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 613
        group: "6xx"
        name: "Snow"
        description: "shower sleet"
        drops: true
        sourcePathToDrop: "sleet"
        dropNumbers: 6
        dropSpeed: 320
        dropQuantity: 24
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 615
        group: "6xx"
        name: "Snow"
        description: "light rain and snow"
        drops: true
        sourcePathToDrop: "sleet"
        dropNumbers: 6
        dropSpeed: 120
        dropQuantity: 8
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 616
        group: "6xx"
        name: "Snow"
        description: "rain and snow"
        drops: true
        sourcePathToDrop: "sleet"
        dropNumbers: 6
        dropSpeed: 120
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 620
        group: "6xx"
        name: "Snow"
        description: "light shower snow"
        drops: true
        sourcePathToDrop: "snow"
        dropNumbers: 3
        dropSpeed: 240
        dropQuantity: 8
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 620
        group: "6xx"
        name: "Snow"
        description: "shower snow"
        drops: true
        sourcePathToDrop: "snow"
        dropNumbers: 3
        dropSpeed: 240
        dropQuantity: 16
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 621
        group: "6xx"
        name: "Snow"
        description: "heavy shower snow"
        drops: true
        sourcePathToDrop: "snow"
        dropNumbers: 3
        dropSpeed: 240
        dropQuantity: 24
        thunder: false
        clear: false
        clouds: false
        fog: false
    }
    ListElement {
        ids: 701
        group: "7xx"
        name: "Atmosphere"
        description: "mist"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 711
        group: "7xx"
        name: "Atmosphere"
        description: "smoke"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 721
        group: "7xx"
        name: "Atmosphere"
        description: "haze"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 731
        group: "7xx"
        name: "Atmosphere"
        description: "sand/dust whirls"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 741
        group: "7xx"
        name: "Atmosphere"
        description: "fog"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 751
        group: "7xx"
        name: "Atmosphere"
        description: "sand"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 761
        group: "7xx"
        name: "Atmosphere"
        description: "dust"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 762
        group: "7xx"
        name: "Atmosphere"
        description: "ash"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 771
        group: "7xx"
        name: "Atmosphere"
        description: "squalls"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 781
        group: "7xx"
        name: "Atmosphere"
        description: "tornado"
        atmosphere: true
        drops: false
        thunder: false
        clear: false
        clouds: false
        fog: true
    }
    ListElement {
        ids: 800
        group: "800"
        name: "Clear"
        description: "clear sky"
        atmosphere: false
        drops: false
        thunder: false
        clear: true
        clouds: false
        fog: false
    }
    ListElement {
        ids: 801
        group: "8xx"
        name: "Clouds"
        description: "few clouds: 11-25%"
        atmosphere: false
        drops: false
        thunder: false
        clear: false
        clouds: true
        cloudsPower: 1
        fog: false
    }
    ListElement {
        ids: 802
        group: "8xx"
        name: "Clouds"
        description: "scattered clouds: 25-50%"
        atmosphere: false
        drops: false
        thunder: false
        clear: false
        clouds: true
        cloudsPower: 2
        fog: false
    }
    ListElement {
        ids: 803
        group: "8xx"
        name: "Clouds"
        description: "broken clouds: 51-84%"
        atmosphere: false
        drops: false
        thunder: false
        clear: false
        clouds: true
        cloudsPower: 3
        fog: false
    }
    ListElement {
        ids: 804
        group: "8xx"
        name: "Clouds"
        description: "overcast clouds: 85-100%"
        atmosphere: false
        drops: false
        thunder: false
        clear: false
        clouds: true
        cloudsPower: 4
        fog: false
    }
}
