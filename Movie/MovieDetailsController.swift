import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var movieId: Int?
    var movie: Movie?
    var cast: [Actor] = []
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let releaseDateLabel = UILabel()
    let ratingLabel = UILabel()
    let genreLabel = UILabel()
    let runtimeLabel = UILabel()
    let overviewLabel = UILabel()
    let watchTrailerButton = UIButton()
    let castCollectionView: UICollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        view.backgroundColor = .black
        
        setupViews()
        
        if let movieId = movieId {
            fetchMovieDetails(movieId: movieId)
            fetchMovieCast(movieId: movieId)
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 150)
        
        self.castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.register(CastCell.self, forCellWithReuseIdentifier: "CastCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Настройка ScrollView и StackView
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        contentView.axis = .vertical
        contentView.spacing = 15
        contentView.alignment = .fill
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        // Добавление UI элементов в StackView
        setupPosterImageView()
        setupTextLabels() // Здесь настраиваем и добавляем текстовые элементы
        setupWatchTrailerButton()
        setupCastCollectionView()
    }

    
    private func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        contentView.addArrangedSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(view.frame.width * 0.6)
        }
    }
    
    private func setupTextLabels() {
        // Настройка titleLabel (заголовок фильма)
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        contentView.addArrangedSubview(titleLabel)
        
        // Настройка releaseDateLabel
        releaseDateLabel.font = .systemFont(ofSize: 16)
        releaseDateLabel.textColor = .lightGray
        contentView.addArrangedSubview(releaseDateLabel)
        
        // Настройка ratingLabel
        ratingLabel.font = .systemFont(ofSize: 16)
        ratingLabel.textColor = .orange
        contentView.addArrangedSubview(ratingLabel)
        
        // Настройка genreLabel
        genreLabel.font = .systemFont(ofSize: 16)
        genreLabel.textColor = .lightGray
        genreLabel.numberOfLines = 0
        contentView.addArrangedSubview(genreLabel)
        
        // Настройка runtimeLabel
        runtimeLabel.font = .systemFont(ofSize: 16)
        runtimeLabel.textColor = .lightGray
        contentView.addArrangedSubview(runtimeLabel)
        
        // Настройка overviewLabel
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        contentView.addArrangedSubview(overviewLabel)
        
        // Добавляем отступы между текстовыми элементами для лучшей читаемости
        contentView.setCustomSpacing(10, after: releaseDateLabel)
        contentView.setCustomSpacing(10, after: ratingLabel)
        contentView.setCustomSpacing(10, after: genreLabel)
        contentView.setCustomSpacing(10, after: runtimeLabel)
        contentView.setCustomSpacing(20, after: overviewLabel)
    }

    
    private func setupWatchTrailerButton() {
        watchTrailerButton.setTitle("Смотреть трейлер", for: .normal)
        watchTrailerButton.backgroundColor = .systemBlue
        watchTrailerButton.layer.cornerRadius = 10
        watchTrailerButton.addTarget(self, action: #selector(watchTrailerTapped), for: .touchUpInside)
        contentView.addArrangedSubview(watchTrailerButton)
        
        watchTrailerButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupCastCollectionView() {
        castCollectionView.backgroundColor = .clear
        contentView.addArrangedSubview(castCollectionView)
        
        castCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
    
    private func fetchMovieDetails(movieId: Int) {
        NetworkManager.shared.fetchMovieDetails(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    self?.updateUI(with: movie)
                case .failure(let error):
                    print("Error fetching movie details: \(error)")
                }
            }
        }
    }
    
    private func fetchMovieCast(movieId: Int) {
        NetworkManager.shared.fetchMovieCast(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cast):
                    self?.cast = cast
                    self?.castCollectionView.reloadData()
                case .failure(let error):
                    print("Error fetching movie cast: \(error)")
                }
            }
        }
    }
    
    private func updateUI(with movie: Movie) {
        self.movie = movie
        titleLabel.text = movie.title
        releaseDateLabel.text = "Дата выхода: \(movie.releaseDate)"
        ratingLabel.text = "Рейтинг: \(movie.voteAverage)/10"
        genreLabel.text = "Жанры: \(movie.genres?.map { $0.name }.joined(separator: ", ") ?? "Неизвестно")"
        runtimeLabel.text = "Продолжительность: \(movie.runtime ?? 0) мин."
        overviewLabel.text = movie.overview
        
        if let posterPath = movie.posterPath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
            loadImage(from: imageURL)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actor = cast[indexPath.item]
        let actorDetailsVC = ActorDetailsViewController()
        actorDetailsVC.actorId = actor.id
        navigationController?.pushViewController(actorDetailsVC, animated: true)
    }

    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.posterImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    @objc private func watchTrailerTapped() {
        guard let movieTitle = movie?.title else { return }
        let searchQuery = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://www.youtube.com/results?search_query=\(searchQuery)+trailer") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCell
        let actor = cast[indexPath.item]
        cell.configure(with: actor)
        return cell
    }
}

