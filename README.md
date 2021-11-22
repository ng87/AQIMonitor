# AQIMonitor

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

## Prerequisites
Xcode 13.1 or later

## Requirements ##

### Build
iOS 14.0 SDK or later

### Runtime
iOS 14.0 or later

## Follow these steps to run the project
1. Clone the project using following command on terminal

    `git clone https://github.com/ng87/AQIMonitor.git`

2. Execute these commands for code setup

    a. `sudo gem install cocoapods`
    
    b. `pod setup --verbose`
    
    c. `pod install`
    
3. Open `AirQualityMonitor.xcworkspace` file in XCODE and run the app.

## App Architecture
MVVM is used in the project. 

1. Service: DataService
2. Models: AQIDataModel, ChartEntriesDataModel
3. ViewModel: AQIDataViewModel
4. Views: CityAQIDataTableViewCell, AQIInfoTableViewCell, AQITrackingTableViewCell, MLBarChartView
5. ViewControllers: CityWiseAQIViewController, CityAQIInfoViewController

## Third Party Libraries used
1. Starscream:  https://github.com/daltoniam/Starscream
2. Charts: https://github.com/danielgindi/Charts

## App Screen Shots
![Launch](https://user-images.githubusercontent.com/94808806/142928042-9abddad4-6906-4d58-ad71-d0d5ed461ecc.png)
![CityWiseListing](https://user-images.githubusercontent.com/94808806/142928035-17d7e7e6-6b4f-4651-b9f9-6db7e473ffe6.png)
![CityAQIData](https://user-images.githubusercontent.com/94808806/142928030-7a5df0be-e95a-48ef-bcac-f22f5c039d9e.png)

