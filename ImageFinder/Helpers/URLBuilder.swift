//
//  URLBuilder.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

// https://api.cognitive.microsoft.com/bing/v5.0/images

private let baseURL = "https://api.cognitive.microsoft.com/bing/v5.0/images/search?"
private let q = "q"

class URLBuilder {
    static func searchPhotosURL(_ query: String) -> String? {
        if let escapedString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return baseURL + "q=\(escapedString)"
        }
        
        return nil
    }
}
