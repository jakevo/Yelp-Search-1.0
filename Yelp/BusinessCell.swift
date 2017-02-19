//
//  BusinessCell.swift
//  Yelp
//
//  Created by Jake Vo on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var resName: UILabel!
    @IBOutlet var rating: UIImageView!
    @IBOutlet var review: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var category: UILabel!
    var x = 0
    var business: Business! {
        didSet {
            resName.text = business.name!
            rating.setImageWith(business.ratingImageURL!)
            thumbImage.setImageWith(business.imageURL!)
            address.text = business.address
            distance.text = business.distance
            category.text = business.categories
            review.text = "\(business.reviewCount!)" + " review"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
