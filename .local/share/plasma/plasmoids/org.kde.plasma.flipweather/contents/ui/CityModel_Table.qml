import QtQuick 2.4
import Qt.labs.qmlmodels 1.0

TableModel {
    id: sityModel_Table
    TableModelColumn {
        display: "name"
    }
    TableModelColumn {
        display: "country"
    }
    TableModelColumn {
        display: "lat"
    }
    TableModelColumn {
        display: "lon"
    }
    TableModelColumn {
        display: "state"
    }
    rows: [{
            "name": "",
            "country": "",
            "state": "",
            "lat": 0,
            "lon": 0
        }]
}
