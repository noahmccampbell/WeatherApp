//
//  ContentView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 2/8/22.
//
//DISCLAIMER: THIS APP IS NOT PERFECT THERE MAY STILL BE UNTESTED BUGS IT IS LIABLE TO FAIL.

import SwiftUI

struct ContentView: View {
        private var topColor = Color(red: 1/255, green: 205/255, blue: 255/255)
        private var centerColor = Color(red: 1/255, green: 231/255, blue: 255/255)
        private var bottomColor = Color(red: 1/255, green: 154/255, blue: 255/255)
        init(){
        
        locationM.askForPerms()
        locationM.lat = 37.0213
        locationM.lon = -76.6803
        print("Wow")
        if(hasCLAuth && gotLocationData){
        Task{
            print("Wa2")
            //Waits for the weather to be set up and pulled from the internet.
            await weatherModel.setUpMain(lati: Float(locationM.lat), long: Float(locationM.lon)){ result in
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
                        await weatherModel.setUpHourly(MainData: weatherDat){
                            hourly in
                            switch hourly{
                            case .success(let hourlyDat):
                                weatherModel.formatHourlyData(hourlyData: hourlyDat)
                                print(NSDate.now)
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
            UITabBar.appearance().barTintColor = UIColor(centerColor)
        }
    var body: some View {
        ZStack{
            LinearGradient(colors: [topColor, centerColor, bottomColor], startPoint: .topLeading, endPoint: .bottom).edgesIgnoringSafeArea(.all)
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
                }.background(LinearGradient(colors: [topColor, centerColor, bottomColor], startPoint: .topLeading, endPoint: .bottom))
                .task{
                    if(hasCLAuth && gotLocationData){
                    Task{
                        print("Wa2")
                        //Waits for the weather to be set up and pulled from the internet.
                        await weatherModel.setUpMain(lati: Float(locationM.lat), long: Float(locationM.lon)){ result in
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
                                    await weatherModel.setUpHourly(MainData: weatherDat){
                                        hourly in
                                        switch hourly{
                                        case .success(let hourlyDat):
                                            weatherModel.formatHourlyData(hourlyData: hourlyDat)
                                            print(NSDate.now)
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
                }
            }
        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
