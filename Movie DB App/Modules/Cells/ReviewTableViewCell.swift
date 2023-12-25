//
//  ReviewTableViewCell.swift
//  Movie DB App
//
//  Created by Samuel on 25-12-23.
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {
    var review: Review
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.backgroundColor = UIColor(named: "LightColor")
        return imageView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TintColor")
        label.textAlignment = .center
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        return label
    }()
    
    lazy var reviewCommentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()
    
    init(review: Review) {
        self.review = review
        super.init(style: .default, reuseIdentifier: "MovieTableViewCell")
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ReviewTableViewCell {
    func configureViews() {
        backgroundColor = .clear
        configureAvatarImageView()
        configureRatingLabel()
        configureAuthorLabel()
        configureReviewComment()
    }
    
    func configureAvatarImageView() {
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 44),
            avatarImageView.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureRatingLabel() {
        guard let rating = review.authorDetails?.rating else { return }
        contentView.addSubview(ratingLabel)
        
        ratingLabel.text = String(format: "%.1f", rating)
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 14),
            ratingLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
        ])
    }
    
    func configureAuthorLabel() {
        contentView.addSubview(authorLabel)
        
        authorLabel.text = review.authorDetails?.name ?? ""
        if authorLabel.text == "" {
            authorLabel.text = review.author
        }
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configureReviewComment() {
        contentView.addSubview(reviewCommentLabel)
        
        reviewCommentLabel.text = review.content
        
        NSLayoutConstraint.activate([
            reviewCommentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            reviewCommentLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            reviewCommentLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            reviewCommentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
