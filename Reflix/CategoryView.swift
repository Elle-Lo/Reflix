//
//  CategoryView.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/30.
//

import SwiftUI

struct ModalView: View {
    @Binding var isPresented: Bool
    @Binding var selectedGenre: Genre2?
    let genres: [Genre2]
    let onSelect: (Genre2?) -> Void

    var body: some View {
        
        
        VStack() {
            Spacer()

            Button(action: {
                onSelect(nil)
                isPresented = false
            }) {
                Text("全部")
                    .font(.title2)
                    .foregroundColor(.white)
            }.padding(.bottom,20)

            ForEach(genres) { genre in
                Button(action: {
                    onSelect(genre)
                    isPresented = false
                }) {
                    Text(genre.name)
                        .font(.title2)
                        .foregroundColor(.white)
                } .padding(.bottom,20)
            }
                   
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(20)
        .shadow(radius: 50)
        .background(Color.clear)

        
    }
}

