//
//  HomeTableViewController.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/11/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import NVActivityIndicatorView

class HomeTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    // Property
    var articles : [JSON]! = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register class
        let nib = UINib(nibName: "TableViewSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        // Add refresh control action
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        getData()
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetail" {
            let destView = segue.destination as! DetailTableViewController
            destView.bookId = sender as? String
        }else if segue.identifier == "showEdit"{
            let destView = segue.destination as! AddEditInfoTableViewController
            destView.book = sender as? [String : Any]
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        getData()
        
    }
    
    func getData() {
        // Create NVActivityIndicator
        let size = CGSize(width: 30, height:30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType.ballBeat)
        
        // request data
        Alamofire.request("\(DataManager.Url.ARTICLE)",
            method: .get,
            parameters: ["page" : 1,
                         "limit" : 15],
            headers: DataManager.HEADERS)
            .responseJSON { (response) in
                
                if let data = response.data {
                    // JSON Results
                    let jsonObject = JSON(data: data)
                    print(jsonObject)
                    self.articles = jsonObject["DATA"].array
                    
                    self.tableView.reloadData()
                    self.stopAnimating()
                    self.refreshControl?.endRefreshing()
                }
        }
    }
}


// MARK: - Table view data source
extension HomeTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        
        // Configure the cell...
        let article = self.articles[indexPath.section]
        cell.titleLabel.text = article["TITLE"].stringValue
        cell.descriptionLabel.text = article["DESCRIPTION"].stringValue
        cell.coverImageView.kf.setImage(with: URL(string: article["IMAGE"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholder: UIImage(named: "google_logo"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self.articles[indexPath.section]["ID"].stringValue)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        
        let header = cell as! TableViewSectionHeader
        header.titleLabel.text = self.articles[section]["AUTHOR"]["NAME"].stringValue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateFromString = dateFormatter.date(from: self.articles[section]["CREATED_DATE"].stringValue)
        
        dateFormatter.dateFormat = "dd-MM-YYYY HH:mm"
        
        let stringFromDate = dateFormatter.string(from: dateFromString!)
        header.dateTimeLabel.text = stringFromDate
        
        // load profile image
        header.profileImageView.kf.setImage(with: URL(string: self.articles[section]["AUTHOR"]["IMAGE_URL"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholder: UIImage(named: "google_logo"))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            self.startAnimating()
            Alamofire.request("\(DataManager.Url.ARTICLE)/\(self.articles[indexPath.section]["ID"])", method: .delete, headers: DataManager.HEADERS).responseJSON { (response) in
                
                if response.response?.statusCode == 200 {
                    
                    tableView.beginUpdates()
                    self.articles.remove(at: indexPath.section)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                    tableView.endUpdates()
                    
                    self.stopAnimating()
                }
            }
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { action, index in
            self.performSegue(withIdentifier: "showEdit", sender: self.articles[indexPath.section].dictionaryObject)
        }
        
        edit.backgroundColor = UIColor.brown
        return [delete, edit]
    }
}
