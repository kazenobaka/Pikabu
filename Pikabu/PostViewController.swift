//
//  PostViewController.swift
//  Pikabu
//
//  Created by Танчик on 24.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit
import Kingfisher

class PostViewController: UIViewController {
    
    var arrayPosts = [Post]()
    let postsService = PostsSarvice()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let image = UIImageView()
    var id: Int
    var post: Post?
    
    init(id:Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setup()
        postsService.getPost(id: id) { [weak self] post in
            self?.post = post
            self?.configure()
        }
    }
    
    func configure() {
        guard let post = post else {
            return
        }
                
        titleLabel.text = post.title
        bodyLabel.text = post.body
        image.kf.setImage(with: post.images?.first)
        
        if postsService.getCachedPost(byId: id) == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "save"), style: .plain, target: self, action: #selector(didTouchSaveButton(sender:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "remove"), style: .plain, target: self, action: #selector(didTouchSaveButton(sender:)))
        }
    }

    @objc private func didTouchSaveButton(sender: UIButton) {
        guard let post = post else {
            return
        }
        if postsService.getCachedPost(byId: id) == nil {
            postsService.savePost(post: post)
        } else {
            postsService.removePost(post: post)
        }
        configure()
    }
    
    private func setup(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16)
        ])
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bodyLabel)
        bodyLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            bodyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            bodyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 16)
        ])
        
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            image.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            image.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor,constant: 16),
            image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 16 / 9)

        ])
        
    }
    
}

    
    

