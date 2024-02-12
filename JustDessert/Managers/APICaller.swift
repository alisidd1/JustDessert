//
//  APICaller.swift
//  JustDessert
//
//  Created by Ali Siddiqui on 4/2/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let baseUrl = "https://www.asndigital.com/services/just-desserts/api/meal"
    }
    
    /// Private init
    private init() {}
    
    private var fetched = false
    public private(set) var recipes: [Recipe] = []

    typealias RecipeCompletionBlock = ([Recipe]) -> Void
    private var whenReadyBlocks: [RecipeCompletionBlock] = []
    
    /// Fetch all recipes
    /// - Parameter completion: Callback
    public func getRecipes(completion: RecipeCompletionBlock?) {
        
        guard recipes.isEmpty else {
            completion?(recipes)
            return
        }
        
        guard !fetched else {
            if let completion = completion {
                whenReadyBlocks.append(completion)
            }
            return
        }
        
        guard let url = URL(string: Constants.baseUrl + "/?key=afraz123") else {
            completion?([])
            return
        }
        fetched = true
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                completion?([])
                return
            }
            
            do {
                let result = try JSONDecoder().decode(RecipeListResponse.self, from: data)
                self?.recipes = result.data
                completion?(result.data)
                self?.whenReadyBlocks.forEach { block in
                    block(result.data)
                }
                self?.whenReadyBlocks.removeAll()
            }
            catch {
                print(error)
                completion?([])
            }
        }
        task.resume()
    }
    
    /// Fetch details for a single recipe
    /// - Parameters:
    ///   - model: Recipe to fetch for
    ///   - completion: Callback
    func getRecipeDetails(model: Recipe, completion: @escaping (RecipeInfo?) -> Void ) {
        guard let url = URL(string: Constants.baseUrl + "/?key=afraz123&id=\(model.id)") else {
            completion(nil)
            return
        }
     
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ApiRecipeResponse.self, from: data)
                guard let info = result.data.first else {
                    completion(nil)
                    return
                }
                completion(info)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
