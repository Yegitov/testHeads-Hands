//
//  CharacterCell.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 07.10.2021.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet private weak var characterImage: UIImageView!
    @IBOutlet private weak var characterName: UILabel!
    @IBOutlet private weak var characterStatus: UILabel!
    @IBOutlet private weak var characterLocation: UILabel!
    @IBOutlet private weak var characterEpisode: UILabel!


    func setup(with character: Character) {
        characterName.text = character.name
        characterStatus.text = character.status.rawValue
        characterLocation.text = character.location.name
        characterEpisode.text = character.episode.sorted().last
        characterImage.downloaded(from: character.image)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
