//
//  DetailViewController.swift
//  IndraMovie
//
//  Created by Jordy Aguilar on 29/12/21.
//  Copyright © 2021 Jordy Aguilar. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage
class DetailViewController: UIViewController, BindableType {
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var backDropPoster: UIImageView!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var originalTitle: UILabel!
    var viewModel: DetailMovieViewModel!
    typealias ViewModelType = DetailMovieViewModel
    var disposeBag = DisposeBag()
    func bindViewModel() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.getDetail()
            .subscribe(onNext: { event in
                switch event {
                case .success(let detailMovie):
                    print(detailMovie.title)
                    self.backDropPoster.sd_setImage(with: detailMovie.backPosterUrl)
                    self.imgPoster.sd_setImage(with: detailMovie.posterUrl)
                    
                    self.originalTitle.text = detailMovie.title
                    self.originalTitle.lineBreakMode = .byWordWrapping
                    self.originalTitle.numberOfLines = 3
                    self.overviewTextView.text = detailMovie.overView
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }

            }).disposed(by: disposeBag)
    }
    
    @IBAction func goToBack(_ sender: Any) {
        self.viewModel.goToBack()
    }
}
