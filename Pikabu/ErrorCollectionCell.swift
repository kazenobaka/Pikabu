//
//  ErrorCollectionCell.swift
//  Pikabu
//
//  Created by Танчик on 23.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit

protocol ErrorCollectionCellDelegate: class {
    func didTouchButtonTryAgain(cell: ErrorCollectionCell)
}

class ErrorCollectionCell: UICollectionViewCell {
    
    weak var delegate: ErrorCollectionCellDelegate?

    private let stackViewError = UIStackView()
    private let errorLable = UILabel()
    private let buttonTryAgain = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTouchTryAgain(sender: UIButton) {
        delegate?.didTouchButtonTryAgain(cell: self)
    }
    
    private func setup() {
        stackViewError.translatesAutoresizingMaskIntoConstraints = false
        stackViewError.spacing = 16
        stackViewError.alignment = .center
        stackViewError.axis = .vertical
        
        contentView.addSubview(stackViewError)
        stackViewError.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackViewError.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        errorLable.translatesAutoresizingMaskIntoConstraints = false
        stackViewError.addArrangedSubview(errorLable)
        errorLable.text = "Ошибка сервера"
        
        buttonTryAgain.translatesAutoresizingMaskIntoConstraints = false
        stackViewError.addArrangedSubview(buttonTryAgain)
        buttonTryAgain.setTitle("Попробовать еще", for: .normal)
        buttonTryAgain.addTarget(self, action: #selector(didTouchTryAgain(sender:)), for: .touchUpInside)
    }
}
