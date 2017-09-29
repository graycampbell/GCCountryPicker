//
//  GCCountryPickerViewController.swift
//  GCCountryPicker
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit

// MARK: Properties & Initializers

public final class GCCountryPickerViewController: UITableViewController {
    
    // MARK: Properties
    
    public var delegate: GCCountryPickerDelegate?
    
    fileprivate var countries = [GCCountry]()
    fileprivate var searchController: UISearchController!
    
    // MARK: Initializers
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    public init(navigationTitle: String) {
        
        super.init(style: .plain)
        
        self.navigationItem.title = navigationTitle
    }
    
    public convenience init() {
        
        self.init(navigationTitle: "Country")
    }
}

// MARK: - View

public extension GCCountryPickerViewController {
    
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
        
        self.searchController = UISearchController(searchResultsController: nil)
        
        self.searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.definesPresentationContext = true
    }
    
    // MARK: Targets
    
    @objc func cancel(barButtonItem: UIBarButtonItem) {
        
        self.delegate?.countryPickerDidCancel(self)
    }
}

extension GCCountryPickerViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        
    }
}

// MARK: - Table View

extension GCCountryPickerViewController {
    
    fileprivate func configureTableView() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
}

// MARK: - UITableViewDelegate

public extension GCCountryPickerViewController {
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries.count
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.countryPicker(self, didSelectCountry: self.countries[indexPath.row])
    }
}

// MARK: - UITableViewDataSource

public extension GCCountryPickerViewController {
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.countries[indexPath.row].localizedDisplayName
        
        return cell
    }
}
