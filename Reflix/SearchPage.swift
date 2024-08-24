import SwiftUI

// Search頁的畫面
struct SearchTabView: View {
    
    @State private var searchText = ""
    @State private var movieRecords = ["關於我轉生變成史萊姆這件事", "金剛與哥吉拉", "絕命毒屍", "腦筋急轉彎"]
    
    var filteredRecords: [String] {
        if searchText.isEmpty {
            return movieRecords
        } else {
            return movieRecords.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                Text("搜尋")
                    .font(.custom("PingFang TC", size: 30))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $searchText, onCommit: {
                        addSearchRecord()
                    })
                    .padding(8)
                }
                .padding(.horizontal, 16)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .padding(.top, 0)
                .padding(.bottom, 15)
                
                HStack {
                    Text("搜尋紀錄")
                        .font(.custom("PingFang TC", size: 18))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        movieRecords.removeAll()
                    }) {
                        Text("清除")
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                ZStack {
                                    Capsule(style: .circular)
                                        .stroke(lineWidth: 1.0)
                                }
                            )
                    }
                    .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                List {
                    ForEach(filteredRecords, id: \.self) { record in
                        HStack {
                           
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                            
                            Text(record)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                if let index = movieRecords.firstIndex(of: record) {
                                    movieRecords.remove(at: index)
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 10))
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                
            }
            .background(Color.reflixBlack.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        
    }
    
    private func addSearchRecord() {
        let trimmedText = searchText.trimmingCharacters(in: .whitespaces)
        if !trimmedText.isEmpty && !movieRecords.contains(trimmedText) {
            movieRecords.append(trimmedText)
        }
    }
   
}

#Preview {
    SearchTabView()
}

#Preview("SearchTabView (Landscape)", traits: .landscapeLeft) {
    SearchTabView()
}
