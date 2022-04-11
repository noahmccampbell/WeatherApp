//
//  WeekView.swift
//  WeatherApp
//
//  Created by Noah Riley McCampbell (Student) on 3/14/22.
//

import SwiftUI

struct WeekView: View {
    @ObservedObject var weather = weatherModel
    @ObservedObject var locationServices = locationM
    var body: some View {
        VStack{
            Form{
                Section("This Week"){
                    List{
                        ForEach(Week, id: \.self){ day in
                            HStack{
                                Text("\(day.temp)°F")
                                Text(day.shortforecast)
                            }
                        }
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
