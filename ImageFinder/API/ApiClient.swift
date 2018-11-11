//
//  ApiClient.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

typealias GetPhotosResult = Result<PhotosResponse, FlickrBrowserError>
typealias GetPhotosCompletion = (GetPhotosResult) -> Void

typealias Parameters = Dictionary<String, AnyObject>

protocol ApiClient {
    func getPhotos(by url: String, completion: @escaping GetPhotosCompletion)
}
