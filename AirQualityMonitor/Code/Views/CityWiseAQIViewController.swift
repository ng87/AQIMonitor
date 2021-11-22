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
    private var viewModel: AQIDataViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(tableView: self.tableView)
        self.setupViewModel()
    }
    
    func setupViewModel(){
        self.viewModel = AQIDataViewModel()
        self.viewModel.refreshUI = {
            self.tableView.reloadData()
        }
        self.viewModel.showLoading = {
            self.activityIndicator.startAnimating()
        }
        self.viewModel.hideLoading = {
            self.activityIndicator.stopAnimating()
        }
    }
}

//MARK:- Table View Delegate and Data Source Methods
extension CityWiseAQIViewController: UITableViewDelegate, UITableViewDataSource{
    internal func configure(tableView: UITableView) {
        tableView.registerReusableCell(CityAQIDataTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300.0
        tableView.contentInset.bottom = 60.0
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CityAQIDataTableViewCell.dequeue(from: tableView, at: indexPath)
        let city = self.viewModel.city(for: indexPath.row)
        if let data = self.viewModel.getLatestData(for: city){
            cell.configureCell(model: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: CityAQIInfoViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CityAQIInfoViewController") as! CityAQIInfoViewController
        vc.viewModel = self.viewModel
        vc.city = self.viewModel.city(for: indexPath.row)
        self.present(vc, animated: true, completion: nil)
    }
}


