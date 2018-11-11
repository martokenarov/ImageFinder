//
//  PhotoViewController.swift
//  ImageFinder
//
//  Created by Marto Kenarov on 11.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    private var imageLoader = ImageCacheLoader()
    
    public var photoViewModel: PhotoViewModel?
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.topItem?.title = photoViewModel?.title
        
        if let imageURL = photoViewModel?.imageURL {
            imageLoader.obtainImageWithPath(imagePath: imageURL) { (image) in
                self.imageView.image = image
            }
        } else {
            self.imageView.image = UIImage(named: "noImageIcon")
        }
        
        customizeUI()
    }
    
    @IBAction func backAction(sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoViewController {
    private func customizeUI() {
        self.view.isOpaque = false
        self.view.backgroundColor = UIColor.white
        self.view.alpha = 1.0
        
        self.navigationBar.backgroundColor = UIColor.white
        self.imageView.backgroundColor = UIColor.white
        self.imageView.layer.cornerRadius = 3.0
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
