//
//  GCTableViewCell.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 10/28/17.
//

import UIKit

// MARK: Properties & Initializers

class GCTableViewCell: UITableViewCell {
    
    static let identifier = "GCTableViewCell"
    
    let titleLabel = UILabel()
    let accessoryLabel = UILabel()
    
    // MARK: Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.preservesSuperviewLayoutMargins = true
        self.contentView.preservesSuperviewLayoutMargins = true
        
        self.addTitleLabel()
        self.addAccessoryLabel()
        self.addConstraints()
    }
    
    convenience init(style: UITableViewCellStyle) {
        
        self.init(style: style, reuseIdentifier: GCTableViewCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        return nil
    }
}

// MARK: - Title Label

extension GCTableViewCell {
    
    fileprivate func addTitleLabel() {
        
        self.titleLabel.textAlignment = .left
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.titleLabel)
    }
}

// MARK: - Accessory Label

extension GCTableViewCell {
    
    fileprivate func addAccessoryLabel() {
        
        self.accessoryLabel.text = "+####"
        self.accessoryLabel.textColor = .lightGray
        self.accessoryLabel.textAlignment = .right
        self.accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.accessoryLabel)
    }
}

// MARK: - Constraints

extension GCTableViewCell {
    
    fileprivate func addConstraints() {
        
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.accessoryLabel.leftAnchor).isActive = true
        
        let textRect = self.accessoryLabel.textRect(forBounds: self.contentView.bounds, limitedToNumberOfLines: 0)
        
        self.accessoryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.accessoryLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.accessoryLabel.rightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.rightAnchor).isActive = true
        self.accessoryLabel.widthAnchor.constraint(equalToConstant: textRect.width).isActive = true
    }
}
