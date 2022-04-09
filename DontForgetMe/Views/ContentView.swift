//
//  ContentView.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/7/22.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Don't Forget Me")
                    .font(.largeTitle)
                Text(authentication.user?.username ?? "")
                    .font(.largeTitle)
                    .padding([.bottom], 10)
                Text("Choose an option...")
                    .font(.headline)
                    .padding([.bottom], 50)
                
                HStack(spacing: 30) {
                    NavigationLink(destination: ThingsView().environmentObject(authentication)) {
                        CircleButton(content: Text("My Things \(Image(systemName: "hands.sparkles"))"), color: Color("Orange"))
                            .frame(width: 150, height: 150)
                    }
                    NavigationLink(destination: SchedulesView().environmentObject(authentication)) {
                        CircleButton(content: Text("My Schedules \(Image(systemName: "calendar"))"), color: Color("Orange"))
                            .frame(width: 150, height: 150)
                    }
                }.padding([.top], 50)
                HStack(spacing: 30) {
                    NavigationLink(destination: EmergencyContactsView()) {
                        CircleButton(content: Text("My Emergency Contacts \(Image(systemName: "phone"))"), color: Color("Orange"))
                            .frame(width: 150, height: 150)
                    }
                    NavigationLink(destination: AccountView().environmentObject(authentication)) {
                        CircleButton(content: Text("My Account \(Image(systemName: "person"))"), color: Color("Orange"))
                            .frame(width: 150, height: 150)
                    }
                }.padding([.bottom], 100)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Authentication())
    }
}
