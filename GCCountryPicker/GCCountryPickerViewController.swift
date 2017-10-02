//
//  GCCountryPickerViewController.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit

// MARK: Properties & Initializers

/// The GCCountryPickerViewController class defines a view controller containing a country picker interface.

public final class GCCountryPickerViewController: UITableViewController {
    
    // MARK: Properties
    
    /// The object that acts as the delegate of the country picker view controller.
    
    public var delegate: GCCountryPickerDelegate?
    
    fileprivate var countries = [GCCountry]()
    fileprivate var searchController: UISearchController!
    fileprivate var searchResultsController = GCSearchResultsController()
    
    // MARK: Initializers
    
    /// Initializes and returns a newly allocated country picker view controller object.
    ///
    /// - Returns: An initialized country picker view controller object.
    
    public convenience init() {
        
        self.init(style: .plain)
        
        self.navigationItem.title = "Country"
    }
}

// MARK: - View

extension GCCountryPickerViewController {
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadCountries()
        self.configureNavigationBar()
        self.configureTableView()
    }
}

// MARK: - Countries

extension GCCountryPickerViewController {
    
    fileprivate func loadCountries() {
        
        if let url = Bundle(for: GCCountryPickerViewController.self).url(forResource: "CountryCodes", withExtension: "plist") {
            
            if let countryCodes = NSArray(contentsOf: url) as? [String] {

                for countryCode in countryCodes {

                    let country = GCCountry(countryCode: countryCode)
                    
                    self.countries.append(country)
                }

                self.countries.sort(by: { $0.localizedDisplayName < $1.localizedDisplayName })
            }
        }
    }
}

// MARK: - Navigation Bar

extension GCCountryPickerViewController {
    
    fileprivate func configureNavigationBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel(barButtonItem:)))
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self.searchResultsController
        self.searchResultsController.delegate = self
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.definesPresentationContext = true
    }
    
    @objc func cancel(barButtonItem: UIBarButtonItem) {
        
        self.delegate?.countryPickerDidCancel(self)
    }
}

// MARK: - UISearchResultsUpdating

extension GCCountryPickerViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        var searchResults = [GCCountry]()
        
        if let searchText = searchController.searchBar.text?.localizedLowercase.replacingOccurrences(of: "(^\\s+)|(\\s+$)", with: "", options: .regularExpression, range: nil) {
            
            if !searchText.isEmpty {
                
                searchResults = self.countries.filter { $0.localizedDisplayName.localizedLowercase.range(of: "\\b\(searchText)", options: .regularExpression, range: nil, locale: .current) != nil }
            }
        }
        
        self.searchResultsController.searchResults = searchResults
    }
}

// MARK: - GCSearchResultsDelegate

extension GCCountryPickerViewController: GCSearchResultsDelegate {
    
    func searchResultsController(_ searchResultsController: GCSearchResultsController, didSelectSearchResult searchResult: GCCountry) {
        
        self.delegate?.countryPicker(self, didSelectCountry: searchResult)
    }
}

// MARK: - Table View

extension GCCountryPickerViewController {
    
    fileprivate func configureTableView() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
}

// MARK: - UITableViewDelegate

extension GCCountryPickerViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries.count
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.countryPicker(self, didSelectCountry: self.countries[indexPath.row])
    }
}

// MARK: - UITableViewDataSource

extension GCCountryPickerViewController {
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.countries[indexPath.row].localizedDisplayName
        
        return cell
    }
}
