//
//  GetPostViewController.swift
//  Networking
//
//  Created by Leon Baird on 10/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class GetPostViewController: UIViewController,
        UITextFieldDelegate {

    // outlets
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var textConsole:UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func writeToConsole(text:String) {
        textConsole.text = text + "\n" + textConsole.text
    }
    
    // MARK: - URL Builder methods
    
    let baseURL = "http://leonbaird.co.uk"
    let api     = "iphone"
    let service = "input.php"
    
    // data
    var username:String {
        return nameTextField.text
    }
    
    let apiKey  = "LB22987475834828"
    let qty     = "5000x"
    let product = "gregs%20pies"
    
    var encodedURLVariables:String {
        return "name=\(username)&apikey=\(apiKey)&qty=\(qty)&product=\(product)"
    }
    
    var apiServiceString:String {
        return "\(baseURL)/\(api)/\(service)"
    }
    
    var getRequestString:String {
        return "\(apiServiceString)?\(encodedURLVariables)"
    }
    
    // MARK: - actions
    
    @IBAction func getRequest(sender:AnyObject) {
        // test URL
        writeToConsole("RequestURL: " + getRequestString)
        
        if let getURL = NSURL(string: getRequestString) {
            var error:NSError?
            if let downloadedText = String(
                contentsOfURL: getURL,
                encoding: NSUTF8StringEncoding,
                error: &error)
            {
                writeToConsole("Text downloaded:\n\(downloadedText)")
            } else {
                writeToConsole("Download failed!\n\(error!.localizedDescription)")
            }
        } else {
            writeToConsole("Invalid URL!!")
        }
    }
    
    @IBAction func postRequest(sender:AnyObject) {
        let postURL = NSURL(string: apiServiceString)!
        var postRequest = NSMutableURLRequest(URL: postURL)
        
        // setup request
        postRequest.HTTPMethod = "POST"
        postRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8",
            forHTTPHeaderField: "Content-Type")
        postRequest.HTTPBody = encodedURLVariables.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        postRequest.timeoutInterval = 20.0
        
        // sync call
        var responseHeader:NSURLResponse?
        var error:NSError?
        var downloadedData = NSURLConnection.sendSynchronousRequest(
            postRequest,
            returningResponse: &responseHeader,
            error: &error
        )
        
        if let downloadedText = NSString(data: downloadedData!,
            encoding: NSUTF8StringEncoding) as? String {
                writeToConsole("Downloaded via post: " + downloadedText)
        } else {
            writeToConsole("Failed to download text via post")
        }
    }
    
    @IBAction func jsonParse(sender:AnyObject) {
        let jsonURL = NSURL(string: "http://leonbaird.co.uk/iphone/userdata.json")!
        if let jsonData = NSData(contentsOfURL: jsonURL) {
            let data = NSJSONSerialization.JSONObjectWithData(
                jsonData,
                options: NSJSONReadingOptions.MutableContainers,
                error: nil) as! Dictionary<String, AnyObject>
            
            writeToConsole(data.description)
            let users = data["users"] as! Array<Dictionary<String, AnyObject>>
            let name = users[0]["name"] as! String
            writeToConsole(name)
        } else {
            writeToConsole("Errors")
        }
        
    }

    @IBAction func xmlParse(sender:AnyObject) {
        
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
