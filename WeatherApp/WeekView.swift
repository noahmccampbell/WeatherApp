//
//  WeekView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 3/14/22.
//

import SwiftUI

struct WeekView: View {
    //Observed objects for view to update on changes within object.
    @ObservedObject var weather = weatherModel
    @ObservedObject var locationServices = locationM
    //Colors for linear gradient
    private var topColor = Color(red: 1/255, green: 205/255, blue: 255/255)
    private var centerColor = Color(red: 1/255, green: 231/255, blue: 255/255)
    private var bottomColor = Color(red: 1/255, green: 154/255, blue: 255/255)
    var body: some View {
        ZStack{
        LinearGradient(colors: [bottomColor, bottomColor, topColor], startPoint: .topLeading, endPoint: .bottom).edgesIgnoringSafeArea(.all)
        VStack{
            ScrollView{
                ForEach(Week, id: \.self){ day in
                    HStack{
                        AsyncImage(url:URL(string: day.weatherIconURL), content: { image in
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
                        
                        Text(day.name)
                            .padding()
                        Group{
                            Spacer()
                            Divider()
                            
                        }
                        Text("\(day.temp)°F")
                            .padding()
                        //Linear gradient modifier
                    }.background(LinearGradient(gradient: Gradient(colors: [self.bottomColor, Color.clear]), startPoint: .top, endPoint: .bottom).opacity(0.1))
                        .background(Color.clear)
                }
            }
        }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
    }
}
