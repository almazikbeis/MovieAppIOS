import UIKit
import SnapKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var tableView: UITableView!
    var movies: [Movie] = [] // Все фильмы
    var filteredMovies: [Movie] = [] // Отфильтрованные фильмы
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = .black
        setupSearchController()
        setupTableView()
        fetchMovies()
    }
    
    private func setupNavigationBar() {
        title = "Поиск"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.orange,
            .font: UIFont.boldSystemFont(ofSize: 30)
        ]
        navigationController?.navigationBar.barTintColor = .black
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск фильмов"
        searchController.searchBar.tintColor = .orange
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchMovies() {
        NetworkManager.shared.fetchMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.filteredMovies = movies // Изначально показываем все фильмы
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = filteredMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = filteredMovies[indexPath.row]
        let detailsVC = MovieDetailsViewController()
        detailsVC.movieId = movie.id
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredMovies = movies // Показываем все фильмы, если строка поиска пуста
            tableView.reloadData()
            return
        }
        
        filteredMovies = movies.filter { movie in
            movie.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

