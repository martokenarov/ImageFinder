//
//  Photos.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import SwiftyJSON

private var statusKey: String = "stat"
private var photosKey: String = "photos"
private var photoKey: String = "photo"
private var pageKey: String = "page"
private var pagesKey: String = "pages"
private var perpagesKey: String = "perpages"
private var totalKey: String = "total"

struct Photos {
    var photos:[Photo]
    var status: String = "NOK"
}

extension Photos {
    init?(with json: JSON) {
        let photosResponse = json[photosKey]
        
        guard let photosArr = photosResponse[photoKey].array, let stat = json[statusKey].string else {
            return nil
        }
        
        self.status = stat
        
        self.photos = photosArr.compactMap({
            return Photo(with: $0)
        })
    }
}
