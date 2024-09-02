import SwiftUI

struct CategoryView: View {
    @Binding var isPresented: Bool
    @Binding var selectedGenre: Genre2?
    let genres: [Genre2]
    let onSelect: (Genre2?) -> Void

    var body: some View {
        
        ScrollView {
            VStack {
                Spacer()
                
                Button(action: {
                    onSelect(nil)
                    isPresented = false
                }) {
                    Text("全部")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding(.bottom,20)
                .padding(.top,30)
                
                ForEach(genres) { genre in
                    Button(action: {
                        onSelect(genre)
                        isPresented = false
                    }) {
                        Text(genre.name)
                            .font(.title2)
                            .foregroundColor(.gray)
                    } .padding(.bottom,20)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(20)
            .shadow(radius: 50)
            .background(Color.clear)
        } 
        .scrollIndicators(.hidden)
        
    }
}

