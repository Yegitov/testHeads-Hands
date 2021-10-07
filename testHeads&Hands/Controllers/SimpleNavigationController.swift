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
                    charContr.characters = self.model.characters
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controllerID: String!
        switch type {
        case .character:
            guard let char = model.selectedCharacter else {
                return
            }
            controllerID = "DetailedInfoController"
            guard let temp = storyboard.instantiateViewController(identifier: controllerID) as? DetailedInfoController else {
                return
            }
            temp.character = char
            temp.delegate = self
            controller = temp
        case .location:
            guard let loc = model.selectedLocation else {
                return
            }
            controllerID = "LocationController"
            guard let temp = storyboard.instantiateViewController(identifier: controllerID) as? LocationController else {
                return
            }
            temp.location = loc
            temp.delegate = self
            controller = temp
        case .episode:
            guard let epi = model.selectedEpisode else {
                return
            }
            controllerID = "EpisodeController"
            guard let temp = storyboard.instantiateViewController(identifier: controllerID) as? EpisodeController else {
                return
            }
            temp.episode = epi
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
