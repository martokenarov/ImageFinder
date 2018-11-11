//
//  Photo.swift
//  FlickrFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation
import SwiftyJSON

//{
//    "name": "15+ Abstract Art Paintings",
//    "datePublished": "2016-08-25T17:56:00Z",
//    "homePageUrl": null,
//    "contentSize": "801093 B",
//    "hostPageDisplayUrl": "https://www.freecreatives.com/fine-art/printable-abstract-art...",
//    "width": 2560,
//    "height": 1440,
//    "thumbnail": {
//        "width": 474,
//        "height": 266
//    },
//    "imageInsightsToken": "ccid_f718LMAn*mid_1B92C9C02C14A7817C5CD086B9C0F4DAB5A63D7D*simid_608003965479354474*thid_OIP.f718LMAne2p41F63eZqY5gHaEK",
//    "insightsSourcesSummary": null,
//    "imageId": "1B92C9C02C14A7817C5CD086B9C0F4DAB5A63D7D",
//    "accentColor": "170648",
//    "webSearchUrl": "https://www.bing.com/images/search?view=detailv2&FORM=OIIRPO&q=abstract+art&id=1B92C9C02C14A7817C5CD086B9C0F4DAB5A63D7D&simid=608003965479354474",
//    "thumbnailUrl": "https://tse2.mm.bing.net/th?id=OIP.f718LMAne2p41F63eZqY5gHaEK&pid=Api",
//    "encodingFormat": "jpeg",
//    "contentUrl": "https://images.freecreatives.com/wp-content/uploads/2015/03/Lady-abstract-paintings.jpg"
//}

private let idKey = "imageId"
private let nameKey = "name";
private let datePublishedKey = "datePublished"
private let hostPageDisplayUrlKey = "hostPageDisplayUrl"
private let thumbnailUrlKey = "thumbnailUrl"
private let encodingFormatKey = "encodingFormat"
private let contentUrlKey = "contentUrl"

struct Photo {
    var id: String
    var name: String
    var datePublished: String
    var hostPageDisplayUrl: String
    var thumbnailUrl: String
    var encodingFormat: String
    var contentUrl: String
}

extension Photo {
    init?(with json:JSON) {
        guard let id = json[idKey].string, let name = json[nameKey].string, let datePublished = json[datePublishedKey].string, let hostPageDisplayUrl = json[hostPageDisplayUrlKey].string, let thumbnailUrl = json[thumbnailUrlKey].string, let encodingFormat = json[encodingFormatKey].string, let contentUrl = json[contentUrlKey].string else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.datePublished = datePublished
        self.hostPageDisplayUrl = hostPageDisplayUrl
        self.thumbnailUrl = thumbnailUrl
        self.encodingFormat = encodingFormat
        
        self.contentUrl = contentUrl
    }
}
