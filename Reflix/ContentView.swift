//
//  ContentView.swift
//  Reflix
//
//  Created by Tzu ning Lo on 2024/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            MovieTabView()
                .tabItem {
                    Label("movies", image: "movie")
                }.tag(1)
            
            SearchTabView()
                .tabItem {
                    Label("search", image: "magnifier")
                }.tag(2)
        }
        .accentColor(.black)
    }
    
}

struct MovieTabView: View {
    var body: some View {
        Text("Movie")
    }
}

struct SearchTabView: View {
    var body: some View {
        Text("Search")
    }
}

#Preview {
    ContentView()
}

#Preview("ContentView (Landscape)", traits: .landscapeLeft) {
ContentView()
}
