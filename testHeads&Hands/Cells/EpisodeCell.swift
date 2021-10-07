//
//  EpisodeCell.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 07.10.2021.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    @IBOutlet private weak var episodeNumber: UILabel!

    func setup(with number: String) {
        if let url = URL(string: number) {
            let humanReadable = url.lastPathComponent
            episodeNumber.text = humanReadable
        } else {
            episodeNumber.text = number
        }
    }
}
