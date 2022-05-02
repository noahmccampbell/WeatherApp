//
//  TodayView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 3/14/22.
//

import SwiftUI

struct TodayView: View {
    //State variable handling TODAYS Data
    @State var tDat = weatherModel.tDat
    //Observing Objects to update view on changes and to access data of objects.
    @ObservedObject var weather = weatherModel
    @ObservedObject var locationServices = locationM
    //Colors for the Background
    private var topColor = Color(red: 1/255, green: 205/255, blue: 255/255)
    private var centerColor = Color(red: 1/255, green: 231/255, blue: 255/255)
    private var bottomColor = Color(red: 1/255, green: 154/255, blue: 255/255)
    var body: some View {
        ZStack{
            LinearGradient(colors: [topColor, centerColor, bottomColor], startPoint: .topLeading, endPoint: .bottom).edgesIgnoringSafeArea(.all)
        VStack{
            Spacer()
            Text("Today")
                .font(.system(size: 65.0))
                .bold()
                .padding()
            Spacer()
            //Asynchronusly grabs an image and handles cases for different states of image loading.
            AsyncImage(url:URL(string: tDat.weatherIconURL), content: { image in
                switch image {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .padding()
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
                .font(.system(size: 65.0))
                .bold()
            Spacer()
            Text(tDat.shortforecast)
                .font(.system(size: 30.0))
            LazyHStack(spacing: 34) {
                if(!Hours.isEmpty){
                    ForEach(Hours[0...3], id: \.self){ content in
                        VStack{
                            Text("\(content.temp)°")
                                .font(.system(size: 40))
                            AsyncImage(url:URL(string: content.weatherIconURL), content: { image in
                            switch image {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
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
                            Text(content.startTime)
                                .font(.system(size: 16))
                            
                        }
                            
                    }
                }
            }
            Spacer()
            }
        }
        //Task that continually runs in the background(make sure everything loads with no errors.)
        .task {
            if(pulledTodayDat){
                weatherModel.formatTodayData(todayData: formattedDataB)
            }
            tDat = weatherModel.tDat
            
        }
        //Same thing as task above except on refresh.
        .refreshable {
            if(pulledTodayDat){
                weatherModel.formatTodayData(todayData: formattedDataB)
            }
            tDat = weatherModel.tDat
        }
    }
}


struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
