//
//  GCSearchResultsController.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 10/1/17.
//

import UIKit

// MARK: Properties & Initializers

/// The GCSearchResultsController class defines a view controller containing a search results interface.

class GCSearchResultsController: UITableViewController {
    
    // MARK: Properties
    
    /// The object that acts as the delegate of the search results view controller.
    
    var delegate: GCSearchResultsDelegate?
    
    var searchResults = [GCCountry]() {
        
        didSet {
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - View

extension GCSearchResultsController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureTableView()
    }
}

// MARK: - UISearchBarDelegate

extension GCSearchResultsController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if !self.searchResults.isEmpty {
            
            let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.5)
            
            self.tableView.scrollRectToVisible(rect, animated: true)
        }
    }
}

// MARK: - Table View

extension GCSearchResultsController {
    
    fileprivate func configureTableView() {
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
}

// MARK: - UITableViewDelegate

extension GCSearchResultsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.searchResultsController(self, didSelectSearchResult: self.searchResults[indexPath.row])
    }
}

// MARK: - UITableViewDataSource

extension GCSearchResultsController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row].localizedDisplayName
        
        return cell
    }
}
