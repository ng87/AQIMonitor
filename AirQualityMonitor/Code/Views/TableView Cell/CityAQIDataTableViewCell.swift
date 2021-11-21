//
//  CityAQIDataTableViewCell.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import UIKit

class CityAQIDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var aqiDescriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.addViewShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    internal static func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> CityAQIDataTableViewCell {
        guard let cell: CityAQIDataTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue HomeMessagesTableViewCell ***")
        }
        cell.tag = indexPath.row
        return cell
    }
    
    func configureCell(model: AQIDataModel){
        self.cityLabel.text = model.city
        self.aqiLabel.text = model.formattedAQI
        self.aqiDescriptionLabel.text = model.category.description
        self.aqiLabel.backgroundColor = model.category.color
        self.lastUpdatedLabel.text = model.formattedTimeStamp
        
    }
    
}
