//
//  ViewController.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 20/11/21.
//

import UIKit

class CityWiseAQIViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let viewModel: AQIDataViewModel = AQIDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(tableView: self.tableView)
        self.setupViewModel()
    }
    
    func setupViewModel(){
        viewModel.refreshUI = {
            self.tableView.reloadData()
        }
        viewModel.showLoading = {
            self.activityIndicator.startAnimating()
        }
        viewModel.hideLoading = {
            self.activityIndicator.stopAnimating()
        }
        viewModel.getCityWiseData()
    }
}

extension CityWiseAQIViewController: UITableViewDelegate, UITableViewDataSource{
    internal func configure(tableView: UITableView) {
        tableView.registerReusableCell(CityAQIDataTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300.0
        tableView.contentInset.bottom = 30.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    //MARK:- Table View Delegate and Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CityAQIDataTableViewCell.dequeue(from: tableView, at: indexPath)
        if let data = self.viewModel.data(for: indexPath.row){
            cell.configureCell(model: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
    }
}


