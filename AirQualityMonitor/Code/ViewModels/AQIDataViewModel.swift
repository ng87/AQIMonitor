//
//  File.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import Foundation

typealias VoidCompletionHandler = (() -> Void)

class AQIDataViewModel: NSObject{
    
    private var  service: DataService!
    var cityWiseMap: [String: [AQIDataModel]]  = [:]
    var allCities: [String]{
        return self.cityWiseMap.keys.sorted(by: {$0 < $1})
    }
    var dataCount: Int{
        return self.cityWiseMap.keys.count
    }
    var refreshUI: VoidCompletionHandler?
    var showError: VoidCompletionHandler?
    var showLoading: VoidCompletionHandler?
    var hideLoading: VoidCompletionHandler?
    
    override init() {
        super.init()
        self.service =  DataService()
        self.getCityWiseData()
    }
    
    func getCityWiseData(){
        self.showLoading?()
        self.service.initialise {[weak self] aqiData, error in
            self?.createCityWiseMap(from: aqiData)
            self?.hideLoading?()
        }
    }
    
    func handleError(_ error: Error?) {
        guard let error = error else {
            return
        }
        Console.log("websocket encountered an error: \(error.localizedDescription)")
    }
    
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
        
        self.refreshUI?()
    }
    
    func city(for index: Int)-> String{
        return self.allCities[index]
    }
    
    func getData(for city: String) -> [AQIDataModel]{
        guard let data = self.cityWiseMap[city] else{
            return []
        }
        return data
    }
    
    func getLatestData(for city: String) -> AQIDataModel?{
        let data = self.getData(for: city)
        guard !data.isEmpty else{
            return nil
        }
        return data.first
    }
    
//    func data(for index: Int)-> AQIDataModel?{
//        let city = self.city(for: index)
//        return self .getLatestData(for: city)
//    }
    
    
}
