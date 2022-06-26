//
//  HeroesTableViewViewController.swift
//  HeroesProfile
//
//  Created by Vova Badyaev on 04.06.2022.
//

import UIKit


class HeroesTableViewViewController: UITableViewController {
    private let manager: HeroesManagerProtocol

    init(manager: HeroesManagerProtocol) {
        self.manager = manager

        super.init(style: .plain)


        DispatchQueue.global().async {
            manager.loadHeroesList { error in
                DispatchQueue.main.async {
                    if let err = error {
                        print(err.localizedDescription)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(HeroTableViewCell.self,
                                forCellReuseIdentifier: HeroTableViewCell.id)
    }
}

extension HeroesTableViewViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.heroesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.id,
                                                       for: indexPath) as? HeroTableViewCell else {
            fatalError("Unexpected row \(indexPath.row) in section \(indexPath.section)")
        }

        cell.heroModel = manager.heroesList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TalentsViewController(manager: manager, forHero: manager.heroesList[indexPath.row])
        controller.title = manager.heroesList[indexPath.row].name
        navigationController?.pushViewController(controller, animated: true)
    }
}
