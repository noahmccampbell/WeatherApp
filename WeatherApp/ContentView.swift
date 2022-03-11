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
            VStack{
                Spacer()
                Text("Today")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Spacer()
                AsyncImage(url:URL(string: tDat.weatherIconURL), content: { image in
                    switch image {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                        case .failure:
                                Image(systemName: "photo")
                        @unknown default:
                            // Since the AsyncImagePhase enum isn't frozen,
                            // we need to add this currently unused fallback
                            // to handle any new cases that might be added
                            // in the future:
                            EmptyView()
                        }
                        
                })
                    
                Spacer()
                //ICON
                Text("\(tDat.temp)°F")
                    .font(.largeTitle)
                    .bold()
                Text(tDat.shortforecast)
                    .font(.headline)
                Spacer()
                //Desc. Forecast
                Text("In Depth Look")
                    .font(.title)
                    .bold()
                    .padding()
                Text(tDat.forecast)
                    .font(.headline)
            }.navigationTitle("Today")
            Text("Hello, world! Here is your location if you allowed it: \(locationM.lon), \(locationM.lat)")
                .padding()
        }
        //temp = locationM.todayDict?["temperature"] as! String
        //Request HTTP data grab data and then parse JSON data.
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
