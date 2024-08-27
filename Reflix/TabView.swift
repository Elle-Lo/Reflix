import SwiftUI

struct TabBarView: View {
    
    init() {
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
       .accentColor(.white) // 设置选中标签的颜色
       .background(Color.black.ignoresSafeArea(edges: .bottom)) // 设置TabBar背景颜色
   }
}



#Preview {
    TabBarView()
}

//#Preview("ContentView (Landscape)", traits: .landscapeLeft) {
//    TabBarView()
//}

