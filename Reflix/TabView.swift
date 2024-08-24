import SwiftUI

struct TabBarView: View {
    
    init() {
            // 設置未選中的 tab item 顏色
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        }
    
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
        .accentColor(.white)
    }
    
}



#Preview {
    TabBarView()
}

#Preview("ContentView (Landscape)", traits: .landscapeLeft) {
    TabBarView()
}
