//
//  LoadingCollection Cell.swift
//  Pikabu
//
//  Created by Танчик on 22.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit

class LoadingCollectionCell: UICollectionViewCell {
    
    let  activityView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.startAnimating()
        contentView.addSubview(activityView)
        activityView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityView.startAnimating()
    }
}

