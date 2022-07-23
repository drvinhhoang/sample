//
//  ViewController.swift
//  sample
//
//  Created by VINH HOANG on 23/07/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [SearchResult]()
    let cellIdentifier = "SearchResultCell"
    var hasSearched = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        print("tableview contentInset \( tableView.contentInset) , searchBar bounds y: \(searchBar.bounds)" )
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hasSearched = true
        searchResults = []
        if searchBar.text?.lowercased() != "justin" {
            
            for i in 0...2 {
                let searchResult = SearchResult()
                searchResult.name = "Fake result \(i) for "
                searchResult.artistName = searchBar.text!
                searchResults.append(searchResult)
            }
        }
        tableView.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        }
        return searchResults.count == 0 ? 1 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.isEmpty {
            return nil
        } else {
            return indexPath
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = createCell(indexPath: indexPath)
        if searchResults.count == 0 {
            cell.title.text = "Nothing found"
            cell.detail.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.setUpCell(with: searchResult)
        }
        return cell
    }
    
    
    func createCell(indexPath: IndexPath) -> SearchCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        return cell
    }
    
}
