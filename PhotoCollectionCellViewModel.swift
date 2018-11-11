//
//  PhotoCollectionCellViewModel.swift
//  ImageFinder
//
//  Created by Marto Kenarov on 9.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

class PhotoCollectionCellViewModel {
    var title: String
    var imageURL: String
    var contentURL: String
    
    init(_ title: String, imageURL: String, contentURL: String) {
        self.title = title
        self.imageURL = imageURL
        self.contentURL = contentURL
    }
}
