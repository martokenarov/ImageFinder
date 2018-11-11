//
//  Photos.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import SwiftyJSON


private var webSearchUrlKey: String = "webSearchUrl"
private var valueKey: String = "value"

struct PhotosResponse {
    var photos:[Photo]
}

extension PhotosResponse {
    init?(with json: JSON) {
        
        guard let photosArr = json[valueKey].array else {
            return nil
        }
        
        self.photos = photosArr.compactMap({
            return Photo(with: $0)
        })
    }
}
