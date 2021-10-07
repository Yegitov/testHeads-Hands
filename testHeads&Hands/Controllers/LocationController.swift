//
//  PlanetController.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import UIKit

class LocationController: UIViewController {

    var location: Location!
    weak var delegate: NavigationDelegate?

    @IBOutlet private weak var planetName: UILabel!
    @IBOutlet private weak var residentsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        planetName.text = location.name

        residentsCollection.setCollectionViewLayout(makeLayout(), animated: false)
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

extension LocationController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: location.residents[indexPath.row]) else {
            return
        }
        delegate?.selectedCharacter(Int(url.lastPathComponent) ?? 1)
    }
}

extension LocationController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return location.residents.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResidentCell", for: indexPath) as? EpisodeCell else {
            return UICollectionViewCell()
        }
        cell.setup(with: location.residents[indexPath.row])
        return cell
    }
}
