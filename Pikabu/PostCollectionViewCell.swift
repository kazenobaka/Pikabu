//
//  PostCollectionViewCell.swift
//  Pikabu
//
//  Created by Танчик on 20.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit
import Kingfisher

protocol PostCollectionViewCellDelegate: class {
    func didTouchSaveButton(cell: PostCollectionViewCell)
    func didTouchRemoveButton(cell: PostCollectionViewCell) 
}

class PostCollectionViewCell: UICollectionViewCell {
    enum Mode {
        case save
        case remove
    }
    weak var delegate: PostCollectionViewCellDelegate?
    
    private var widthConstraint: NSLayoutConstraint!

    var width: CGFloat? {
        didSet {
            guard let width = width else {
                return
            }
            widthConstraint.isActive = true
            widthConstraint.constant = width
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @objc private func didTouchSave(sender: UIButton){
        switch mode {
        case .save:
            delegate?.didTouchSaveButton(cell: self)
        case .remove:
            delegate?.didTouchRemoveButton(cell: self)
        }
    }
    
    private var mode: Mode = .save
    private let stackView = UIStackView()
    private let saveButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let image = UIImageView()
    
    func configure(posts: Post, mode: Mode) {
        self.mode = mode
        switch mode {
        case .save:
            saveButton.setImage(UIImage(named: "save"), for: .normal)
        case .remove:
            saveButton.setImage(UIImage(named: "remove"), for: .normal)
        }
        titleLabel.text = posts.title
        bodyLabel.text = posts.body
        if posts.images?.first == nil {
            image.isHidden = true
        } else {
            image.isHidden = false
            image.kf.setImage(with: posts.images?.first)
        }
    }
    
    private func setup() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.shadowRadius = 15.0
        contentView.layer.cornerRadius = 24.0
        
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 340)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(named: "save"), for: .normal)
        stackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(didTouchSave(sender:)), for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.numberOfLines = 0
        stackView.addArrangedSubview(bodyLabel)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(image)
        image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 16 / 9)
            .isActive = true
        image.contentMode = .scaleAspectFit
        image.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }

}
