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
    
    var cellView = UIView()
    
    var stackView = UIStackView()
    var informationStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        businessImageView.layer.cornerRadius = businessImageView.frame.size.width/2
        businessImageView.clipsToBounds = true
        
        cellView.addSubview(stackView)
        stackView = UIStackView(arrangedSubviews: [businessImageView, informationStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:  cellView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
        // info stackview
        
        informationStackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel, distanceLabel])
        informationStackView.axis = .vertical
        informationStackView.distribution = .fillEqually
        
        stackView.addSubview(stackView)
        
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            informationStackView.topAnchor.constraint(equalTo:  stackView.topAnchor),
            informationStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
