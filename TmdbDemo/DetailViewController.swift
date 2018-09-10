//
//  DetailViewController.swift
//  TmdbDemo
//
//  Created by EricChien on 2018/9/8.
//  Copyright © 2018年 Soul. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class TitleCollectCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomY = scrollView.contentSize.height - scrollView.bounds.size.height - bookmarkView.frame.size.height
        bookmarkView.isHidden = scrollView.contentOffset.y <= bottomY
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case genresCollect:
            return genres.count
        default:
            return languages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCollectCell", for: indexPath) as! TitleCollectCell
        switch collectionView {
        case genresCollect:
            let json = genres[indexPath.row]
            cell.titleLbl.text = json["name"].stringValue
        default:
            let json = languages[indexPath.row]
            cell.titleLbl.text = json["name"].stringValue
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var backdropImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overViewLbl: UILabel!
    @IBOutlet weak var popularityLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    
    @IBOutlet weak var genresCollect: UICollectionView!
    @IBOutlet weak var spokenCollect: UICollectionView!
    
    @IBOutlet weak var homepageTxtv: UITextView!
    
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    var genres = [JSON]()
    var languages = [JSON]()
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            title = request?.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let request = request else {
            return
        }
        
        if let request = request as? DataRequest {
            request.responseJSON { (response) in
                
                func loadImage(at img:UIImageView, with path:String) {
                    let url = URL.init(string: GlobleVariables.imageDomain + path)
                    img.sd_setImage(with: url, completed: nil)
                }
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    self.titleLbl.text = json["title"].stringValue
                    self.overViewLbl.text = json["overview"].stringValue
                    
                    self.popularityLbl.text = "\(json["popularity"].floatValue * 100) %"
                    self.releaseDateLbl.text = "\(json["release_date"].stringValue)"
                    
                    self.homepageTxtv.text = "\(json["homepage"].stringValue)"
                    
                    self.genres = json["genres"].arrayValue
                    self.languages = json["spoken_languages"].arrayValue
                    
                    let posterPath = json["poster_path"].stringValue
                    loadImage(at: self.posterImg, with: posterPath)
                    
                    let backdropPath = json["backdrop_path"].stringValue
                    loadImage(at: self.backdropImg, with: backdropPath)
                    loadImage(at: self.backgroundImg, with: backdropPath)
                    
                    self.genresCollect.reloadData()
                    self.spokenCollect.reloadData()
                    
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
