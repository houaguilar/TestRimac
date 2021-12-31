//
//  MovieTableViewCell.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 22/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblYearRelease:UILabel!
    @IBOutlet var lblOverView:UILabel!
    @IBOutlet var imgPoster:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadWithData(_ movie:WrapperMovie){
        self.lblTitle.text = movie.title
        self.lblYearRelease.text = movie.year
        self.lblOverView.text = movie.overView
        self.imgPoster.sd_setImage(with: movie.url,
                                   placeholderImage:Asset.Movies.hintMovie.image)
    }
}
