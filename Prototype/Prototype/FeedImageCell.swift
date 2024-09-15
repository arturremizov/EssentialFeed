//
//  FeedImageCell.swift
//  Prototype
//
//  Created by Artur Remizov on 13.09.24.
//

import UIKit

class FeedImageCell: UITableViewCell {
    @IBOutlet weak private(set) var locationContainer: UIStackView!
    @IBOutlet weak private(set) var locationLabel: UILabel!
    @IBOutlet weak private(set) var feedImageView: UIImageView!
    @IBOutlet weak private(set) var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        feedImageView.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.alpha = 0
    }
    
    func fadeIn(_ image: UIImage?) {
        feedImageView.image = image
        
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.feedImageView.alpha = 1
        }
    }
}
