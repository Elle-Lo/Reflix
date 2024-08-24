import SwiftUI


//Movie頁的畫面
struct MovieTabView: View {
    
    var body: some View {
        ZStack {
            Color.reflixBlack.ignoresSafeArea()
            Text("Movie")
                .foregroundColor(.white)
        }
    }
    
}


#Preview {
    MovieTabView()
}

#Preview("SearchTabView (Landscape)", traits: .landscapeLeft) {
    MovieTabView()
}
