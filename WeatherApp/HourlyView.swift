//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 3/14/22.
//

import SwiftUI

struct HourlyView: View {
    var body: some View {
        VStack{
            ScrollView{
                ForEach(Hours, id: \.self){ hour in
                    HStack{
                        AsyncImage(url:URL(string: hour.weatherIconURL), content: { image in
                        switch image {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 60, maxHeight: 60)
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
                        
                        Text(hour.startTime)
                            .padding()
                        Group{
                            Spacer()
                            Divider()
                            
                        }
                        Text("\(hour.temp)°F")
                            .padding()
                    }.background(Color.secondary).clipShape(RoundedRectangle(cornerRadius: 5)).padding().lineLimit(1).minimumScaleFactor(0.75)
                }
            }
        }
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView()
    }
}
