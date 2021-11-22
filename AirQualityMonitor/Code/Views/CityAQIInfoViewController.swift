//
//  CityAQIInfoViewController.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import UIKit

class CityAQIInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel: AQIDataViewModel?
    var city: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(tableView: self.tableView)
    }
}

//MARK:- Table View Delegate and Data Source Methods
extension CityAQIInfoViewController: UITableViewDelegate, UITableViewDataSource{
    internal func configure(tableView: UITableView) {
        tableView.registerReusableCell(AQIInfoTableViewCell.self)
        tableView.registerReusableCell(AQITrackingTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300.0
        tableView.contentInset.bottom = 60.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = AQIInfoTableViewCell.dequeueCell(from: tableView, at: indexPath)
            if let data = viewModel?.getLatestData(for: city){
                cell.configureCell(model: data)
            }
            return cell
        }
        
        let cell = AQITrackingTableViewCell.dequeue(from: tableView, at: indexPath)
        cell.configureCell(city: city, data: viewModel?.getData(for: city) ?? [])
        return cell
    }
    
}
