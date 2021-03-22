//
//  PostsService.swift
//  Pikabu
//
//  Created by Танчик on 20.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit

class PostsSarvice {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    
    func getPostsFeed(completion: @escaping ([Post]?) -> Void) {
        
        let url = URL(string:
            "https://pikabu.ru/page/interview/mobile-app/test-api/feed.php")!
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, request, error) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let posts = try jsonDecoder.decode([Post].self, from: data)
                completion(posts)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func getPost(id: Int, completion: @escaping (Post?) -> Void) {
        
        let url = URL(string: "https://pikabu.ru/page/interview/mobile-app/test-api/story.php?id=\(id)")!
        
        var request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, request, error) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let post = try jsonDecoder.decode(Post.self, from: data)
                completion(post)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func savePost(post: Post) {
        var posts = getCachedPosts()
        posts = posts.filter {
            $0.id != post.id
        }
        posts.insert(post, at: 0)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(posts){
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "postsSave")
        }
    }
    
    func getCachedPosts() -> [Post] {
        let defaults = UserDefaults.standard
        guard let postSave = defaults.object(forKey: "postsSave") as? Data else {
            return []
        }
        
        let decoder = JSONDecoder()
        guard let loadedPosts = try? decoder.decode([Post].self, from: postSave) else {
            return []
        }
        return loadedPosts
    }
    
    func getCachedPost(byId: Int) -> Post? {
        let posts = getCachedPosts()
        return posts.first(where: { $0.id == byId })
    }
    func removePost(post: Post) {
        var posts = getCachedPosts()
        posts.removeAll(where:  { $0.id == post.id })
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(posts){
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "postsSave")
        }
    }
}
