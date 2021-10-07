//
//  ViewController.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import UIKit

class CharacterController: UIViewController {

    private var characters: [Character]!
    weak var delegate: NavigationDelegate?

    @IBOutlet private weak var characterCollection: UICollectionView!

    init(characters: [Character]) {
        self.characters = characters
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCollection() {
        characterCollection.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let contr = navigationController as? NavigationDelegate else {
            fatalError("Navigation controller doesn't conform to navigation delegate")
        }
        delegate = contr

        characterCollection.setCollectionViewLayout(makeLayout(), animated: false)
    }

    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.0,
                                                     leading: 2.0,
                                                     bottom: 2.0,
                                                     trailing: 2.0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension CharacterController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedCharacter(characters[indexPath.row].id)
    }
}

extension CharacterController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }


}
