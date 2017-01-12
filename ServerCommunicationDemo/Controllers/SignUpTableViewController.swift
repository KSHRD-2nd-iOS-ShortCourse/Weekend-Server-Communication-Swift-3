//
//  SignUpTableViewController.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/16/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SignUpTableViewController: UITableViewController, NVActivityIndicatorViewable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Property
    let imagePicker = UIImagePickerController()
    
    // Outlet
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: [UITextField]!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegate for imagePicker
        imagePicker.delegate = self
    }
    
    // TODO: SignIn IBAction
    @IBAction func signUpAction(_ sender: Any) {
        // Create NVActivityIndicator
        let size = CGSize(width: 30, height:30)
        self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType.ballZigZag)
        
        // Validation
        if passwordTextField[0].text != passwordTextField[1].text {
            print("password not match")
            self.stopAnimating()
            return
        }
        
        // post parameter
        let paramaters = ["EMAIL" : self.emailTextField.text!,
                          "NAME" : self.nameTextField.text!,
                          "PASSWORD" : self.passwordTextField[0].text!,
                          "GENDER" : self.genderSegmentedControl.selectedSegmentIndex == 0 ? "M": "F",
                          "TELEPHONE" : "012345678",
                          "FACEBOOK_ID" : "000000000",
                          "format" : "json"]
        // image
        let pickedImage = UIImageJPEGRepresentation(self.profileImageView.image!, 1)
        
        /*
         Request :
         - JSONEncoding type creates a JSON representation of the parameters object
         */
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in paramaters {
                multipartFormData.append(value.data(using: .utf8, allowLossyConversion: false)!, withName: key)
            }
            
            multipartFormData.append(pickedImage!, withName: "PHOTO", fileName: ".jpg",mimeType: "image/jpeg") // append image
            
            
        }, to: DataManager.Url.USER,
           method: .post,
           headers:  DataManager.HEADERS,
           encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                        // show other NVActivityIndicator
                        self.stopAnimating()
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    // TODO: Browse Image
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
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // TODO: Image Picker Controller Did Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
