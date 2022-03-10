//
//  ContentView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 2/8/22.
//

import SwiftUI


struct ContentView: View {
    @StateObject var locationM = locationManagerC()
        init() {
            locationM.askForPerms()
            setUpMain()
            
        }
        var body: some View {
            Text("Hello, world! Here is your location if you allowed it: \(locationM.lon), \(locationM.lat)")
            .padding()
            Text("Temperature today: " + tDat.temp)
        }
        //temp = locationM.todayDict?["temperature"] as! String
        //Request HTTP data grab data and then parse JSON data.
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
