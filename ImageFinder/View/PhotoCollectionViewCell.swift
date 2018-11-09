//
//  PhotoCollectionViewCell.swift
//  ImageFinder
//
//  Created by Marto Kenarov on 9.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var viewModel: PhotoCollectionCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    private func bindViewModel() {
        title.text = viewModel?.title
    }
}
