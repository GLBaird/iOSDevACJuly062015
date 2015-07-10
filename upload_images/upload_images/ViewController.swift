//
//  ViewController.swift
//  upload_images
//
//  Created by Leon Baird on 09/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
        UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var textConsole: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var sourceSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        let source = UIImagePickerControllerSourceType(rawValue: sourceSegment.selectedSegmentIndex)!
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func uploadData(sender: AnyObject) {
        let imageData   = UIImageJPEGRepresentation(imagePreview.image, 1.0)
        let descriptionTXT = descriptionTextField.text
        let processURL = NSURL(string: "http://leonbaird.co.uk/iphone/process.php")

        if let url = processURL {
            
            // info for header
            let boundary = "-----iOSformfieldboundary123456789"
            let contentType = "multipart/form-data; boundary=\(boundary)"
            
            let seperator = "\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            
            var body = NSMutableData()
            body.appendData(seperator)
            body.appendData("Content-Disposition: form-data; name=\"description\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            body.appendData(descriptionTXT.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            body.appendData(seperator)
            body.appendData("Content-Disposition: form-data; name=\"image[]\"; filename=\"uploaded_image.jpg\"\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            body.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            body.appendData(imageData)
            body.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            var request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            request.HTTPBody = body
            
            var response:NSURLResponse?
            var error:NSError?
            
            let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
            if let rd = responseData {
                let responseText = NSString(data:rd, encoding: NSUTF8StringEncoding) as! String
                textConsole.text = "Response text:\n\(responseText)\nHeader:\(response?.description)"
            } else if error != nil {
                textConsole.text = "Error "+error!.localizedDescription+"\n"+textConsole.text
            } else {
                textConsole.text = "Unknown Error\n"+textConsole.text
            }
            
        }
        
    }

    // MARK: - Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePreview.image = info[UIImagePickerControllerEditedImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Textfield Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

