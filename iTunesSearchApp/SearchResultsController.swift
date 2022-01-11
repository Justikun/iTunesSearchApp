//
//  SearchResultsController.swift
//  iTunesSearchApp
//
//  Created by Justin Lowry on 1/4/22.
//

import Foundation

class SearchResultsController {
    static func searchResultsForSearchTerm(searchTerm: String, completion: @escaping (_ results: [SearchResult]?) -> Void) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)"
        guard let url = URL(string: urlString) else { return }
        fetchJSONAtURL(url: url) { json in
            guard let j = json,
                  let allResults = j["results"] as? [[String : AnyObject]] else { return }
            let searchResults = allResults.compactMap({ return SearchResult(json: $0) })
            completion(searchResults)
            
            
        }
    }
    
    static func fetchJSONAtURL(url: URL, completion: @escaping (_ json: [String: AnyObject]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {( data, response, error) in
            // Check Error
            if let e = error {
                print("URLSession Error", e, e.localizedDescription)
                return completion(nil)
            } else if let d = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String: AnyObject] {
                        completion(json)
                    }
                } catch let jsonError {
                    print("Error decoding JSON", jsonError)
                }
            }
        }
        task.resume()
    }
}
