//
//  APIManager.swift
//  Contributeurs
//
//  Created by Antoine El Samra on 28/09/2023.
//

import UIKit

enum DataError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}

class APIManager {
    static let shared = APIManager()
    public init() { }
    
// @escaping is used here, because this is a background task.
// If you write a print statemnet after the dataTask completes, i.e. after resume(), then it will execute beforehand.
// This happens because it is time consuming task and can not be implemented on main thread.
//@escaping captures data in memeory.

    func loadProfiles(page: Int, perPage: Int, owner: String, repo: String, completion: @escaping ([JSONProfile]) -> Void) {
        guard let url = URL(string:
                                "https://api.github.com/repos/\(owner)/\(repo)/contributors?page=\(page)&per_page=\(perPage)") else {
            fatalError("Invalid URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                fatalError("Error retrieving data: \(error?.localizedDescription ?? "Unknown error") params: \(owner), \(repo), \(page), \(perPage)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let responses = try decoder.decode([JSONProfile].self, from: data)
                completion(responses)
            } catch {
                print(String(describing: error))
                fatalError("Error decoding data: \(error.localizedDescription) params: \(owner), \(repo), \(page), \(perPage)")
            }
        }
        
        task.resume()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
