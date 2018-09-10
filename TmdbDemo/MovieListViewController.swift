//
//  MovieListViewController.swift
//  TmdbDemo
//
//  Created by EricChien on 2018/9/6.
//  Copyright © 2018年 Soul. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class MovieTabCell : UITableViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!
    @IBOutlet weak var popularityLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTabCell", for: indexPath) as! MovieTabCell
        
        let movie = movies[indexPath.row]
        
        cell.titleLbl.text = movie["title"].stringValue
        cell.popularityLbl.text = "\(movie["popularity"].floatValue * 100)%"
        cell.overviewLbl.text = movie["overview"].stringValue
        
        let posterPath = movie["poster_path"].stringValue
        let url = URL.init(string: GlobleVariables.imageDomain + posterPath)
        cell.posterImg.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            self.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let strId = "\(movie["id"].intValue)"
        self.performSegue(withIdentifier: "showDetailViewController", sender: strId)
    }
}

class MovieListViewController: UIViewController {

    @IBOutlet weak var sectionTxtf: UITextField!
    @IBOutlet weak var mainTable: UITableView!
    
    var refreshContrl: UIRefreshControl!
    var pages = 0
    var section = 0
    
    var movies : [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshContrl = UIRefreshControl()
        mainTable.addSubview(refreshContrl)
        
        let pullTitle = NSAttributedString.init(string: "refreshing now!")
        refreshContrl.attributedTitle = pullTitle
        refreshContrl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func loadData () {
        requestMovie(section, pages)
    }
    
    func loadMore () {
        if pages < 10 {
            requestMovie(section, pages + 1)
        }
    }
    
    @objc func reloadData () {
        movies = []
        requestMovie( 0, 0)
    }
    
    @IBAction func forward(_ sender: Any) {
        movies = []
        requestMovie(section + 1, 0)
    }
    
    @IBAction func rewind(_ sender: Any) {
        if section > 0 {
            movies = []
            requestMovie(section - 1, 0)
        }
    }
    
    func sectionValue () {
        sectionTxtf.text = "\(section + 1)"
    }
    
    func requestMovie(_ section:Int, _ pages:Int) {
        Alamofire.request(GlobleVariables.listDomain,
                          method: .get,
                          parameters: ["api_key":GlobleVariables.apiKey,
                                       "page": "\(section * 10 + pages + 1)",
                                       "sort_by":"release_date.desc"])
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let results = json["results"].arrayValue
                    self.movies += results
                    self.mainTable.reloadData()
                    self.section = section
                    self.pages = pages
                    self.sectionValue()
                case.failure(let error):
                    print("\(error)")
                }
                self.refreshContrl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            let url = GlobleVariables.detailDomain + "\(sender as! String)"
            detailViewController.request = Alamofire.request(url, method: .get, parameters: ["api_key":GlobleVariables.apiKey])
        }
    }
}
