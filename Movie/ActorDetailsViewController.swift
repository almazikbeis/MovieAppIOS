import UIKit
import SnapKit

class ActorDetailsViewController: UIViewController {
    
    var actorId: Int?
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let biographyLabel = UILabel()
    let scrollView = UIScrollView()
    let contentView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        
        if let actorId = actorId {
            fetchActorDetails(actorId: actorId)
        }
    }
    
    private func setupViews() {
        // Настройка прокрутки
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        contentView.axis = .vertical
        contentView.spacing = 15
        contentView.alignment = .center
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        // Настройка изображения профиля (аватарки)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 75 // Половина размера для круглой аватарки
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.image = UIImage(systemName: "person.circle") // Заменить на placeholder, если нет фото
        contentView.addArrangedSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(150)
        }
        
        // Настройка имени актера
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        contentView.addArrangedSubview(nameLabel)
        
        // Настройка биографии
        biographyLabel.font = .systemFont(ofSize: 16)
        biographyLabel.textColor = .lightGray
        biographyLabel.numberOfLines = 0
        contentView.addArrangedSubview(biographyLabel)
        
        biographyLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func fetchActorDetails(actorId: Int) {
        NetworkManager.shared.fetchActorDetails(actorId: actorId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let actor):
                    self?.updateUI(with: actor)
                case .failure(let error):
                    print("Error fetching actor details: \(error)")
                }
            }
        }
    }
    
    private func updateUI(with actor: Actor) {
        nameLabel.text = actor.name
        biographyLabel.text = actor.biography
        
        // Загрузка аватарки
        if let profilePath = actor.profilePath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")!
            loadImage(from: imageURL)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.profileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

