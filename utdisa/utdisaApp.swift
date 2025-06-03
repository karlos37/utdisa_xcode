//
//  utdisaApp.swift
//  utdisa
//
//  Created by Vedansh Surjan on 27/05/25.
//

import SwiftUI

@main
struct utdisaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct MinimalTestView: View {
    @State private var expanded: Int? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<2) { i in
                    VStack {
                        HStack {
                            Text("Card \(i + 1)")
                                .font(.title)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    expanded = expanded == i ? nil : i
                                }
                            }) {
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(expanded == i ? 180 : 0))
                            }
                        }
                        .padding()
                        if expanded == i {
                            Text("Expanded content for card \(i + 1)")
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.top, 40)
        }
    }
}
