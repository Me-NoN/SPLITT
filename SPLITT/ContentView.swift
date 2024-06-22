//
//  ContentView.swift
//  SPLITT

import SwiftUI
import CoreData
struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                BillView()
            }
            .tabItem {
                Label("New Split", systemImage: "plus.circle")
            }
            
            NavigationView {
                HistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock")
            }
        }
    }
}
