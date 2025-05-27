//
//  ContentView.swift
//  utdisa
//
//  Created by Vedansh Surjan on 27/05/25.
////
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            
            TeamRosterView()
                .tabItem {
                    Label("Team", systemImage: "person.3")
                }
            
            FormsView()
                .tabItem {
                    Label("Forms", systemImage: "doc.text")
                }
        }
        .tint(ISATheme.saffron)
    }
}

#Preview {
    ContentView()
}
