//
//  ContentView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 2/8/22.
//

import SwiftUI

struct ContentView: View {
        init(){
        locationM.askForPerms()
        locationM.lat = 37.0213
        locationM.lon = -76.6803
        print("Wow")
        Task{
            print("Wa2")
            //Waits for the weather to be set up and pulled from the internet.
            await weatherModel.setUpMain(lati: Float(locationM.lat), long: Float(locationM.lon)){ result in
                print(result)
                //current status of the asynchronus task. Basically if it is completed or not
                    switch result{
                    case .success(let weatherDat):
                        await weatherModel.setUpToday(MainData: weatherDat){ today in
                            switch today{
                            //On success it runs the formatting function with the data pullet from the setting up function
                            case .success(let todayDat):
                                weatherModel.formatTodayData(todayData: todayDat)
                                weatherModel.formatWeekData(todayData: todayDat)
                            //If something goes wrong with pulling data from the internet
                            case .failure(let error):
                                print(error)
                            }
                                
                            }
                            pulledTodayDat = true
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
