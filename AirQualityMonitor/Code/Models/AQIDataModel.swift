//
//  Model.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import Foundation
import UIKit

enum AQICategory: String{
    case good = "Good"
    case satisfactory = "Satisfactory"
    case moderate = "Moderate"
    case poor = "Poor"
    case veryPoor = "Very Poor"
    case severe = "Severe"
    
    var color: UIColor?{
        return UIColor(named: self.rawValue.replacingOccurrences(of: " ", with: ""))
    }
    
    var description: String{
        return self.rawValue
    }
}

struct AQIDataModel: Codable, Hashable{
    let city: String
    let aqi: Double
    let timeStamp: Date
    var formattedAQI: String{
        return String(format: "%d", Int(self.aqi))
    }
    var formattedTimeStamp: String{
        let elapsed = Int(Date().timeIntervalSince(timeStamp))
        guard elapsed > 0 else{
            return "updated just now"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return "last updated: "+formatter.localizedString(for: timeStamp, relativeTo: Date())
    }
    var category: AQICategory{
        let aqi = Int(self.aqi)
        switch aqi {
        case 0 ... 50:
            return .good
        case 51 ... 100:
            return .satisfactory
        case 101 ... 200:
            return .moderate
        case 201 ... 300:
            return .poor
        case 301 ... 400:
            return .veryPoor
        default:
            return.severe
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case city, aqi, timeStamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(String.self, forKey: .city)
        aqi = try container.decode(Double.self, forKey: .aqi)
        timeStamp = Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(city, forKey: .city)
        try container.encode(aqi, forKey: .aqi)
        try container.encode(timeStamp, forKey: .timeStamp)
    }
}


