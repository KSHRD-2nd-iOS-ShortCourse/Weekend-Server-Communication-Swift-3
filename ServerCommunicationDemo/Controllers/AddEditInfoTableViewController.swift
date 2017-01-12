//
//  AddEditInfoTableViewController.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/10/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class AddEditInfoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {
    
    // Property
    var article : JSON?
    let imagePicker = UIImagePickerController()
    
    // Outlet
    @IBOutlet var descriptionLabel: UITextField!
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var articleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if book is not nil, assign value to outlet
        if let article = article{
            print(article)
            titleLabel.text = article["TITLE"].stringValue
            descriptionLabel.text = article["DESCRIPTION"].stringValue
            articleImageView.kf.setImage(with: URL(string: article["IMAGE"].stringValue), placeholder: UIImage(named: "noimage_thumbnail"))
        }
        
        // set delegate for imagePicker
        imagePicker.delegate = self
    }
    
    // TODO: Save Action
    @IBAction func save(_ sender: Any) {
        
        // Create NVActivityIndicator
        let size = CGSize(width: 30, height:30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType.ballBeat)
        
        /***** NSDateFormatter Part *****/
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dayTimePeriodFormatter.string(from: Date())
        
        // dateString now contains the string:
        // "December 25, 2016 at 7:00:00 AM"
        print(dateString)
        
        var url = DataManager.Url.ARTICLE
        var method = HTTPMethod.post
        
        // if have book data > update
        if article != nil  {
            url = "\(DataManager.Url.ARTICLE)/\(article!["ID"].stringValue)"
            method = HTTPMethod.put
        }
        
        uploadFile(file: UIImageJPEGRepresentation(self.articleImageView.image!, 1)!) { (fileUrl) in
            
            let paramater = [
                "TITLE": self.titleLabel.text!,
                "DESCRIPTION": self.descriptionLabel.text!,
                "AUTHOR": 585,
                "CATEGORY_ID": 1,
                "STATUS": "1",
                "IMAGE": fileUrl ?? ""
                ] as [String : Any]
            
            // request
            Alamofire.request(url,
                              method: method,
                              parameters: paramater,
                              encoding: JSONEncoding.default,
                              headers: DataManager.HEADERS)
                .responseJSON { (response) in
                    // show other NVActivityIndicator
                    self.stopAnimating()
                    if response.response?.statusCode == 200 {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
            }
        }
    }
    
    func uploadFile(file : Data, completion: @escaping (_ result: String?) -> Void) {
        /*
         Request :
         - JSONEncoding type creates a JSON representation of the parameters object
         */
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(file, withName: "FILE", fileName: ".jpg",mimeType: "image/jpeg") // append image
            
            
        }, to: DataManager.Url.FILE,
           method: .post,
           headers:  DataManager.HEADERS,
           encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if let json = response.result.value {
                        let data = json as! [String: Any]
                        
                        completion(data["DATA"] as? String)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddEditInfoTableViewController {
    
    // TODO: Browse Image IBAction
    @IBAction func browseImage(_ sender: Any) {
        // coonfig property
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        // show image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    // TODO: Finish Picking Media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        // Get image
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            // config property and assign image
            articleImageView.contentMode = .scaleAspectFit
            articleImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // TODO: Image Picker Controller Did Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // TODO: Take Photo
    @IBAction func openCameraButton(sender: AnyObject) {
        
        // config property
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // TODO: Image Picker Did Finish Picking Image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // Set image to articleImageView
        articleImageView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
}
