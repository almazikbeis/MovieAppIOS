import UIKit

class ActorCell: UICollectionViewCell {
    let nameLabel = UILabel()
    let profileImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
        contentView.addSubview(profileImageView)

        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 2
        contentView.addSubview(nameLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.frame.width)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }
    }

    func configure(with actor: Actor) {
        nameLabel.text = actor.name
        if let profilePath = actor.profilePath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")!
            loadImage(from: imageURL)
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self?.profileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

