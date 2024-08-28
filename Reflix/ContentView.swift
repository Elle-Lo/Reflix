import SwiftUI

struct ContentView: View {
    
    init() {
        // 設定全域的外觀模式為黑暗模式
        UIView.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some View {
        TabBarView()
    }
}

#Preview {
    ContentView()
}

//#Preview("ContentView (Landscape)", traits: .landscapeLeft) {
//ContentView()
//}

