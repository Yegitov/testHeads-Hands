//
//  EpisodeController.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import UIKit

class EpisodeController: UIViewController {

    private var episode: Episode!

    init(episode: Episode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
