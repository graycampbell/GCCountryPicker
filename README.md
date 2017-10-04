[![Release](https://img.shields.io/github/release/graycampbell/GCCountryPicker.svg)](https://github.com/graycampbell/GCCountryPicker/releases/latest)
[![CocoaPods](https://img.shields.io/cocoapods/v/GCCountryPicker.svg)](https://cocoapods.org/pods/GCCountryPicker)
[![CocoaDocs](https://img.shields.io/cocoapods/metrics/doc-percent/GCCountryPicker.svg)](http://cocoadocs.org/docsets/GCCountryPicker)
[![Codacy Code Quality]()]()
[![Swift 4 Compatible](https://img.shields.io/badge/Swift_4-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
![Platform](https://img.shields.io/cocoapods/p/GCCountryPicker.svg?style=flat)
[![License](https://img.shields.io/cocoapods/l/GCCountryPicker.svg)](https://github.com/graycampbell/GCCountryPicker/blob/master/LICENSE)

### CocoaPods

```
pod 'GCCountryPicker'
```

### Implementation

1. Add GCCountryPicker to your file's import statements.

    ```
    import GCCountryPicker
    ```

2. Create an instance of GCCountryPickerViewController.

    ```
    let countryPickerViewController = GCCountryPickerViewController()
    ```

3. Set the delegate and the navigation title.

    ```
    countryPickerViewController.delegate = self
    countryPickerViewController.navigationItem.title = "Countries"
    ```

4. Implement GCCountryPickerDelegate.

### License

GCCountryPicker is available under the MIT license. See the [LICENSE](https://github.com/graycampbell/GCCalendar/blob/master/LICENSE) file for more info.
