//
//  ViewController.swift
//  Networking
//
//  Created by Leon Baird on 30/03/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
            NSXMLParserDelegate,
            NSURLConnectionDataDelegate,
            NSURLConnectionDelegate {

    // outlets
    @IBOutlet weak var logText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func appendTextToLog(text:String) {
        let today = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        logText.text = "[\(today)]: \(text)\n\n\(logText.text)"
        
    }
    
    // MARK: - Action methods
    
    @IBAction func clearLog(sender: AnyObject) {
        logText.text = ""
    }

    @IBAction func downloadJSON(sender: AnyObject) {
        let urlString = "http://leonbaird.co.uk/iphone/userdata.json"
        let url = NSURL(string:urlString)!
        
        // download data (NOT ASYNC) use blocks for async!
        let jsonData = NSData(contentsOfURL:url)
        if (jsonData == nil) {
            appendTextToLog("Failed to download JSON...")
            return
        }
        
        var error:NSError?
        if let downloadedData = NSJSONSerialization.JSONObjectWithData(
            jsonData!,
            options:.AllowFragments,
            error:&error
            ) as? NSDictionary {
        
            appendTextToLog("Downloaded Data: \(downloadedData.description)")
                
        } else {
            if (error != nil) {
                appendTextToLog("Error parsing JSON - \(error!.localizedDescription)")
            } else {
                appendTextToLog("Cannot cast JSON object to Dictionary")
            }
        }

    }

    @IBAction func downloadXML(sender: AnyObject) {
        let urlString = "http://leonbaird.co.uk/iphone/userdata.xml"
        let url = NSURL(string:urlString)!
        
        if let parser = NSXMLParser(contentsOfURL:url) {
            parser.delegate = self;
            if (!parser.parse()) {
                appendTextToLog("Parse Error!")
            }
        } else {
            appendTextToLog("Error making XML Parser")
        }
    }
    
    // MARK: - GET and POST methods
    
    // MARK: service variables
    let baseURL = "http://leonbaird.co.uk"
    let service = "iphone"
    let api     = "input.php"
    
    func getBaseService() -> String {
        return "\(baseURL)/\(service)/\(api)"
    }
    
    
    // MARK: data variables
    let apiKey   = "apikey=DEV123456";
    let username = "username=leonbaird";
    let format   = "format=json";
    
    func getURLEncodedVariables() -> String {
        return"\(apiKey)&\(username)&\(format)"
    }
    
    func getFullGETDataURL() -> String {
        return getBaseService() + "?" + getURLEncodedVariables()
    }
    
    // MARK: actions for sending
    
    @IBAction func sendGET(sender: AnyObject) {
        if let url = NSURL(string: getFullGETDataURL()) {
            var error:NSError?
            // this method blocks main thread - use concurency
            if let response = String(
                contentsOfURL: url,
                encoding: NSUTF8StringEncoding,
                error: &error) {
                appendTextToLog("Response from GET Request: \(response)")
            } else if error != nil {
                appendTextToLog("Error downloading GET data: \(error!.localizedDescription)")
            } else {
                appendTextToLog("Error downloading GET data - untraceable")
            }
        } else {
            appendTextToLog("Error forming URL for connection")
        }
    }
    
    @IBAction func sendPOST(sender: AnyObject) {
        // make URL
        if let url = NSURL(string: getBaseService()) {
            // Make mutable request
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            // set header
            request.setValue("application/x-www-form-urlencoded; charset=UTF-8",
                forHTTPHeaderField: "Content-Type")
            
            // set body
            if let encodedData = getURLEncodedVariables().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                request.HTTPBody = encodedData
                
                // set timeout to 2 seconds
                request.timeoutInterval = 2.0
                
                connection = NSURLConnection(request: request, delegate: self)
                connection.start()
                
            } else {
                appendTextToLog("Failed encoding form variables for POST body")
            }
            
        }
    }
    
    // MARK: - NSXMLParser delegate methods
    // MARK: Mutable variables for parsing
    var parsedXML:[Dictionary<String, String>]!
    var currentRecord:Dictionary<String, String>!
    var parsedText:String!
    
    // MARK: Delegate methods
    func parserDidStartDocument(parser: NSXMLParser!) {
        appendTextToLog("Started parsing XML")
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        appendTextToLog("Ended parsing XML:\n\(parsedXML.description)")
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        appendTextToLog("START \(elementName)")
        switch elementName {
            case "user":
                currentRecord = Dictionary<String, String>()
            case "name", "address":
                parsedText = ""
            case "user-data":
                parsedXML = []
            default:
            appendTextToLog("Found unexpected Element: \(elementName)")
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        appendTextToLog("ENDING \(elementName)")
        switch elementName {
            case "user":
                parsedXML.append(currentRecord)
                currentRecord = nil
            case "name", "address":
                if elementName != nil {
                    currentRecord[elementName!] = parsedText
                    parsedText = nil
                }
            case "user-data":
                appendTextToLog("End of XML File")
            default:
                appendTextToLog("End of unexpected Element: \(elementName)")
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        appendTextToLog("Characters Found in XML DATA")
        if string != nil && parsedText != nil {
            parsedText = parsedText+string
        }
    }
    
    
    // MARK: - NSURLConnection delegate methods
    // MARK: Mutable variables for managing connecton and data
    var connection:NSURLConnection!
    var downloadedData:NSMutableData!
    
    // MARK: Delegate methods
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        appendTextToLog("Error with connection: \(error.localizedDescription)")
        self.connection = nil
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        appendTextToLog("Response found with MIME-TYPE: \(response.MIMEType!)")
        downloadedData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        appendTextToLog("Connection has received data...")
        downloadedData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        appendTextToLog("Connection Finished and Closed.")
        if let downloadedText = NSString(data: downloadedData, encoding: NSUTF8StringEncoding) {
            appendTextToLog("Downloaded text from connection: \(downloadedText)")
        } else {
            appendTextToLog("ERROR - Cannot convert data into UTF-8 String")
        }
    }
    
}

