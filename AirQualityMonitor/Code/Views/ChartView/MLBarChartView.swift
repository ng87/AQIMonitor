//
//  MLBarChartView.swift
//  Meditation.LIVE
//
//  Copyright © 2020 Meditation.LIVE. All rights reserved.
//

import UIKit
import Charts

class MLBarChartView: UIView {
    
    @IBOutlet var chartView: BarChartView!
    var dataPoints: [ChartEntriesDataModel] = []
    let maxVisibleBars: Double = 6.5
    
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? MLBarChartView
    }
    
    func configureChart(using data: [ChartEntriesDataModel]){
        self.dataPoints = data
        
        // Configure chart
        chartView.clear()
        chartView.clearValues()
        chartView.leftAxis.removeAllLimitLines()
        
        chartView.legend.enabled = false
        chartView.chartDescription?.enabled = false
        chartView.rightAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
        chartView.doubleTapToZoomEnabled = true
        chartView.highlightPerTapEnabled = true
        chartView.highlightPerDragEnabled = false
        chartView.pinchZoomEnabled = true
        chartView.setScaleEnabled(true)
       
        chartView.backgroundColor = .clear
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = UIFont(name: "Avenir-Book", size: 10.0)!
        yAxis.labelCount = dataPoints.count
        yAxis.labelPosition = .outsideChart
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Avenir-Book", size: 10.0)!
        xAxis.labelCount = dataPoints.count
        xAxis.valueFormatter = self
        xAxis.granularityEnabled = true
        xAxis.labelRotationAngle = data.count < Int(maxVisibleBars) ? 0: 30
        
        // Creates data for chart
        var dataEntries: [BarChartDataEntry] = []
        for i in 0 ..< dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: dataPoints[i].yValue)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "AQI US")
        chartDataSet.colors = data.map({$0.color})
        let chartData = BarChartData(dataSets: [chartDataSet])
        chartData.setValueTextColor(.black)
        chartData.setValueFont(UIFont(name: "Avenir-Heavy", size: 10.0)!)
        chartView.data = chartData
        chartView.setVisibleXRangeMaximum(Double(maxVisibleBars))
        
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInCubic)
    }
}

extension MLBarChartView: IAxisValueFormatter{    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return self.dataPoints[Int(value)].xValue
    }
}
