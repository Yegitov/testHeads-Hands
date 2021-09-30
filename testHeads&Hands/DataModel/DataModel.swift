//
//  DataModel.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import Combine
import Foundation

class DataModel: ObservableObject {
    private let apiManager = APIManager()

    @Published private var characters: [Character] = []
    private var episodes: [Episode] = [] {
        didSet {
            episodes.sort()
        }
    }
    private var locations: [Location] = [] {
        didSet {
            locations.sort()
        }
    }

    @Published private var selectedCharacter: Character? = nil
    @Published private var selectedEpisode: Episode? = nil
    @Published private var selectedLocation: Location? = nil

    private var cancellable: AnyCancellable?

    func selectCharacter(id: Int) {
        selectedCharacter = characters[id - 1]
    }

    func selectEpisode(number: Int) {
        let numberedEpisode = episodes.filter { episode in
            episode.id == number
        }
        if !numberedEpisode.isEmpty {
            selectedEpisode = numberedEpisode.first
        } else {
            cancellable = apiManager.getEpisode(number: number).sink(receiveCompletion: { _ in }, receiveValue: { episode in
                self.selectedEpisode = episode
                self.episodes.append(episode)
            })
        }
    }

    func selectLocation(name: String) {
        let namedLocation = locations.filter { location in
            location.name == name
        }
        if !namedLocation.isEmpty {
            selectedLocation = namedLocation.first
        } else {
            cancellable = apiManager.getLocation(name: name).sink(receiveCompletion: { _ in }, receiveValue: { location in
                self.selectedLocation = location
                self.locations.append(location)
            })
        }
    }
}
