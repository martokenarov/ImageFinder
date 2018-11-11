//
//  SearchViewController.swift
//  ImageFinder
//
//  Created by Marto Kenarov on 8.11.18.
//  Copyright © 2018 Marto Kenarov. All rights reserved.
//

import UIKit
import PureLayout
import PKHUD

class SearchViewController: UIViewController {
    
    private var viewModel: SearchViewModel = SearchViewModel()
    private var imageLoader = ImageCacheLoader()
    
    let collectionMargin = CGFloat(10)
    let itemSpacing = CGFloat(10)
    var itemHeight = CGFloat(0)
    
    var itemWidth = CGFloat(0)
    
    private struct Storyboard {
        static let CellIdentifier = "PhotoCellIdentifier"
    }
    
    var currentItem = 0 {
        didSet {
            page = currentItem + 1
        }
    }
    var page = 1
    
    let transition = BubbleTransition()
    
    var sourceCell: UICollectionViewCell?
    var indexPath: IndexPath?
    
    private var collectionView: UICollectionView!
    
    private var searchBar: UISearchBar!
    private var searchButton: UIButton!
    private var resultsTable: UITableView!
    
    private let searchButtonHeight: CGFloat = 60
    private let searchButtonWidth: CGFloat = 200
    
    private let searchBarStartingAlpha: CGFloat = 0
    private let searchButtonStartingAlpha: CGFloat = 1
    private let tableStartingAlpha: CGFloat = 0
    private let searchBarEndingAlpha: CGFloat = 1
    private let searchButtonEndingAlpha: CGFloat = 0
    private let tableEndingAlpha: CGFloat = 1
    private let collectionViewStartingAlpha: CGFloat = 0
    private let collectionViewEndingAlpha: CGFloat = 1
    
    private let searchButtonStartingCornerRadius: CGFloat = 20
    private let searchButtonEndingCornerRadius: CGFloat = 0
    
    private var searchBarTop = false
    private var searchButtonWidthConstraint: NSLayoutConstraint?
    private var searchButtonEdgeConstraint: NSLayoutConstraint?
    private var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
//        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        bindViewModel()
    }
    
    func setupViews() {
        setupSearchBar()
        setupSearchButton()
        setupCollectionView()
        view.setNeedsUpdateConstraints()
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar.newAutoLayout()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.alpha = searchBarStartingAlpha
        view.addSubview(searchBar)
    }
    
    func setupSearchButton() {
        searchButton = UIButton(type: .custom)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(self.searchClicked), for: .touchUpInside)
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .blue
        searchButton.layer.cornerRadius = searchButtonStartingCornerRadius
        view.addSubview(searchButton)
    }
    
    func setupResultsTable() {
        resultsTable = UITableView.newAutoLayout()
        resultsTable.alpha = tableStartingAlpha
        view.addSubview(resultsTable)
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width  / 2.0 - collectionMargin
        debugPrint("\(itemWidth)")
        itemHeight = itemWidth
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Storyboard.CellIdentifier)
//        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: Storyboard.CellIdentifier)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alpha = collectionViewStartingAlpha
        view.addSubview(collectionView)
    }
 
    // MARK: - Layout
    override func updateViewConstraints() {
        if !didSetupConstraints {
            searchBar.autoAlignAxis(toSuperviewAxis: .vertical)
            searchBar.autoMatch(.width, to: .width, of: view)
            searchBar.autoPinEdge(toSuperviewEdge: .top)
            
            searchButton.autoSetDimension(.height, toSize: searchButtonHeight)
            searchButton.autoAlignAxis(toSuperviewAxis: .vertical)
            
            collectionView.autoAlignAxis(toSuperviewAxis: .vertical)
            collectionView.autoPinEdge(toSuperviewEdge: .leading)
            collectionView.autoPinEdge(toSuperviewEdge: .trailing)
            collectionView.autoPinEdge(toSuperviewEdge: .bottom)
            collectionView.autoPinEdge(.top, to: .bottom, of: searchBar)
            
            didSetupConstraints = true
        }
        
        searchButtonWidthConstraint?.autoRemove()
        searchButtonEdgeConstraint?.autoRemove()
        
        if searchBarTop {
            searchButtonWidthConstraint = searchButton.autoMatch(.width, to: .width, of: self.view)
            searchButtonEdgeConstraint = searchButton.autoPinEdge(toSuperviewEdge: .top)
        } else {
            searchButtonWidthConstraint = searchButton.autoSetDimension(.width, toSize: searchButtonWidth)
            searchButtonEdgeConstraint = searchButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - User Interaction
    
    @objc func searchClicked(sender: UIButton!) {
        showSearchBar(searchBar: searchBar)
    }
    
    // MARK: - Helpers
    
    func showSearchBar(searchBar: UISearchBar) {
        searchBarTop = true
        bindViewModel()
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        searchBar.becomeFirstResponder()
                        self.view.layoutIfNeeded()
        }, completion: { finished in
            UIView.animate(withDuration: 0.2,
                           animations: {
                            searchBar.alpha = self.searchBarEndingAlpha
                            self.searchButton.alpha = self.searchButtonEndingAlpha
                            self.collectionView.alpha = self.collectionViewEndingAlpha
                            self.searchButton.layer.cornerRadius = self.searchButtonEndingCornerRadius
            }
            )
        }
        )
    }
    
    func dismissSearchBar(searchBar: UISearchBar) {
        searchBarTop = false
        viewModel.photoCells = Bindable([PhotoCollectionCellViewModel]())
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        searchBar.alpha = self.searchBarStartingAlpha
                        self.collectionView.alpha = self.collectionViewStartingAlpha
                        self.searchButton.alpha = self.searchButtonStartingAlpha
                        self.searchButton.layer.cornerRadius = self.searchButtonStartingCornerRadius
                        
                        self.collectionView.reloadData()
        }, completion:  { finished in
            self.view.setNeedsUpdateConstraints()
            self.view.updateConstraintsIfNeeded()
            UIView.animate(withDuration: 0.3,
                           animations: {
                            searchBar.resignFirstResponder()
                            self.view.layoutIfNeeded()
            }
            )
        }
        )
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        dismissSearchBar(searchBar: searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoCells.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as? PhotoCollectionViewCell
        
        if let cell = cell {
            
            let cellViewModel = self.viewModel.photoCells.value[indexPath.row]
            
            cell.viewModel = cellViewModel
            
            imageLoader.obtainImageWithPath(imagePath: cellViewModel.imageURL) { (image) in
                // Before assigning the image, check whether the current cell is visible
                cell.image.image = image
            }
        }
        
        return cell!
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) != nil else {
            fatalError("no cell at \(indexPath)")
        }
        
        self.indexPath = indexPath
        self.performSegue(withIdentifier: "ShowPhotoSegue", sender: collectionView.cellForItem(at: indexPath))
    }
}

extension SearchViewController: UIViewControllerTransitioningDelegate {
    // MARK: UIViewControllerTransitioningDelegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PhotoViewController {
            
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            
            if let indexPath = self.indexPath {
                let cellModel = self.viewModel.photoCells.value[indexPath.row]
                controller.photoViewModel = PhotoViewModel(cellModel.title, imageURL: cellModel.contentURL)
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        
        if let indexPath = self.indexPath, let selectedCell = collectionView?.cellForItem(at: indexPath) {
            
            transition.startingPoint = selectedCell.center
            transition.bubbleColor = selectedCell.backgroundColor!
        }
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        
        if let indexPath = self.indexPath, let selectedCell = collectionView?.cellForItem(at: indexPath) {
            
            transition.startingPoint = selectedCell.center
            transition.bubbleColor = selectedCell.backgroundColor!
            
        }
        
        return transition
    }
}

extension SearchViewController {
    func bindViewModel() {
        viewModel.photoCells.bindAndFire { [weak self] cells in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.showLoadingHud.bind() { visible in
            
            DispatchQueue.main.async {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide(true)
            }
        }
        
        viewModel.onShowError = { [weak self] message in
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        viewModel.onNothingFound = { [weak self] message in
            let alert = UIAlertController.init(title: "Sorry", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "OK", style: .destructive, handler: { [weak self] (action) in
                
                DispatchQueue.main.async {
                    self?.searchBar.becomeFirstResponder()
                    self?.view.layoutIfNeeded()
                    self?.bindViewModel()
                }
            }))
            
            DispatchQueue.main.async {
                
                self?.collectionView.reloadData()
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        
        print(query)
        viewModel.getPhotos(query)
    }
}
