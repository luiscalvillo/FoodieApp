//
//  BusinessCell.swift
//  Foodie
//
//  Created by Luis Calvillo on 6/18/24.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    static let reuseID = "BusinessCell"
    var businessImageView = UIImageView()
    var nameLabel = UILabel()
    var addressLabel = UILabel()
    var distanceLabel =  UILabel()
    var ratingLabel = UILabel()
    
    var cellView = UIView()
    
    var stackView = UIStackView()
    var informationStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCellView()
        setupInformationStackView()
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellView() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellView)
        
        contentView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        businessImageView.layer.cornerRadius = 25
        businessImageView.clipsToBounds = true
        businessImageView.translatesAutoresizingMaskIntoConstraints = false
        businessImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        businessImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        stackView = UIStackView(arrangedSubviews: [businessImageView, informationStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cellView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupInformationStackView() {
    
        informationStackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel, distanceLabel])
        informationStackView.axis = .vertical
        informationStackView.distribution = .equalSpacing
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textColor = .label
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        ratingLabel.textColor = .label
        addressLabel.textColor = .label
        distanceLabel.textColor = .label
       
        stackView.addSubview(informationStackView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
