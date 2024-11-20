import UIKit
import SnapKit

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let bioLabel = UILabel() // Биография пользователя
    private let plannedMoviesLabel = UILabel() // Новый заголовок для раздела фильмов
    private var plannedMoviesCollectionView: UICollectionView!
    private var plannedMovies: [Movie] = [] // Список запланированных фильмов
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black // Темная тема
        setupProfileImageView()
        setupNameLabel()
        setupBioLabel()
        setupPlannedMoviesLabel()
        setupCollectionView()
        loadProfileImage()
    }
    
    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderColor = UIColor.orange.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.isUserInteractionEnabled = true
        profileImageView.image = UIImage(systemName: "person.circle") // Placeholder
        
        // Gesture recognizer для изменения фотографии профиля
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePhoto))
        profileImageView.addGestureRecognizer(tapGesture)
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Almaz Beisenov"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBioLabel() {
        bioLabel.text = "Люблю кино, занимаюсь iOS разработкой, фанат новых технологий."
        bioLabel.font = UIFont.systemFont(ofSize: 14)
        bioLabel.textColor = .lightGray
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        
        view.addSubview(bioLabel)
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupPlannedMoviesLabel() {
        plannedMoviesLabel.text = "Запланированные фильмы"
        plannedMoviesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        plannedMoviesLabel.textColor = .orange // Оранжевый акцент
        
        view.addSubview(plannedMoviesLabel)
        plannedMoviesLabel.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        plannedMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        plannedMoviesCollectionView.backgroundColor = .clear
        plannedMoviesCollectionView.delegate = self
        plannedMoviesCollectionView.dataSource = self
        plannedMoviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        view.addSubview(plannedMoviesCollectionView)
        plannedMoviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(plannedMoviesLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
    }
    
    @objc private func changeProfilePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
           let image = UIImage(data: imageData) {
            profileImageView.image = image
        }
    }
    
    private func saveProfileImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            saveProfileImage(selectedImage)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plannedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = plannedMovies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = plannedMovies[indexPath.item]
        let movieDetailsVC = MovieDetailsViewController()
        movieDetailsVC.movieId = movie.id
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}


