//
//  AudiosView.swift
//  VKMisicMultiplatform
//
//  Created by Alexander Kormanovsky on 27.03.2022.
//

import SwiftUI

struct AudiosView: View {
    
    @StateObject var audiosFetcher = AudiosFetcher()
    @StateObject var playingAudioStore = PlayingAudioStore()
    
    var body: some View {
        List {
            ForEach(audiosFetcher.audioItems.items) { item in
                AudioRowView(
                    audioItem: item, playingAudioStore: playingAudioStore
                )
                Divider()
            }
        }.onAppear {
            audiosFetcher.fetchAudios()
        }
    }
}

struct AudiosView_Previews: PreviewProvider {
    static var previews: some View {
        AudiosView()
    }
}
