//
//  UploadViewController.swift
//  Networking
//
//  Created by Leon Baird on 10/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController,
        UITextFieldDelegate,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate {
    
    // outlets
    @IBOutlet weak var consoleText:UITextView!
    @IBOutlet weak var camSource:UISegmentedControl!
    @IBOutlet weak var descriptionTextField:UITextField!
    @IBOutlet weak var imagePreview:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func writeToConsole(text:String) {
        consoleText.text = text + "\n" + consoleText.text
    }

    // MARK: Actions
    
    @IBAction func pickImage(sender:AnyObject) {
        let source = UIImagePickerControllerSourceType(rawValue: camSource.selectedSegmentIndex)!
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(sender:AnyObject) {
        let requestURL = NSURL(string:"http://leonbaird.co.uk/iphone/process.php")!
        let imageData = UIImageJPEGRepresentation(imagePreview.image, 1.0)!
        let descriptionText = descriptionTextField.text
        
        let boundary = "----LeonBairdUploader1234567"
        let seperator = "\r\n--\(boundary)\r\n".dataUsingEncoding(
            NSUTF8StringEncoding, allowLossyConversion:false)!
        
        // make the body
        var bodyData = NSMutableData()
        bodyData.appendData(seperator)
        bodyData.appendData("Content-Disposition: form-data; name=\"description\"".dataUsingEncoding(
            NSUTF8StringEncoding, allowLossyConversion:false)!)
        bodyData.appendData(descriptionText.dataUsingEncoding(
            NSUTF8StringEncoding, allowLossyConversion:false)!)
        bodyData.appendData(seperator)
        bodyData.appendData("Content-Disposition: form-data; name=\"image[]\"; filename=\"uploaded_image.jpg\"\r\n".dataUsingEncoding(
            NSUTF8StringEncoding, allowLossyConversion:false)!)
        bodyData.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(
            NSUTF8StringEncoding, allowLossyConversion:false)!)
        bodyData.appendData(imageData)
        bodyData.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(
            NSUTF8StringEncoding, allowLossyConversion:false)!)
        
        var request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = bodyData
        
        let responseData = NSURLConnection.sendSynchronousRequest(
            request,
            returningResponse: nil,
            error: nil
        )
        
        if responseData == nil {
            writeToConsole("No DATA")
        } else {
            writeToConsole("Data retrieved")
        }
        
        if let responseText = NSString(data: responseData!, encoding: NSUTF8StringEncoding) as? String {
            writeToConsole("POSTED FILE: \n"+responseText)
        } else {
            writeToConsole("Errors!!");
        }
    }
    
    // MARK: - Textfield delegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Image picker methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePreview.image = info[UIImagePickerControllerEditedImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }

}
