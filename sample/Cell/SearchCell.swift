//
//  SearchCell.swift
//  sample
//
//  Created by VINH HOANG on 23/07/2022.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpCell(with searchResult: SearchResult) {
        self.title.text = searchResult.name
        self.detail.text = searchResult.artistName
    }
    
}
