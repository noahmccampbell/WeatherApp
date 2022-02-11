//
//  ContentView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 2/8/22.
//

import SwiftUI
import CoreLocation

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

struct ContentView: View {
    @StateObject var locationM = locationManagerC()
    init(){
        locationM.askForPerms()
    }
    var body: some View {
        Text("Hello, world! Here is your location if you allowed it: \(locationM.lon), \(locationM.lat)")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
