//
//  EmptyController.swift
//  Pikabu
//
//  Created by Танчик on 24.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit

class EmptyCollectionCell: UICollectionViewCell {
    
    private let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Список пуст"
        contentView.addSubview(messageLabel)
        messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
