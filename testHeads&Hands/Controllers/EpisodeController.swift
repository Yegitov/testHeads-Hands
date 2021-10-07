//
//  EpisodeController.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import UIKit

class EpisodeController: UIViewController {

    var episode: Episode!
    weak var delegate: NavigationDelegate?

    @IBOutlet private weak var episodeName: UILabel!
    @IBOutlet private weak var episodeNumber: UILabel!
    @IBOutlet private weak var episodeCharacterCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        episodeName.text = episode.name
        episodeNumber.text = episode.episode

        episodeCharacterCollection.setCollectionViewLayout(makeLayout(), animated: false)
    }

    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.0,
                                                     leading: 2.0,
                                                     bottom: 2.0,
                                                     trailing: 2.0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension EpisodeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: episode.characters[indexPath.row]) else {
            return
        }
        delegate?.selectedCharacter(Int(url.lastPathComponent) ?? 1)
    }
}

extension EpisodeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return episode.characters.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCharacterCell", for: indexPath) as? EpisodeCell else {
            return UICollectionViewCell()
        }
        cell.setup(with: episode.characters[indexPath.row])
        return cell
    }
}
