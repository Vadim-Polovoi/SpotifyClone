//
//  SongTable.swift
//  SpotifyClone
//
//  Created by Вадим on 2.09.22.
//

import UIKit


final class SongTableViewCell: UITableViewCell {
    
    static let identifier = "SongTableViewCell"
    
    var song: Song? {
        didSet {
            if let song = song {
                coverImageView.image = UIImage(named: song.image)
                songNameLabel.text = song.name
                artistNameLabel.text = song.artist
            }
        }
    }
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureView() {
        [coverImageView, songNameLabel, artistNameLabel].forEach { element in
            contentView.addSubview(element)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        let coverImageViewConstraints = [
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coverImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            coverImageView.widthAnchor.constraint(equalToConstant: 100),
            coverImageView.heightAnchor.constraint(equalToConstant: 100)
        ]
        let songNameLabelConstraints = [
            songNameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            songNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ]
        let artistNameLabelConstraints = [
            artistNameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8),
            artistNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(coverImageViewConstraints)
        NSLayoutConstraint.activate(songNameLabelConstraints)
        NSLayoutConstraint.activate(artistNameLabelConstraints)
    }
}
