//
//  CityAQIInfoViewController.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import UIKit

class CityAQIInfoViewController: UIViewController {
    static let identifier: String = "CityAQIInfoViewController"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var city: String = ""
    var viewModel: AQIDataViewModel?
    var aqiData: AQIDataModel?{
        return viewModel?.getLatestData(for: city)
    }
   
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(tableView: self.tableView)
        self.setupHeader()
    }
    
    func setupHeader(){
        self.cityLabel.text = ""
        self.dateLabel.text = ""
        guard let aqiData = aqiData else {
            return
        }
        self.cityLabel.text = "Air Quality: "+aqiData.city
        self.dateLabel.text = "As on: "+aqiData.formattedDate
    }
    
    @objc func refresh(_ sender: Any) {
        self.setupHeader()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func dismissTapped(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshTapped(_ sender: Any){
        self.refresh(sender)
    }
}

//MARK:- Table View Delegate and Data Source Methods
extension CityAQIInfoViewController: UITableViewDelegate, UITableViewDataSource{
    internal func configure(tableView: UITableView) {
        tableView.addSubview(self.refreshControl)
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
            if let data = self.aqiData{
                cell.configureCell(model: data)
            }
            return cell
        }
        
        let cell = AQITrackingTableViewCell.dequeue(from: tableView, at: indexPath)
        cell.configureCell(city: city, data: viewModel?.getData(for: city) ?? [])
        return cell
    }
    
}
