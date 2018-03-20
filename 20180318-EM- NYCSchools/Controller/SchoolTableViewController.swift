//
//  SchoolTableViewController.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/19/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//


import UIKit
import Alamofire

// decided not to inherit from UITableViewController because this UIViewController allow for more UI customization in the future
class SchoolTableViewController: UIViewController, UISearchBarDelegate{
    
    // MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Variables
    let cellId = String(describing: SchoolTableViewCell.self)
    let searchController = UISearchController(searchResultsController: nil)
    var schools = [School]()
    var filteredSchools = [School]()
    
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        requestSchools()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Methods
    
    // Method to setup views
    func setupViews() {
        // Setup the Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Schools"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        // Setup Navigation Bar
        navigationController?.navigationBar.topItem?.title = "Schools"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // Api call to get schools
    func requestSchools(){
        activityIndicator.startAnimating()
        Service.shared.getSchools { (schools, error) in
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    Alert.showBasic(title: "Error", message: "error getting schools", vc: self!)
                    self?.activityIndicator.stopAnimating()
                }
                return
            } else {
                if let schools = schools {
                    DispatchQueue.main.async { [weak self] in
                        self?.schools = schools
                        self?.tableView.reloadData()
                        self?.activityIndicator.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        Alert.showBasic(title: "Not Found", message: "no schools found", vc: self!)
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
        
    }
    // MARK:- Filter methods
    func filterContentForSearchText(searchText: String) {
        filteredSchools = schools.filter({( school : School) -> Bool in
            return school.school_name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!isSearchBarEmpty())
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SchoolTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSchools.count
        }
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SchoolTableViewCell
        let school: School
        if isFiltering() {
            school = filteredSchools[indexPath.row]
        } else {
            school = schools[indexPath.row]
        }
        cell.nameLabel.text = school.school_name
        cell.addressLabel.text = school.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schoolViewController = SchoolViewController()
        let school: School
        if isFiltering() {
            school = filteredSchools[indexPath.row]
        } else {
            school = schools[indexPath.row]
        }
        schoolViewController.school = school
        navigationController?.pushViewController(schoolViewController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension SchoolTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

