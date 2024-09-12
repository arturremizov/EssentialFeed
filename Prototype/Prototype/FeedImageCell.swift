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
}
