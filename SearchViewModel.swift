//
//  SearchViewModel.swift
//  ImageFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    public var photoCells = Bindable([PhotoCollectionCellViewModel]())
    public var onShowError: ((_ message: String) -> Void)?
    public var onNothingFound: ((_ message: String) -> Void)?
    public var onCancel: (() -> Void)?
    
    private var apiClient = AlamofireApiClient()
    
    var showLoadingHud: Bindable = Bindable(false)
    
    public func getPhotos(_ query: String) {
        showLoadingHud.value = true
        
        if let url = URLBuilder.searchPhotosURL(query) {
            apiClient.getPhotos(by: url) { [weak self] result  in
                debugPrint(result)
                
                self?.showLoadingHud.value = false
                
                switch result {
                case .success(let payload):
                    if payload.photos.count > 0 {
                        self?.populateCells(photos: payload.photos)
                    } else {
                        self?.photoCells = Bindable([PhotoCollectionCellViewModel]())
                        self?.onNothingFound?("Nothing found for this query. Please try again!")
                    }
                case.failure(let error):
                    
                    if let error = error {
                        self?.onShowError?(error.localizedDescription)
                    } else {
                        self?.onShowError?("Something went wrong!")
                    }
                }
            }
        } else {
            self.onShowError?("Something went wrong!")
        }
    }
    
    private func populateCells(photos: [Photo]) {
        self.photoCells.value = photos.map({ (photo) -> PhotoCollectionCellViewModel in
            return PhotoCollectionCellViewModel(photo.name, imageURL: photo.thumbnailUrl, contentURL: photo.contentUrl)
            
        })
    }
}
