//
//  AQIInfoTableViewCell.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import UIKit

class AQIInfoTableViewCell: CityAQIDataTableViewCell {
    @IBOutlet var pointerLabels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    internal static func dequeueCell(from tableView: UITableView, at indexPath: IndexPath) -> AQIInfoTableViewCell {
        guard let cell: AQIInfoTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue AQIInfoTableViewCell ***")
        }
        cell.tag = indexPath.row
        return cell
    }
    
    override func configureCell(model: AQIDataModel){
        super.configureCell(model: model)
        self.containerView?.backgroundColor = model.category.color
        self.cityLabel?.text = model.cityDescription
        self.aqiLabel?.backgroundColor = .white
        self.aqiDescriptionLabel?.text = model.category.detailedDescription
        self.aqiDescriptionLabel?.textColor = model.category.textColor
        self.cityLabel?.textColor = model.category.textColor
        self.aqiContainerView?.backgroundColor = .white
        self.pointerLabels.forEach({$0.isHidden = true})
        for i in 0 ..< model.category.pointers.count{
            let pointer =  model.category.pointers[i]
            self.pointerLabels[i].text = pointer
            self.pointerLabels[i].textColor = model.category.textColor
            self.pointerLabels[i].isHidden = false
        }
    }
    
}
