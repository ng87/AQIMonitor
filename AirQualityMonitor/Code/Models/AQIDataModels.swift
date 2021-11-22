//
//  Model.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 22/11/21.
//

import Foundation
import UIKit

// MARK: ENUM for Air Quality Categorisation
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
    
    var textColor: UIColor?{
        switch self {
        case .good, .poor, .veryPoor, .severe:
            return .white
        case .satisfactory:
            return UIColor(named: "SatisfactoryText")
        case .moderate:
            return UIColor(named: "ModerateText")
        }
    }
    
    var description: String{
        return self.rawValue
    }
    
    var detailedDescription: String{
        switch self {
        case .good:
            return "good"
        case .satisfactory:
            return "satisfactory"
        case .moderate:
            return "moderate"
        case .poor:
            return "unhealthy for sensitive groups"
        case .veryPoor:
            return "very unhealthy"
        case .severe:
            return "hazardous"
        }
    }
    
    var pointers: [String]{
        switch self {
        case .good :
            return ["• Take the kids out to play",
                    "• Enjoy outdoor activities",
                    "• Open the window and let in fresh air",
                    "• Keep an eye on air quality changes"]
        case .satisfactory, .moderate:
            return ["• Good for mild exercises",
            "• Walk your dog in the neighborhood",
            "• Keep an eye on air quality changes"]
        case .poor:
            return ["• Reduce outdoor activities",
            "• Keep your window closed",
            "• Wear a mask if you’re sensitive to air pollution",
            "• Turn on your purifier"]
        case .veryPoor, .severe:
            return ["• Stay inside and avoid going out",
            "• Keep your window closed",
            "• Wear a mask outside",
            "• Turn on your purifier",
            "• Talk to a doctor if you feel sick"]
        }
    }
}

// MARK: AQI Data Model
struct AQIDataModel: Codable, Hashable{
    // API data
    let city: String
    let aqi: Double
    // Computed data
    let timeStamp: Date
    var cityDescription: String{
        return "Air quality in \(city) is currently"
    }
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
    var formattedDate: String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: timeStamp)
    }
    var formattedTime: String{
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: timeStamp)
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

// MARK: Data model for chart entries
class ChartEntriesDataModel{
    let xValue: String
    let yValue: Double
    let text: String
    let color: UIColor
    
   init(with data: AQIDataModel) {
       self.xValue = data.formattedTime
       self.yValue = data.aqi
       self.text = data.formattedAQI
       self.color = data.category.color!
        
    }
    
    class func arrayOfModels(_ data:[AQIDataModel]) -> [ChartEntriesDataModel]{
        return data.map({ChartEntriesDataModel(with: $0)})
    }
    
}


