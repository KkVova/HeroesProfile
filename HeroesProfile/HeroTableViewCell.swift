//
//  HeroTableViewCell.swift
//  HOTSProfiles
//
//  Created by Vova Badyaev on 06.06.2022.
//

import UIKit


class HeroTableViewCell: UITableViewCell {
    static let id = "HeroCell"

    var heroModel: HeroModel? {
        didSet {
            guard let name = heroModel?.name,
                  let iconData = heroModel?.icon else { return }

            nameLabel.text = name
            heroIconView.image = UIImage(data: iconData) ?? UIImage(systemName: "person.crop.circle.fill")
        }
    }

    private let heroIconView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.borderWidth = 2
        img.layer.borderColor = UIColor.red.cgColor
        return img
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(self.heroIconView)
        contentView.addSubview(self.nameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        heroIconView.layer.cornerRadius = (contentView.frame.height - 10) / 2
        heroIconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        heroIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        heroIconView.heightAnchor.constraint(equalToConstant: contentView.frame.height - 10).isActive = true
        heroIconView.widthAnchor.constraint(equalToConstant: contentView.frame.height - 10).isActive = true

        nameLabel.leftAnchor.constraint(equalTo: heroIconView.rightAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
