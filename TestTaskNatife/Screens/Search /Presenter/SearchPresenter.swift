//
//  SearchPresenter.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 25.08.2022.
//

import UIKit
import MapKit


protocol SearchViewProtocol:MessageManager {
    func reloadData()
}

protocol SearchPresenterProtocol: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    init(view: SearchViewProtocol, delegate: ForecastDelegateProtocol, router: RouterProtocol)
    func setDelegate()
}

class SearchPresenter: NSObject, SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    weak var delegate: ForecastDelegateProtocol?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private var router: RouterProtocol
    private var searchQueue: DispatchQueue
    
    required init(view: SearchViewProtocol, delegate: ForecastDelegateProtocol, router: RouterProtocol) {
        self.view = view
        self.delegate = delegate
        self.router = router
        self.searchQueue = DispatchQueue(label: "com.search.queue", qos: .userInitiated)
    }
    
    func setDelegate() {
        searchCompleter.delegate = self
    }
    
    func popViewController() {
        return router.popViewController()
    }
    
    func setAtrributedString(text: String, fontSize: CGFloat) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: fontSize), .foregroundColor: UIColor.black])
    }
    
    func getLonLatFromRes(index: Int) {
        let searchRequest = MKLocalSearch.Request(completion: self.searchResults[index])
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let coordinate = response?.mapItems[0].placemark.coordinate {
                self.delegate?.setCoordinates(coordinates: coordinate)
                DispatchQueue.main.async {
                    self.popViewController()
                }
            }
        }
    }
    
}

extension SearchPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let attributedText = setAtrributedString(text: searchResults[indexPath.row].title, fontSize: 16.0)
        let secondAttributedText = setAtrributedString(text: searchResults[indexPath.row].subtitle, fontSize: 14.0)
        content.attributedText = attributedText
        content.secondaryAttributedText = secondAttributedText
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchQueue.async {
            self.getLonLatFromRes(index: indexPath.row)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}

extension SearchPresenter: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.queryFragment = searchText
    }
}

extension SearchPresenter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchQueue.async {
            self.searchResults = completer.results
            self.view?.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
