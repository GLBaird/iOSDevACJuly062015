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
        
    }
    
    @IBAction func jsonParse(sender:AnyObject) {
        
    }

    @IBAction func xmlParse(sender:AnyObject) {
        
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
