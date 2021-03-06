//
//  DaysSelector.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/9/22.
//

import SwiftUI

struct Day: Identifiable {
    var id: Int
    var intValue: Int
    var name: String
    var isSelected: Bool
}

class Days: ObservableObject {
    @Published var list = [
        Day(id: 0, intValue: 2, name: "Mo", isSelected: false),
        Day(id: 1, intValue: 3, name: "Tu", isSelected: false),
        Day(id: 2, intValue: 4,name: "We", isSelected: false),
        Day(id: 3, intValue: 5,name: "Th", isSelected: false),
        Day(id: 4, intValue: 6, name: "Fr", isSelected: false),
        Day(id: 5, intValue: 7, name: "Sa", isSelected: false),
        Day(id: 6, intValue: 1, name: "Su", isSelected: false),
    ]
}

struct DaysSelector: View {
    @Binding var daysAsStringArray: [String]
    @StateObject var days = Days()
    var columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 4)
    
    init(daysArray: Binding<[String]>) {
        _daysAsStringArray = daysArray
    }
    
    var body: some View {
        VStack {
            Text("Select days")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing])
            LazyVGrid(columns: columns) {
                ForEach(days.list) { day in
                    Button {
                        days.list[day.id].isSelected.toggle()
                        setArrayStringDays()
                    } label: {
                        SizedCircleButton(
                            content: day.name,
                            width: 60, height: 60,
                            color: day.isSelected ? .blue : .gray
                        )
                    }.padding([.top, .bottom], 20)
                }
            }
        }.onAppear() {
            setSelectedDays()
        }
    }
    
    func setSelectedDays() {
        if !daysAsStringArray.isEmpty {
            days.list.filter { day in
                return daysAsStringArray.contains { dayName in
                    return day.name == dayName
                }
            }.forEach { day in
                days.list[day.id].isSelected = true
            }
        } else {
            days.list.forEach { day in
                days.list[day.id].isSelected = false
            }
        }
    }
    
    func setArrayStringDays() {
        daysAsStringArray =
            days.list.filter { day in
                return day.isSelected
            }.map { day in
                return day.name
            }
    }
    
    static func getWeekDaysAsIntArray(weekDays: [String]) -> [Int] {
        let days = Days()
        return days.list.filter { day in
            return weekDays.contains { dayName in
                return day.name == dayName
            }
        }.map { day in
            return day.intValue
        }
    }

}

struct DaysSelector_Previews: PreviewProvider {
    static var previews: some View {
        DaysSelector(daysArray: .constant(["Mo"]))
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
