import SwiftUI

//Search頁的畫面
struct SearchTabView: View {
    
    @State private var search: String = ""
    let movieRecords = ["Apple", "Banana", "Coconut", "Banana"]
    
    var body: some View {
        ZStack {
            Color.reflixBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("搜尋")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("PingFang TC", size: 25))
                        .padding(.horizontal, 16)
                }
                
                HStack(spacing: 0) {
                    TextField("Search", text: $search)
                        .padding(8)
                        .background(Color.clear)
                        .background(
                            ZStack {
                                Capsule(style: .circular)
                                .stroke(lineWidth: 2.0)
                        })
                        .cornerRadius(10.0)
                        .padding(.vertical, 16)
                }
                .padding(.horizontal ,16)
                
                
                HStack(spacing: 0) {
                    Text("搜尋紀錄")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("PingFang TC", size: 18))
                        .padding(.horizontal, 16)
                    
                    Button(action: {
                        print("Delete Button was tapped!")
                    }) {
                        Text("清除")
                            .font(.headline)
                            .padding(.horizontal ,16)
                            .padding(.vertical ,6)
                            .background(
                                ZStack {
                                    Capsule(style: .circular)
                                    .stroke(lineWidth: 1.0)
                                })
                    }
                    .padding(.horizontal ,16)
                    .foregroundColor(.gray)

                    
                }
                .padding(.vertical ,16)
                
                HStack {
                    List(movieRecords, id: \.self) { movieRecord in
                        Text(movieRecord)
                            .background(Color.clear)
                    }
                    
                }
                
                Spacer()
            }
            
        }
        .foregroundStyle(.reflixWhite)
        
    }
}

#Preview {
    SearchTabView()
}

#Preview("ContentView (Landscape)", traits: .landscapeLeft) {
    SearchTabView()
}
