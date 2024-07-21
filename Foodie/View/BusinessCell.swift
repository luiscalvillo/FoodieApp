//
//  BusinessCell.swift
//  Foodie
//
//  Created by Luis Calvillo on 6/18/24.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    static let reuseID = "BusinessCell"
    
    let nameLabel = BusinessCell.createLabel(font: .boldSystemFont(ofSize: 18))
    let addressLabel = BusinessCell.createLabel()
    let distanceLabel = BusinessCell.createLabel()
    let ratingLabel = BusinessCell.createLabel()
    
    let businessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCellView()
        setupInformationStackView()
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    private static func createLabel(font: UIFont = UIFont.systemFont(ofSize: 14)) -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.font = font
        return label
    }
    
    private func setupCellView() {
        contentView.addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        NSLayoutConstraint.activate([
            businessImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        stackView.addArrangedSubview(businessImageView)
        stackView.addArrangedSubview(informationStackView)
        cellView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupInformationStackView() {
        informationStackView.addArrangedSubview(nameLabel)
        informationStackView.addArrangedSubview(ratingLabel)
        informationStackView.addArrangedSubview(addressLabel)
        informationStackView.addArrangedSubview(distanceLabel)
    }
}
