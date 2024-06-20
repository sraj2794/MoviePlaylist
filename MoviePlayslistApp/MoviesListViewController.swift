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
    private var selectedMovie: Movie?

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
        showBottomSheet()
    }
    
    private func showBottomSheet() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "PlaylistBottomSheetViewController") as? PlaylistBottomSheetViewController else { return }
        bottomSheetVC.delegate = self
        bottomSheetVC.playlists = viewModel.getPlaylists()

        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom { context in
                let topInset: CGFloat = 10
                let bottomInset: CGFloat = 10
                let rowHeight: CGFloat = 44
                let contentHeight = CGFloat(bottomSheetVC.playlists.isEmpty ? 1 : bottomSheetVC.playlists.count + 1) * rowHeight + topInset + bottomInset
                let maxHeight: CGFloat = 300
                return min(contentHeight, maxHeight)
            }]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        present(bottomSheetVC, animated: true)
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
        cell.configure(with: movie, playlists: viewModel.getPlaylists())
        
        cell.addToPlaylistAction = { [weak self] in
            self?.selectedMovie = movie
            self?.showBottomSheet()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MoviesListViewController: PlaylistBottomSheetDelegate {
    func didSelectPlaylist(named: String) {
        guard let movie = selectedMovie else { return }
        viewModel.addToPlaylist(movie: movie, playlistName: named) { [weak self] in
            self?.selectedMovie = nil
            self?.fetchMovies()
        }
    }
    
    func didAddNewPlaylist(named: String) {
        viewModel.addNewPlaylist(named: named)
        let bottomSheetVC = presentedViewController as? PlaylistBottomSheetViewController
        bottomSheetVC?.playlists = viewModel.getPlaylists()
    }
}
