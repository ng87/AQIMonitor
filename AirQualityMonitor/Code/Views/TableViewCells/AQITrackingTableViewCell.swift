//
//  AQITrackingTableViewCell.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import UIKit

class AQITrackingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var containerView: UIView?
    var data:[AQIDataModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView?.addViewShadow()
       
        self.configureGraph()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    internal static func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> AQITrackingTableViewCell {
        guard let cell: AQITrackingTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue AQITrackingTableViewCell ***")
        }
        cell.tag = indexPath.row
        return cell
    }
    
    func configureCell(city: String, data: [AQIDataModel]){
        self.data = data.reversed()
        self.titleLabel.text = "Air Quality Data for \(city)"
        graphView.subviews.forEach({$0.removeFromSuperview()})
        if let chartView:MLBarChartView = MLBarChartView.loadFromNibNamed(nibNamed: "MLBarChartView") as? MLBarChartView{
            graphView.backgroundColor = .clear
            chartView.configureChart(using: ChartEntriesDataModel.arrayOfModels(self.data))
            chartView.frame = graphView.bounds
            chartView.backgroundColor = .clear
            chartView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
            graphView.addSubview(chartView)
        }
    }
    
    func configureGraph(){
        

    }
    
}
