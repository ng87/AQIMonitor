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
    
    // Initialises View model and set up bindings
    func setupViewModel(){
        self.viewModel = AQIDataViewModel()
        self.viewModel.refreshUI = { [weak self] in
            self?.tableView.reloadData()
        }
        self.viewModel.showLoading = { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        self.viewModel.hideLoading = { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
        self.viewModel.showError = { [weak self] error in
            self?.handle(error)
        }
    }
    
    func handle(_ error: Error) {
        let alert = UIAlertController(
            title: "An error occured",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .default ))
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: .default,
                                      handler: { [weak self]  _ in
            self?.viewModel.reconnect()
        }))
        self.present(alert, animated: true)
    }
    
    // Navigates to AQI Info for a city
    func handleNavigation(for index: Int){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: CityAQIInfoViewController.identifier) as? CityAQIInfoViewController else{
            return
        }
        vc.viewModel = self.viewModel
        vc.city = self.viewModel.city(for: index)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
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
        self.handleNavigation(for: indexPath.row)
    }
}


