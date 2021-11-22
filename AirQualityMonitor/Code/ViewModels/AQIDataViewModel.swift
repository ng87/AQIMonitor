//
//  File.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import Foundation

class AQIDataViewModel: NSObject{
    typealias VoidCompletionHandler = (() -> Void)
    typealias ErrorCompletionHandler = ((Error) -> Void)
    private var service: DataService!
    private var cityWiseMap: [String: [AQIDataModel]]  = [:]{
        didSet{
            self.refreshUI?()
        }
    }
    private var allCities: [String]{
        return self.cityWiseMap.keys.sorted(by: {$0 < $1})
    }
    var dataCount: Int{
        return self.cityWiseMap.keys.count
    }
    // View Bindings
    var refreshUI: VoidCompletionHandler?
    var showError: ErrorCompletionHandler?
    var showLoading: VoidCompletionHandler?
    var hideLoading: VoidCompletionHandler?
    
    // Initialises View Model
    override init() {
        super.init()
        self.service =  DataService()
        self.subscribeForCityWiseData()
    }
    
    // subsribes to get data from WS
    func subscribeForCityWiseData(){
        self.showLoading?()
        self.service.initialise {[weak self] aqiData, error in
            self?.createCityWiseMap(from: aqiData)
            self?.hideLoading?()
        }
    }
    
    // handles error from WS connection
    func handleError(_ error: Error?) {
        guard let error = error else {
            return
        }
        self.showError?(error)
        Console.log("websocket encountered an error: \(error.localizedDescription)")
    }
    
    // handles reconnection to WS
    func reconnect(){
        self.service.reconnect()
    }
    
    // Creates city wise map of data from aqi array
    func createCityWiseMap(from aqiData: [AQIDataModel]){
        guard !aqiData.isEmpty else{
            return
        }
        
        let dataMap = aqiData.reduce(into:  [String: [AQIDataModel]]()) {
            $0[$1.city] = [$1]
        }
        
        guard !self.cityWiseMap.isEmpty else{
            self.cityWiseMap = dataMap
            return
        }
        
        for (city, data) in dataMap{
            if let oldData = self.cityWiseMap[city]{
                let mergedData:Array<AQIDataModel> = Array(Utility.combine(oldData, data)).sorted(by: {$0.timeStamp > $1.timeStamp})
                self.cityWiseMap[city] = mergedData
            }
            else{
                self.cityWiseMap[city] = data
            }
        }
    }
    
    func city(for index: Int)-> String{
        return self.allCities[index]
    }
    
    // Returns AQI data array for a given city
    func getData(for city: String) -> [AQIDataModel]{
        guard let data = self.cityWiseMap[city] else{
            return []
        }
        return data
    }
    
    // Returns latest AQI data for a given city
    func getLatestData(for city: String) -> AQIDataModel?{
        let data = self.getData(for: city)
        guard !data.isEmpty else{
            return nil
        }
        return data.first
    }

}
