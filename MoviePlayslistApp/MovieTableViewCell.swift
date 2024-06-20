//
//  MovieTableViewCell.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addToPlaylistButton: UIButton!
    
    var addToPlaylistAction: (() -> Void)?
    
    @IBAction func addToPlaylistAction(_ sender: UIButton) {
        addToPlaylistAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with movie: Movie, playlists: [String]) {
        movieNameLabel.text = movie.title
        ratingLabel.text = "\(movie.voteAverage)"
        //playlistNameLabel.text = movie.playlistName ?? "No Playlist"
        playlistNameLabel.text = playlists.joined(separator: ", ")
        // Check if posterPath exists and construct URL
        if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            // Load image from URL
            movieImageView.load(url: url)
        } else {
            // Handle case where posterPath is nil or empty
            movieImageView.image = UIImage(named: "placeholder_image")
        }
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
