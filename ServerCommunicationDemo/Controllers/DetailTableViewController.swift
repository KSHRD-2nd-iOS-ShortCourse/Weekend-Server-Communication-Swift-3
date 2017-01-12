//
//  DetailTableViewController.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/15/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Kingfisher
import NVActivityIndicatorView

class DetailTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    // Outlet
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // Property
    var articleID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create NVActivityIndicator
        let size = CGSize(width: 30, height:30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType.ballBeat)
        
        // if have book id request data
        if let id = articleID {
            
            // request request book
            Alamofire.request("\(DataManager.Url.ARTICLE)/\(id)",
                method: .get,
                headers: DataManager.HEADERS)
                .responseObject(completionHandler: { (articleResponse: DataResponse<Article>) in
                
                switch articleResponse.result{
                case.success(let article):
                    
                    // set data
                    self.titleLabel.text = article.title!
                    self.descriptionLabel.text = article.description!
                    
                    self.coverImageView.image = UIImage(data: try! Data(contentsOf: URL(string: article.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!))
                    
                    self.tableView.reloadData()
                    self.stopAnimating()
                    
                case.failure(let error):
                    print("\(error)")
                }
            })
        }
    }
    
    // TODO: Height For Row At IndexPath
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            let height = self.heightForText(lable: self.descriptionLabel)
            return height < 56 ? 56 : height + 30
        }else{
            return 56
        }
    }
    
    // TODO: Calculate lable hiehg
    func heightForText(lable: UILabel) -> CGFloat {
        lable.numberOfLines = 0
        lable.sizeToFit()
        return lable.frame.size.height
    }
    
}
