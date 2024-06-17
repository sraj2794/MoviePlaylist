//
//  PlaylistBottomSheetViewController.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

class PlaylistBottomSheetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: PlaylistBottomSheetDelegate?
    var playlists: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerXIB()
    }
    
    fileprivate func registerXIB() {
        let nib = UINib(nibName: "PlaylistCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PlaylistCell")
    }
}

extension PlaylistBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as? PlaylistCell else {
            fatalError("Unable to dequeue PlaylistCell")
        }
        if indexPath.row < playlists.count {
            cell.textLabel?.text = playlists[indexPath.row]
        } else {
            cell.textLabel?.text = "+ Add New Playlist"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < playlists.count {
            delegate?.didSelectPlaylist(playlists[indexPath.row])
        } else {
            delegate?.didTapAddNewPlaylist()
        }
    }
}

class PlaylistCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
