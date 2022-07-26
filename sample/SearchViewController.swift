//
//  ViewController.swift
//  sample
//
//  Created by VINH HOANG on 23/07/2022.
//

import UIKit

class SearchViewController: UIViewController {
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "loadingCell"
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil), forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        tableView.register(UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil), forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
       // tableView.rowHeight = UITableView.automaticDimension
        let cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    }
    
    // MARK: - Helper Methods
    func iTuneURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func showNetworkError()  {
        let alert = UIAlertController(title: "Whoop...",
                                      message: "There was an error accessing the iTUnes Store." + "Please try again.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
   
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            isLoading = true
            tableView.reloadData()
            
            hasSearched = true
            searchResults = []
            
            let queue = DispatchQueue.global()
            let url = iTuneURL(searchText: searchBar.text!)

            queue.async { [self] in
                if let data = self.performStoreRequest(with: url) {
                    searchResults = parse(data: data)
                    searchResults.sort(by: <)
                    print("DONE")
                    DispatchQueue.main.async {
                        isLoading = false
                        tableView.reloadData()
                    }
                    
                }
            }
           
           
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        }
        return searchResults.count == 0 ? 1 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.isEmpty || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else
    
        if searchResults.count == 0 {
           return tableView.dequeueReusableCell(
              withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
              for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(
              withIdentifier: TableView.CellIdentifiers.searchResultCell,
              for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            if searchResult.artist.isEmpty {
                cell.artistNameLabel.text = "Unknown"
            } else {
                cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
            }
            return cell
        }
    }
    

    
}
