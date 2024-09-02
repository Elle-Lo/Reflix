import SwiftUI

struct ContentView: View {
    
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some View {
        TabBarView()
    }
}

#Preview {
    ContentView()
}


