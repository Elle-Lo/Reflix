import SwiftUI

struct ContentView: View {
    
    init() {
        // 設定為dark mode
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

