//
//  PlaylistCell.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 20/06/24.
//

import UIKit

class PlaylistCell: UITableViewCell {

    @IBOutlet weak var playListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
