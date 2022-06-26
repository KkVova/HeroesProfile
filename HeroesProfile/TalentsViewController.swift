//
//  TalentsViewController.swift
//  HeroesProfile
//
//  Created by Vova Badyaev on 10.06.2022.
//

import UIKit


class TalentsViewController: UIViewController {
    private let manager: HeroesManagerProtocol
    private let hero: HeroModel

    init(manager: HeroesManagerProtocol, forHero hero: HeroModel) {
        self.hero = hero
        self.manager = manager

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
}
