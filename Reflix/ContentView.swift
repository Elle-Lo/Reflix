import SwiftUI

struct ContentView: View {
    
    init() {
            UIView.appearance().overrideUserInterfaceStyle = .dark //初始進入app直接開啟dark mode
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

