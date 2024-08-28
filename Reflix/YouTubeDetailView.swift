//
//  YouTubeDetailView.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/28.
//

import SwiftUI

struct YouTubeDetailView: View {
    let videoID: String
    
    
    var body: some View {
            VStack {
                YouTubeView(videoID: videoID)
                    .edgesIgnoringSafeArea(.all) // 使視圖充滿整個螢幕
            }
        }
    
}
