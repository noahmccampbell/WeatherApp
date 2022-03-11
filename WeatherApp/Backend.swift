//
//  Backend.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 3/3/22.
//

import Foundation
import CoreLocation
import SwiftUI


var locationManager:CLLocationManager?

class locationManagerC : NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var auth : CLAuthorizationStatus
    @Published var lat = 0.0
    @Published var lon = 0.0
    
    private let locationManager:CLLocationManager
    
    override init(){
        locationManager = CLLocationManager()
        auth = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    func askForPerms(){
        locationManager.requestWhenInUseAuthorization()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        auth = locationManager.authorizationStatus
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locations = locations.last {
            lat = locations.coordinate.latitude
            lon = locations.coordinate.longitude
        }
    }
    
}
var weatherDictionary: NSDictionary?
var todayDict: NSDictionary?
struct TodayData {
    var temp:String
    var forecast:String
    var shortforecast:String
    var weatherIconURL:String
}
var tDat = TodayData.init(temp: "Undefined", forecast: "Undefined", shortforecast: "Undefined", weatherIconURL: "Undefined")
func getWeatherData(urls: String, completion: @escaping (_ json: Any?, _ error: Error?)->()) {
    let session = URLSession.shared
    let WeatherURL = URL(string: urls)
    let sessionData = session.dataTask(with: WeatherURL!){
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error{
            print("Something went wrong in the HTTP Request: \(error)")
            completion(nil, error)
        }
        do{
            if let data = data {
                let dataSring = String(data: data, encoding: String.Encoding.utf8)
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary{
                    print(jsonObj)
                    completion(jsonObj, error)
                }
            }
        } catch {
            print("JSON PARSING ERROR: \(error)")
        }
    }
    sessionData.resume()
}
func setUpMain() {
        getWeatherData(urls: "https://api.weather.gov/points/39.899226,-77.680552"){ json, error in
            if let error = error {
                print(error)
            }
            else if let json = json{
                print(json)
                weatherDictionary = (json as! NSDictionary)["properties"] as? NSDictionary
                setUpToday()
            }
        }
}
func setUpToday() {
        getWeatherData(urls: weatherDictionary?["forecast"] as! String){ json, error in
            if let error = error {
                print(error)
            }
            else if let jsonF = json{
                weatherDictionary = (jsonF as! NSDictionary)["properties"] as! NSDictionary
                if let periods = weatherDictionary?["periods"] {
                    todayDict = (periods as! NSArray)[0] as? NSDictionary
                    tDat.temp = String(todayDict?["temperature"] as! Int)
                    tDat.shortforecast = todayDict?["shortForecast"] as! String
                    tDat.forecast = todayDict?["detailedForecast"] as! String
                    tDat.weatherIconURL = todayDict?["icon"] as! String
                    print(String(todayDict?["temperature"] as! Int))
                    
                } else{
                    print("Cannot convert to NSArray?")
                }
            }
        }
}





