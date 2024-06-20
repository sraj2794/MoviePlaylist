//
//  PlaylistBottomSheetViewController.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import UIKit

protocol PlaylistBottomSheetDelegate: AnyObject {
    func didSelectPlaylist(named: String)
    func didAddNewPlaylist(named: String)
}

class PlaylistBottomSheetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var playlists: [String] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
                updatePreferredContentSize()
            }
        }
    }
    
    weak var delegate: PlaylistBottomSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerXIB()
        updatePreferredContentSize()
    }
    
    private func registerXIB() {
        tableView.register(UINib(nibName: "PlaylistCell", bundle: nil), forCellReuseIdentifier: "PlaylistCell")
    }
    private func updatePreferredContentSize() {
          let topInset: CGFloat = 10
          let bottomInset: CGFloat = 10
          let rowHeight: CGFloat = 44 // Assuming a fixed height for rows
          
          let contentHeight = CGFloat(playlists.isEmpty ? 1 : playlists.count + 1) * rowHeight + topInset + bottomInset
          let maxHeight: CGFloat = 300
          let height = min(contentHeight, maxHeight)
          
          preferredContentSize = CGSize(width: view.frame.width, height: height)
      }

}

extension PlaylistBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.isEmpty ? 1 : playlists.count + 1 // Additional cell for "+ Add a playlist"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as? PlaylistCell else {
            return UITableViewCell()
        }
        
        if indexPath.row < playlists.count {
            cell.playListLabel.text = playlists[indexPath.row]
        } else {
            cell.playListLabel.text = "+ Add a playlist"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < playlists.count {
            let playlistName = playlists[indexPath.row]
            delegate?.didSelectPlaylist(named: playlistName)
        } else {
            showAddPlaylistAlert()
        }
    }
   
    private func showAddPlaylistAlert() {
        let alert = UIAlertController(title: "New Playlist", message: "Enter a name for your new playlist", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let playlistName = alert.textFields?.first?.text, !playlistName.isEmpty else { return }
            self?.delegate?.didAddNewPlaylist(named: playlistName)
            DispatchQueue.main.async{
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
