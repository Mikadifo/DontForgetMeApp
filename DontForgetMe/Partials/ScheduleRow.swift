//
//  ScheduleRoew.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/9/22.
//

import SwiftUI

struct ScheduleRow: View {
    var schedule: Schedule
    
    var body: some View {
        VStack {
            HStack {
                Text(schedule.name)
                Spacer()
                Text(schedule.time.split(separator: ",")[0]).bold()
            }
            HStack {
                ForEach(schedule.days, id: \.self) { day in
                    SizedCircleButton(content: day, width: 30, height: 30, color: .blue)
                        .padding([.leading, .trailing], 8)
                        .padding([.top], 2)
                }
                Spacer()
            }
        }.padding([.bottom, .top])
    }
}

struct ScheduleRoew_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRow(schedule: Schedule(id: "DM99", name: "Daily daily", days: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"], time: "17:00 AM, May 02", notifications: []))
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
