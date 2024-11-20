import UIKit
import SnapKit

class CastCell: UICollectionViewCell {
    
    private let actorImageView = UIImageView()
    private let actorNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Настройка изображения актера
        actorImageView.contentMode = .scaleAspectFill
        actorImageView.clipsToBounds = true
        actorImageView.layer.cornerRadius = 8
        contentView.addSubview(actorImageView)
        actorImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.frame.width)
        }
        
        // Настройка имени актера
        actorNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        actorNameLabel.textAlignment = .center
        actorNameLabel.numberOfLines = 2
        actorNameLabel.textColor = .white
        contentView.addSubview(actorNameLabel)
        actorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(actorImageView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(5)
        }
    }

    func configure(with actor: Actor) {
        actorNameLabel.text = actor.name
        
        if let profilePath = actor.profilePath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)")!
            loadImage(from: imageURL)
        } else {
            actorImageView.image = UIImage(systemName: "person.crop.circle") // Placeholder
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.actorImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

