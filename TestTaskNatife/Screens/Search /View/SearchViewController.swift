//
//  SearchViewController.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 25.08.2022.
//

import UIKit
import MapKit

class SearchViewController: BaseViewController<SearchPresenterProtocol> {
    var searchBar:UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setDelegates()
        setSearchBar(width: self.view.frame.width * 0.8)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setSearchBar(width: setWidthDependsOnOrientation())
    }
    
    private func setSearchBar(width: CGFloat) {
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width * 0.8, height: 30))
        searchBar.delegate = presenter
        let rightBarButtonItem = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setWidthDependsOnOrientation()->CGFloat {
        switch UIDevice.current.orientation.isLandscape {
        case true:
            return self.view.frame.height * 0.8
        case false:
            return self.view.frame.width * 0.8
        }
    }
    
    private func setDelegates() {
        self.searchTableView.delegate = presenter
        self.searchTableView.dataSource = presenter
        presenter.setDelegate()
    }

}

extension SearchViewController: SearchViewProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }
}
