//
//  SearchResult.swift
//  sample
//
//  Created by VINH HOANG on 23/07/2022.
//

import Foundation


class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult: Codable, CustomStringConvertible {
    var description: String {
        return "\nResult - Kind: \(kind ?? "None")  - Name: \(name), Artist Name: \(artistName ?? "None"), currency: \(currency), trackPrice \(trackPrice), artworkUrl60 \(imageSmall),  imageLarge \(imageLarge)"
    }
    var trackPrice: Double? = 0.0
    var currency: String = String.empty
    var imageSmall = String.empty
    var imageLarge = String.empty
    var kind: String? = String.empty
    var artistName: String? = String.empty
    var trackName: String? = String.empty
    
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    
    var name: String {
        return trackName ?? collectionName ?? String.empty
    }
    
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? String.empty
    }
    
    var price: Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        } else {
            return String.empty
        }
    }
    
    var type: String {
      let kind = self.kind ?? "audiobook"
      switch kind {
      case "album": return "Album"
      case "audiobook": return "Audio Book"
      case "book": return "Book"
      case "ebook": return "E-Book"
      case "feature-movie": return "Movie"
      case "music-video": return "Music Video"
      case "podcast": return "Podcast"
      case "software": return "App"
      case "song": return "Song"
      case "tv-episode": return "TV Episode"
      default: break
      }
      return "Unknown"
    }
    
    var artist: String {
        return artistName ?? String.empty
    }
    
    
    enum CodingKeys: String, CodingKey {
      case imageSmall = "artworkUrl60"
      case imageLarge = "artworkUrl100"
      case itemGenre = "primaryGenreName"
      case bookGenre = "genres"
      case itemPrice = "price"
      case kind, artistName, currency
      case trackName, trackPrice, trackViewUrl
      case collectionName, collectionViewUrl, collectionPrice
    }
}

extension String {
    static let empty = ""
}


func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
