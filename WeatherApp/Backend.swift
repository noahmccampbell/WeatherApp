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
    //Ask for permission to use location
    func askForPerms(){
        locationManager.requestWhenInUseAuthorization()
    }
    //set authentication status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        auth = locationManager.authorizationStatus
    }
    //Set latitude and longitude through grabbed locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locations = locations.last {
            lat = locations.coordinate.latitude
            lon = locations.coordinate.longitude
        }
    }
    
}

/*
var weatherDictionary: NSDictionary?
var todayDict: NSDictionary?
*/

//Todays WeatherData
struct TodayData {
    var temp:String
    var forecast:String
    var shortforecast:String
    var weatherIconURL:String
}
//Initializers for all Weather Data Structures

//GET Wrapper Start JSON file.
/*
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
 */

class WeatherModel: NSObject, ObservableObject{
    @Published var weatherDictionary: NSDictionary?
    @Published var todayDict: NSDictionary?
    @Published var tDat = TodayData.init(temp: "Undefined", forecast: "Undefined", shortforecast: "Undefined", weatherIconURL: "Undefined")
    
    func GrabDataMain(urls:String) async throws -> NSDictionary{
        let session = URLSession.shared
        let jsonDecoder = JSONDecoder()
        let url = URL(string: urls)!
        let (data, _) = try await session.data(from: url)
        return try (JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary)!
    }
    func setUpMain(completion: @escaping (Result<NSDictionary, Error>) async -> Void) async{
        Task{
            do{
                let weatherDat = try await GrabDataMain(urls: "https://api.weather.gov/points/39.8992,-77.6805")["properties"] as? NSDictionary
                self.weatherDictionary = weatherDat
                await completion(.success(weatherDat!))
                
            } catch{
                await completion(.failure(error))
            }
        }
    }
    func setUpToday() async{
        Task.init{
        do{
        
            self.weatherDictionary = try await GrabDataMain(urls: self.weatherDictionary?["forecast"] as! String)
            print(self.weatherDictionary?["forecast"])
            if let periods = weatherDictionary?["periods"] {
                self.todayDict = (periods as! NSArray)[0] as? NSDictionary
                //Set Temp Var
                self.tDat.temp = String(todayDict?["temperature"] as! Int)
                //Set short Forecast
                self.tDat.shortforecast = todayDict?["shortForecast"] as! String
                //Set Detailed Forecast
                self.tDat.forecast = todayDict?["detailedForecast"] as! String
                //Set Icon Image URL
                self.tDat.weatherIconURL = todayDict?["icon"] as! String
                //print out temperature debug test.
                print(String(todayDict?["temperature"] as! Int))
                
            } else{
                //If parsing fails.
                print("Cannot convert to NSArray?")
            }
        } catch{
            print(error)
        }
        }
    }
}


var weatherModel = WeatherModel()
/*
func setUpMain() {
    
        getWeatherData(urls: "https://api.weather.gov/points/39.899226,-77.680552"){ json, error in
            if let error = error {
                print(error)
            }
            else if let json = json{
                print(json)
                //Get Todays Forecast JSON URL
                weatherDictionary = (json as! NSDictionary)["properties"] as? NSDictionary
                setUpToday()
            }
        }
     
}
 */
//Grab TODAY'S Forecast JSON File and parse
/*
func setUpToday() {
        getWeatherData(urls: weatherDictionary?["forecast"] as! String){ json, error in
            if let error = error {
                print(error)
            }
            else if let jsonF = json{
                weatherDictionary = (jsonF as! NSDictionary)["properties"] as! NSDictionary
                if let periods = weatherDictionary?["periods"] {
                    todayDict = (periods as! NSArray)[0] as? NSDictionary
                    //Set Temp Var
                    tDat.temp = String(todayDict?["temperature"] as! Int)
                    //Set short Forecast
                    tDat.shortforecast = todayDict?["shortForecast"] as! String
                    //Set Detailed Forecast
                    tDat.forecast = todayDict?["detailedForecast"] as! String
                    //Set Icon Image URL
                    tDat.weatherIconURL = todayDict?["icon"] as! String
                    //print out temperature debug test.
                    print(String(todayDict?["temperature"] as! Int))
                    
                } else{
                    //If parsing fails.
                    print("Cannot convert to NSArray?")
                }
            }
        }
}
*/



