//
//  ContentView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 2/8/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationM = locationManagerC()
    init(){
        locationM.askForPerms()
        Task.init{
            await weatherModel.setUpMain(){ result in
                switch result{
                case .success(let weatherDat):
                    await weatherModel.setUpToday()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    var body: some View {
        TabView {
                TodayView()
                    .tabItem{
                        VStack{
                            Image(systemName: "sun.and.horizon")
                            Text("Today")
                        }
                    }
                HourlyView()
                    .tabItem{
                        VStack{
                            Image(systemName: "clock")
                            Text("Hourly")
                        }
                    }
                WeekView()
                    .tabItem{
                        VStack{
                            Image(systemName: "calendar")
                            Text("Daily")
                        }
                    }
                }
        }
        //temp = locationM.todayDict?["temperature"] as! String
        //Request HTTP data grab data and then parse JSON data.
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
