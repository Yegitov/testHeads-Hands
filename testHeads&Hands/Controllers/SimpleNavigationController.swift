//
//  SimpleNavigationController.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import Combine
import UIKit

enum ContentType {
    case character
    case location
    case episode
}

class SimpleNavigationController: UINavigationController {

    private let model = DataModel()
    private var subscribers: [AnyCancellable] = []

    @IBOutlet private weak var collection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()


        subscribers.append(model.$characters
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.updateCollection()
            })

        subscribers.append(model.$selectedEpisode
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                self.show(type: .episode)
            })

        subscribers.append(model.$selectedLocation
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                self.show(type: .location)
            })

        subscribers.append(model.$selectedCharacter
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                self.show(type: .character)
            })
    }
    
    private func updateCollection() {
        
    }

    private func show(type: ContentType) {
        var controller: UIViewController!
        switch type {
        case .character:
            controller = DetailedInfoController(character: model.selectedCharacter)
        case .location:
            controller = LocationController(location: model.selectedLocation)
        case .episode:
            controller = EpisodeController(episode: model.selectedEpisode)
        }
        pushViewController(controller, animated: true)
    }

}

extension SimpleNavigationController: DataModelUIDelegate {
    func show(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SimpleNavigationController: UICollectionViewDelegate {

}

extension SimpleNavigationController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }


}
