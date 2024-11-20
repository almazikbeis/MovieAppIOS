import UIKit
import SnapKit

class MovieCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let ratingLabel = UILabel()
    let overlayView = UIView() // Полупрозрачный слой для улучшения читаемости текста

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        styleCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Настройка изображения постера
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        contentView.addSubview(imageView)
        
        // Настройка overlayView для затемнения нижней части постера
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.layer.cornerRadius = 10
        overlayView.clipsToBounds = true
        contentView.addSubview(overlayView)
        
        // Настройка заголовка
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        overlayView.addSubview(titleLabel)
        
        // Настройка рейтинга
        ratingLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        ratingLabel.textColor = .systemYellow
        ratingLabel.textAlignment = .center
        overlayView.addSubview(ratingLabel)
        
        // Ограничения для SnapKit
        imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().inset(5)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func styleCell() {
        // Закругленные углы и тень для ячейки
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.15
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 6
        contentView.layer.masksToBounds = false
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = "⭐ \(movie.voteAverage)/10"
        
        // Загрузка изображения асинхронно
        if let posterPath = movie.posterPath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
            loadImage(from: imageURL)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

