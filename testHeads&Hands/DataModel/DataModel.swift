//
//  DataModel.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import Combine
import Foundation

protocol DataModelUIDelegate: NSObjectProtocol {
    func show(error: Error)
    func startLoader()
    func stopLoader()
}

class DataModel: ObservableObject {
    private let apiManager = APIManager()
    weak var delegate: DataModelUIDelegate?

    @Published private(set) var characters: [Character] = []
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

    @Published private(set) var selectedCharacter: Character? = nil
    @Published private(set) var selectedEpisode: Episode? = nil
    @Published private(set) var selectedLocation: Location? = nil

    private var cancellable: AnyCancellable?

    func getAllCharacters() {
        delegate?.startLoader()
        cancellable = apiManager.getAllCharacters()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.delegate?.show(error: error)
                case .finished:
                    print("Finished loading characters info")
                }
            }, receiveValue: { characters in
                self.characters = characters
                self.delegate?.stopLoader()
        })
    }

    func selectCharacter(id: Int) {
        selectedCharacter = characters[id - 1]
    }

    func selectCharacter(name: String) {
        selectedCharacter = characters.first { character in
            character.name == name
        }
    }

    func selectEpisode(url: String) {
        let urledEpisode = episodes.filter { episode in
            episode.url == url
        }
        if !urledEpisode.isEmpty {
            selectedEpisode = urledEpisode.first
        } else {
            delegate?.startLoader()
            cancellable = apiManager.getEpisode(url: url)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.delegate?.show(error: error)
                    case .finished:
                        print("Finished loading episode info")
                    }
                }, receiveValue: { episode in
                    self.selectedEpisode = episode
                    self.episodes.append(episode)
                    self.delegate?.stopLoader()
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
            delegate?.startLoader()
            cancellable = apiManager.getLocation(name: name)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.delegate?.show(error: error)
                    case .finished:
                        print("Finished loading location info")
                    }
                }, receiveValue: { location in
                    self.selectedLocation = location
                    self.locations.append(location)
                    self.delegate?.stopLoader()
            })
        }
    }
}
