//
//  URLBuilder.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

// https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=08a2998d597918ddde1ecb42be6a4952&format=json&nojsoncallback=1&auth_token=72157701832813331-cc9948eb548675d8&api_sig=09f8b11918e8fd88892b375052972785

private let baseURL = "https://api.flickr.com/services/rest/?"
private let method = "flickr.photos.getRecent"
private let apiKey = "e3089e96135b1bbfbce78ee719212f75"
private let perPage = "100"
private let jsonFormat = "json"
private let nojsoncallback = "1"

class URLBuilder {
    static func getRecentPhotosURL() -> String {
        return baseURL + "method=\(method)&" + "api_key=\(apiKey)&" + "per_page=\(perPage)&" + "format=\(jsonFormat)&" + "nojsoncallback=\(nojsoncallback)"
    }
    
    static func getURLImage(for photo: Photo) -> String {
        // http://farm4.static.flickr.com/3221/2658147888_826edc8465.jpg
        //        http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        //        or
        //        http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg"
    }
}
