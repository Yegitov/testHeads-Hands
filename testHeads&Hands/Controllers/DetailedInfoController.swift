//
//  DetailedInfoController.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import UIKit

class DetailedInfoController: UIViewController {

    var character: Character!
    weak var delegate: NavigationDelegate?

    @IBOutlet private weak var episodeCollection: UICollectionView!
    @IBOutlet private weak var originPlanet: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        originPlanet.setTitle(character.origin.name, for: .normal)
        episodeCollection.setCollectionViewLayout(makeLayout(), animated: false)
        title = character.name
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

    @IBAction private func selectedPlanet(_ sender: Any) {
        delegate?.selectedLocation(character.origin.name)
    }
    
}

extension DetailedInfoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedEpisode(character.episode[indexPath.row])
    }
}

extension DetailedInfoController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return character.episode.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell",
                                                            for: indexPath) as? EpisodeCell else {
            return UICollectionViewCell()
        }
        cell.setup(with: character.episode[indexPath.row])
        return cell
    }
}
