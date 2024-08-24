//
//  CollectionViewCell.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/24.
//

import SwiftUI

struct CollectCell: View {
    let title: String
    let movies: [Result] // 接收 Result 型別的電影資料

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .padding(.vertical)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(150))], spacing: 16) {
                    ForEach(movies, id: \.id) { movie in
                        VStack {
                            
                            Image(systemName: "film")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            Text(movie.title)
                                .font(.caption)
                                .lineLimit(1)
                            Text(movie.releaseDate)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
        }
    }
}

