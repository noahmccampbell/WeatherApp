//
//  TodayView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 3/14/22.
//

import SwiftUI

struct TodayView: View {
    @State var tDat = weatherModel.tDat
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
            Text("Today")
                .font(.system(size: 65.0))
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
                .font(.system(size: 65.0))
                .bold()
                Text(tDat.shortforecast)
                .font(.system(size: 35.0))
            Spacer()
            }
            //Desc. Forecast
            Text("In Depth Look")
                .font(.system(size: 25.0))
                .bold()
                .padding()
            Text(tDat.forecast)
                .font(.system(size: 20.0))
                .padding()
            Spacer()
        }
        .task {
            tDat = weatherModel.tDat
        }
        .refreshable {
            tDat = weatherModel.tDat
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
