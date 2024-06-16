//
//  MoviesListViewController.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import UIKit

class MoviesListViewController: UIViewController {

    @IBOutlet weak var movieListTableView: UITableView!
    
    private var viewModel: MoviesViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        registerXIB()
        setupViewModel()
        fetchMovies()
    }
    
    fileprivate func registerXIB() {
        movieListTableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.className)
    }
    
    private func setupViewModel() {
        viewModel = MoviesViewModel()
        viewModel.didUpdateMovies = { [weak self] in
            DispatchQueue.main.async {
                self?.movieListTableView.reloadData()
            }
        }
    }
    
    private func fetchMovies() {
        viewModel.fetchMovies { [weak self] in
            DispatchQueue.main.async {
                self?.movieListTableView.reloadData()
            }
        }
    }
    
    @IBAction func filterMoviesPlayListAction(_ sender: UIButton) {
        let availableActions = viewModel.getPlaylists() + ["Add New Playlist"]
        presentActionSheet(forActions: availableActions, senderView: sender)
    }
    
    private func presentActionSheet(forActions actionList: [String], senderView: UIView) {
        let alertController = UIAlertController(title: "Select Playlist", message: nil, preferredStyle: .actionSheet)
        
        for actionTitle in actionList {
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] action in
                self?.sortSelectionHandler(action: action)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = senderView
        alertController.popoverPresentationController?.sourceRect = senderView.bounds
        
        present(alertController, animated: true)
    }
    
    private func sortSelectionHandler(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        if actionTitle == "Add New Playlist" {
            showAddPlaylistAlert()
        } else {
            viewModel.filterMovies(by: actionTitle)
        }
    }
    
    private func showAddPlaylistAlert() {
        let alert = UIAlertController(title: "New Playlist", message: "Enter a name for your new playlist", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let playlistName = alert.textFields?.first?.text, !playlistName.isEmpty else { return }
            self?.viewModel.addNewPlaylist(named: playlistName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        
        cell.addToPlaylistAction = { [weak self] in
            self?.showAddToPlaylistActionSheet(for: movie, senderView: cell.addToPlaylistButton)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func showAddToPlaylistActionSheet(for movie: Movie, senderView: UIView) {
        let availableActions = viewModel.getPlaylists() + ["Add New Playlist"]
        let alertController = UIAlertController(title: "Add to Playlist", message: nil, preferredStyle: .actionSheet)
        
        for actionTitle in availableActions {
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] action in
                self?.addMovieToPlaylistHandler(action: action, movie: movie)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = senderView
        alertController.popoverPresentationController?.sourceRect = senderView.bounds
        
        present(alertController, animated: true)
    }
    
    private func addMovieToPlaylistHandler(action: UIAlertAction, movie: Movie) {
        guard let actionTitle = action.title else { return }
        if actionTitle == "Add New Playlist" {
            showAddPlaylistAlert()
        } else {
            viewModel.addToPlaylist(movie: movie, playlistName: actionTitle) {
                self.movieListTableView.reloadData()
            }
        }
    }
}
