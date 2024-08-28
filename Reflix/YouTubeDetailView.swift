//
//  YouTubeDetailView.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/28.
//

import SwiftUI

struct YouTubeDetailView: View {
    let videoID: String
    
//    @Binding var isPresented: Bool
    
    var body: some View {
            VStack {
                YouTubeView(videoID: videoID)
                    .edgesIgnoringSafeArea(.all) // 使視圖充滿整個螢幕

            }
        }
    
//    var body: some View {
//        VStack {
//            YouTubeView(videoID: videoID)
//                .edgesIgnoringSafeArea(.all) // 使視圖充滿整個螢幕
//            
//            Button(action: {
//                isPresented = false // 返回主頁面
//            }) {
//                Text("返回")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//    }
}
