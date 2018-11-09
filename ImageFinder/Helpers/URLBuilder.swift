//
//  URLBuilder.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

// https://www.googleapis.com/customsearch/v1?q=Queen&imgSize=medium&imgType=photo&key={YOUR_API_KEY}

private let baseURL = "https://www.googleapis.com/customsearch/v1?"
private let q = "q"
private let apiKey = "e3089e96135b1bbfbce78ee719212f75"
private let perPage = "100"
private let jsonFormat = "json"
private let nojsoncallback = "1"

class URLBuilder {
    static func searchPhotosURL(_ query: String) -> String {
        return baseURL + "q=\(query)&" + "api_key=\(apiKey)&" + "per_page=\(perPage)&" + "format=\(jsonFormat)&" + "nojsoncallback=\(nojsoncallback)"
    }
    
    static func getURLImage(for photo: Photo) -> String {
        // http://farm4.static.flickr.com/3221/2658147888_826edc8465.jpg
        //        http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        //        or
        //        http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg"
    }
}
