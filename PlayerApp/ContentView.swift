//
//  ContentView.swift
//  PlayerApp
//
//  Created by Tim Studt-Kristiansen on 08/09/2021.
//

import AVFoundation
import Foundation
import SwiftUI

struct ContentView: View {
    let player = AVPlayer(url: .init(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!)
    @State var progress: Double = 0
    @State var buffered: Double = 0
    var body: some View {
        VStack(spacing: 50) {
            Text("Hello, world!")
                .padding()
            Button(action: toggle, label: {
                Text("Play")
            })
            Button(action: seek, label: {
                Text("Seek")
            })
            Slider(value: $progress)
        }
    }

    private func toggle() {
        if player.timeControlStatus == .paused {
            player.play()
            observeProgress()
        } else {
            player.pause()
        }
    }

    private func seek() {
        player.seek(to: .init(seconds: 60, preferredTimescale: 10)) { success in
            print("seek: \(success)")
        }
    }

    private func observeProgress() {
        player.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { time in
            self.progress = time.seconds / player.currentItem!.duration.seconds
            print("progress: \(time.seconds)")
            updateBuffer()
        }
    }

    private func updateBuffer() {
        guard let timeRanges = player.currentItem?.loadedTimeRanges.map(\.timeRangeValue).last?.end.seconds else {
            return
        }

        let buffered = timeRanges / player.currentItem!.duration.seconds
        guard self.buffered != buffered else {
            return
        }
        self.buffered = buffered
        print("buffered: \(timeRanges)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
