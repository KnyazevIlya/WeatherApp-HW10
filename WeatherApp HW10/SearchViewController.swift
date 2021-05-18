//
//  SearchViewController.swift
//  WeatherApp HW10
//
//  Created by admin2 on 17.05.2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchField: UITextField!
    @IBOutlet var suggestionsTableView: UITableView!
    
    var delegate: coordinatesDelegate?
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        searchField.delegate = self
        suggestionsTableView.isHidden = true
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        if let text = searchField.text, !text.isEmpty {
            LocationManageer.shared.findLocations(with: text) { locations in
                DispatchQueue.main.async {
                    self.locations = locations
                    self.suggestionsTableView.reloadData()
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        suggestionsTableView.isHidden = false
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = suggestionsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coords = locations[indexPath.row].coordinates
        print(coords ?? "err occured")
        delegate?.setCoords(latitude: Double(coords?.latitude ?? 0),
                            longtitude: Double(coords?.longitude ?? 0),
                            name: locations[indexPath.row].title)
        suggestionsTableView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
}
