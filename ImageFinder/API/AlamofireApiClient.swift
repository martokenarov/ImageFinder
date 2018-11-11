//
//  AlamofireApiClient.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

class AlamofireApiClient: ApiClient {
    func getPhotos(by url: String, completion: @escaping (GetPhotosResult) -> Void) {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject], let apiKey = dict["BingSearchAPIKey"] as? String else {
            completion(.failure(FlickrBrowserError(title: nil, description: "Something wentwrong", code: .unknownError)))
            return
        }
        
         let headers = [
            "Content-Type": "application/json",
            "Ocp-Apim-Subscription-Key": apiKey
         ]
        
        Alamofire.request(url, method: .get, headers: headers).validate().responseSwiftyJSON { responseJSON in
            switch responseJSON.result {
            case .success(let json):
                if let photos = PhotosResponse(with: json) {
                    completion(.success(payload: photos))
                } else {
                    completion(.failure(FlickrBrowserError(title: nil, description: "Error parsing JSON", code: .invalidResponse)))
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion(.failure(FlickrBrowserError(title: nil, description: error.localizedDescription, code: .invalidRequest)))
            }
        }
    }
}
