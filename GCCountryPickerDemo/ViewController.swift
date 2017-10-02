//
//  ViewController.swift
//  GCCountryPickerDemo
//
//  Created by Gray Campbell on 9/28/17.
//

import UIKit
import GCCountryPicker

// MARK: Properties & Initializers

class ViewController: UIViewController {
    
    // MARK: Properties
    
    fileprivate var country: GCCountry!
}

// MARK: - View

extension ViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureNavigationBar()
    }
}

// MARK: - Navigation Bar

extension ViewController {
    
    fileprivate func configureNavigationBar() {
        
        self.navigationItem.title = Locale.current.localizedString(forRegionCode: "US")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change Country", style: .plain, target: self, action: #selector(showCountryPicker(barButtonItem:)))
    }
    
    @objc func showCountryPicker(barButtonItem: UIBarButtonItem) {
        
        let countryPickerViewController = GCCountryPickerViewController()
        
        countryPickerViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: countryPickerViewController)
        
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - GCCountryPickerDelegate

extension ViewController: GCCountryPickerDelegate {
    
    func countryPickerDidCancel(_ countryPicker: GCCountryPickerViewController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func countryPicker(_ countryPicker: GCCountryPickerViewController, didSelectCountry country: GCCountry) {
        
        self.country = country
        self.navigationItem.title = country.localizedDisplayName
        
        self.dismiss(animated: true, completion: nil)
    }
}
