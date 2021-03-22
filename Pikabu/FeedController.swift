//
//  FeedController.swift
//  Pikabu
//
//  Created by Танчик on 20.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit

class FeedController: UIViewController {
    
    enum State {
        case data
        case error
        case loading
    }
    
    var state: State = .loading
    var arrayPosts = [Post]()
    let postsService = PostsSarvice()
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        setup()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    func fetchPosts() {
        postsService.getPostsFeed { [weak self] posts in
            if posts == nil {
                self?.arrayPosts = []
                self?.state = .error
            } else {
                self?.state = .data
                self?.arrayPosts = posts ?? []
            }
            self?.collectionView.reloadData()
        }
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        collectionView.register(LoadingCollectionCell.self, forCellWithReuseIdentifier: "LoadingCollectionCell")
        collectionView.register(ErrorCollectionCell.self, forCellWithReuseIdentifier: "ErrorCollectionCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 16.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
    }
    
}

extension FeedController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch state {
        case .data :
            return CGSize(width: collectionView.bounds.width - 32.0, height: 1000)
        case .error, .loading:
            var size = view.safeAreaLayoutGuide.layoutFrame.size
            size.height -= 16.0
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
            case .data :
                return arrayPosts.count
            case .error, .loading:
                return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch state {
            case .data :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
                cell.delegate = self
                
                cell.width = collectionView.bounds.width - 32
                let post = arrayPosts[indexPath.row]
                
                let mode: PostCollectionViewCell.Mode
                if postsService.getCachedPost(byId: post.id) == nil {
                    mode = .save
                } else {
                    mode = .remove
                }
                cell.configure(posts: post, mode: mode)
                return cell
            case .loading:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionCell", for: indexPath)
                return cell
            case .error:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCollectionCell", for: indexPath) as! ErrorCollectionCell
                cell.delegate = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = arrayPosts[indexPath.row]
        let controller = PostViewController(id: post.id)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedController: ErrorCollectionCellDelegate, PostCollectionViewCellDelegate {
    
    func didTouchRemoveButton(cell: PostCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let post = arrayPosts[indexPath.row]
        postsService.removePost(post: post)
        collectionView.reloadData()
    }
    
    func didTouchButtonTryAgain(cell: ErrorCollectionCell) {
        state = .loading
        collectionView.reloadData()
        fetchPosts()
    }
    func didTouchSaveButton(cell: PostCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let post = arrayPosts[indexPath.row]
        postsService.savePost(post: post)
        collectionView.reloadData()
    }
    
}

