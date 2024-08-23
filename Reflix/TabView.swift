import SwiftUI

struct TabBarView: View {
    
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

//Movie頁的畫面
struct MovieTabView: View {
    var body: some View {
        Text("Movie")
    }
}

//Search頁的畫面
struct SearchTabView: View {
    var body: some View {
        Text("Search")
    }
}

#Preview {
    TabBarView()
}

#Preview("ContentView (Landscape)", traits: .landscapeLeft) {
    TabBarView()
}
