//
//  AudioRowView.swift
//  VKMisicMultiplatform
//
//  Created by Alexander Kormanovsky on 27.03.2022.
//

import SwiftUI

struct AudioRowView: View {
    
    private static var durationFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }
    
    @ObservedObject var audioItem: AudioItem
    @StateObject var playingAudioStore: PlayingAudioStore
    
    var body: some View {
        HStack {
            Button(action: {
                playingAudioStore.playingAudio = (playingAudioStore.playingAudio == audioItem ? nil : audioItem)
            }) {
                Image(systemName: playingAudioStore.playingAudio == audioItem ? "pause.circle" : "play.circle")
            }
            .buttonStyle(BorderlessButtonStyle())
            .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text(audioItem.audio.title).bold()
                Text(audioItem.audio.artist).foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(formatDuration(audioItem.audio.duration)).foregroundColor(.gray)
        }
    }
    
    private func formatDuration(_ duration: Int) -> String {
        return Self.durationFormatter.string(from: TimeInterval(duration))!
    }
}

struct AudioRowView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRowView(audioItem: AudioItem(), playingAudioStore: PlayingAudioStore())
    }
}
