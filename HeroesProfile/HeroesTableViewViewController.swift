//
//  HeroesTableViewViewController.swift
//  HOTSProfiles
//
//  Created by Vova Badyaev on 04.06.2022.
//

import Combine
import UIKit


class HeroesTableViewViewController: UITableViewController {
    private let interactor: HeroListInteractorProtocol
    private var heroes: [HeroModel] = []

    private var cancellables = Set<AnyCancellable>()

    init(interactor: HeroListInteractorProtocol) {
        self.interactor = interactor

        super.init(style: .plain)

        interactor.heroes
            .receive(on: DispatchQueue.global())
            .sink { [unowned self] hero in
                DispatchQueue.main.async {
                    self.heroes.append(hero)
                    self.heroes.sort(by: { $0.shortName < $1.shortName })
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)

        interactor.loadList()
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
        return heroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.id, for: indexPath) as? HeroTableViewCell else {
            fatalError("Unexpected row \(indexPath.row) in section \(indexPath.section)")
        }

        cell.heroModel = heroes[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SomeViewController()
        controller.title = heroes[indexPath.row].name
        navigationController?.pushViewController(controller, animated: true)
    }
}
