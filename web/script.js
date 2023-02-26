
const getEl = function( id ) { return document.getElementById( id )}
let DynoChart = {}

const rpmchart = {
    [10000] : 9,
    [9000] : 8,
    [8000] : 7,
    [7000] : 6,
    [6000] : 5,
    [5000] : 4,
    [4000] : 3,
    [3000] : 2,
    [2000] : 1,
    [1000] : 0,
}

function GetIndexFromRpm(rpm) {
    var indexrpm = 0
    for (const i in rpmchart) {
        if (rpm >= i) {
            indexrpm = rpmchart[i]
        }
    }
    return indexrpm
}

const BG_COLOR = '#394b52';

const TEXT_COLOR = '#e7eaeb';

const LINE_COLORS = [
  '#52BE80',
  'red',
  '#459bca',
  '#d64561',
  '#d64561'
];

const GRID_COLOR = 'green';

let recorded = false
let chartrecord = {}
window.addEventListener('message', function (message) {
    let event = message.data;
    if (event.dyno) {
        getEl('dyno').style.display = 'block'
        getEl('dynochart').style.display = 'block'
        getEl('gauges').style.display = 'block'
    } else if (event.dyno == false) {
        getEl('dyno').style.display = 'none'
        getEl('dynochart').style.display = 'none'
        getEl('gauges').style.display = 'none'
    }

    if (event.stat) {
        getEl('gear').innerHTML = event.stat.gear
        document.getElementById("rpm").style.setProperty('--num', event.stat.rpm);
        getEl('speed').innerHTML = event.stat.speed
        getEl('hp').innerHTML = event.stat.hp
        //getEl('rpm').innerHTML = event.stat.rpm
        getEl('oiltemp2').innerHTML = Math.floor(event.stat.gauges.oiltemp * 150)
        getEl('oilpressure2').innerHTML = Math.floor(event.stat.gauges.oilpressure*0.75 * 100)
        getEl('watertemp2').innerHTML = event.stat.gauges.watertemp
        getEl('oiltemp').style.setProperty('--percent', (event.stat.gauges.oiltemp / 1) * 100)
        getEl('oilpressure').style.setProperty('--percent', (event.stat.gauges.oilpressure / 1) * 100)
        getEl('watertemp').style.setProperty('--percent', (event.stat.gauges.watertemp / 150) * 100)
        getEl('map').style.setProperty('--percent', (event.stat.gauges.map / 5) * 100)
        getEl('efficiency').style.setProperty('--percent', (event.stat.gauges.efficiency))
        getEl('afr').style.setProperty('--percent', (event.stat.gauges.afr / 19) * 100)
        getEl('afr2').innerHTML = Math.round(event.stat.gauges.afr * 100) / 100
        getEl('efficiency2').innerHTML = Math.floor(event.stat.gauges.efficiency)
        getEl('map2').innerHTML = event.stat.gauges.map
        var rpm = GetIndexFromRpm(event.stat.rpm+1)
        //console.log(rpm)
        DynoChart.data.datasets[0].data[rpm] = event.stat.hp;
        DynoChart.data.datasets[1].data[rpm] = event.stat.torque;
        DynoChart.data.datasets[2].data[rpm] = event.stat.speed;
        if (!recorded) {
            DynoChart.update();
        } else if (recorded && event.stat.gear <= 2) {
            recorded = false
        }
        if (event.stat.gear == event.stat.maxgear && !recorded & event.stat.rpm > 9999) {
            chartrecord = DynoChart.data.datasets
            recorded = true
        }
    }
 
})

DynoChart = new Chart(document.getElementById("line-chart"), {
    type: "line",
    data: {
      labels: [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000],
      datasets: [
      {
        data: [],
        label: "Horsepower",
        borderColor: LINE_COLORS[0],
        backgroundColor: LINE_COLORS[0],
        pointRadius : 0,
        cubicInterpolationMode: 'monotone',
        fill: false },
  
      {
        data: [],
        label: "Torque",
        borderColor: LINE_COLORS[1],
        backgroundColor: LINE_COLORS[1],
        pointRadius : 0,
        cubicInterpolationMode: 'monotone',
        fill: false },
  
      {
        data: [],
        label: "Speed",
        borderColor: LINE_COLORS[2],
        backgroundColor: LINE_COLORS[2],
        pointRadius : 0,
        cubicInterpolationMode: 'monotone',
        fill: false }] },
  
  
  
    options: {
      layout: {
        padding: {
          left: 20,
          right: 20,
          top: 5,
          bottom: 5 } },
  
  
      title: {
        display: true,
        text: "Dyno Chart",
        position: "top",
        fontSize: 25,
        fontFamily: "Dosis",
        fontColor: "white",
        fontStyle: "bold",
        padding: 10,
        lineHeight: 1.2 },
  
      label: {},
      legend: {
        display: true,
        position: "bottom",
        labels: {
          boxWidth: 50,
          fontSize: 13,
          fontColor: TEXT_COLOR,
          fontStyle: "normal",
          fontFamily: "Dosis",
          padding: 5 } },
  
  
      tooltips: {
        mode: "point",
        backgroundColor: "rgba(0, 98, 90, 1)",
        yPadding: 10,
        xPadding: 50,
        titleAlign: "center",
        bodyAlign: "center",
        displayColors: false },
  
      scales: {
        ticks: {
            fontColor: TEXT_COLOR
          },
          gridLines: {
            color: GRID_COLOR
          },
        xAxes: [
        {
          ticks: {
            // Include a dollar sign in the ticks
            callback: function (value, index, values) {
              return value;
            },
            fontSize: 13 },
            gridLines: {
                color: 'rgba(96,96,96,55)'
            } }],
  
  
  
        yAxes: [{
            ticks: {
                // Include a dollar sign in the ticks
                callback: function (value, index, values) {
                return value
                },
                fontSize: 13 
            },
            gridLines: {
                color: 'rgba(96,96,96,55)'
            }
        }] 
} } })