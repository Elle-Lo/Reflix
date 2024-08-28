//
//  YouTubeView.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/28.
//

import SwiftUI
import WebKit

// YouTubeView: 將 YouTube 影片嵌入到 WKWebView 中的 SwiftUI 視圖
struct YouTubeView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?autoplay=1")!
        uiView.load(URLRequest(url: youtubeURL))
    }
}
