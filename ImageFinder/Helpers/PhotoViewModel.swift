//
//  PhotoViewModel.swift
//  ImageFinder
//
//  Created by Marto Kenarov on 11.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

class PhotoViewModel {
    public var title: String
    public var imageURL: String
    
    init(_ title: String, imageURL: String) {
        self.title = title
        self.imageURL = imageURL
    }
}
