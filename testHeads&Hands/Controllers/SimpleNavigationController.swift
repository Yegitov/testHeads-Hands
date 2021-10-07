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

protocol NavigationDelegate: NSObjectProtocol {
    func selectedCharacter(_ id: Int)
    func selectedEpisode(_ number: Int)
    func selectedLocation(_ name: String)
}

class SimpleNavigationController: UINavigationController {

    private let model = DataModel()
    private var subscribers: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
        model.getAllCharacters()

        subscribers.append(model.$characters
            .receive(on: DispatchQueue.main)
            .sink { _ in
                if let charContr = self.viewControllers.first as? CharacterController {
                    charContr.updateCollection()
                }
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

    private func show(type: ContentType) {
        var controller: UIViewController!
        switch type {
        case .character:
            let temp = DetailedInfoController(character: model.selectedCharacter)
            temp.delegate = self
            controller = temp
        case .location:
            let temp = LocationController(location: model.selectedLocation)
            temp.delegate = self
            controller = temp
        case .episode:
            let temp = EpisodeController(episode: model.selectedEpisode)
            temp.delegate = self
            controller = temp
        }
        pushViewController(controller, animated: true)
    }

}

extension SimpleNavigationController: DataModelUIDelegate {
    func show(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func startLoader() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func stopLoader() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

extension SimpleNavigationController: NavigationDelegate {
    func selectedCharacter(_ id: Int) {
        model.selectCharacter(id: id)
    }

    func selectedEpisode(_ number: Int) {
        model.selectEpisode(number: number)
    }

    func selectedLocation(_ name: String) {
        model.selectLocation(name: name)
    }
}
