//
//  SavedPostsController.swift
//  Pikabu
//
//  Created by Танчик on 20.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit

class SavedPostsController: UIViewController {
    
    enum State {
        case data
        case empty
    }
    
    var arrayPosts: [Post] = []
    var state: State = .data
    var service = PostsSarvice()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .brown
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func reloadData(){
        arrayPosts = service.getCachedPosts()
        
        if arrayPosts.isEmpty {
            state = .empty
        } else {
            state = .data
        }
        collectionView.reloadData()
    }
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        collectionView.register(EmptyCollectionCell.self, forCellWithReuseIdentifier: "EmptyCollectionCell")
        
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
extension SavedPostsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PostCollectionViewCellDelegate {
    func didTouchSaveButton(cell: PostCollectionViewCell) {
        //Do nothing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch state {
            case .data :
                return CGSize(width: collectionView.bounds.width - 32.0, height: 1000)
            case .empty:
                var size = view.safeAreaLayoutGuide.layoutFrame.size
                size.height -= 16.0
                return size
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
            case .data :
                return arrayPosts.count
            case .empty:
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
                cell.configure(posts: post, mode:.remove)
                return cell
            case .empty:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionCell", for: indexPath)
                return cell
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = arrayPosts[indexPath.row]
        let controller = PostViewController(id: post.id)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTouchRemoveButton(cell: PostCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let post = arrayPosts[indexPath.row]
        service.removePost(post: post)
        reloadData()
    }
}

