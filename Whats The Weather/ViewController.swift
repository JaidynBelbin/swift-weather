//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Jaidyn Belbin on 24/10/16.
//  Copyright © 2016 Jaidyn Belbin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var city: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func searchButton(_ sender: AnyObject) {
        
        // Error checking the URL we are making from the users entered city.
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + city.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
        // Creating a request from the URL and a task from that request that will load the HTML from the specified website.
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            // Variable to hold the weather details to be displayed.
            var weatherMessage = ""
            
            // If there's an error
            if error != nil {
                
                print(error!)
                
            } else {
                
                // Unwrap the data, convert it to a String with the rawValue encoding, and print it to the console.
                if let unwrappedData = data {
                    
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    // Splits the entire page content into an array of elements separated wherever the text above appears, which is directly before the text that we want.
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        
                        if contentArray.count > 1 {
                            
                            // Updating stringSeparator to split everything by this tag.
                            stringSeparator = "</span>"
                            
                            // contentArray[1] is where the text we are interested in starts, so by separating the array by the tag directly following that text, i.e. </span> we isolate just the text we want.
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 1 {
                                
                                // Replacing the HTML degree with the correct symbol.
                                weatherMessage = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                print(weatherMessage)
                            }
                        }
                    }
                }
            }
            
            // If no message was produced by the code above...
            if weatherMessage == "" {
                
                weatherMessage = "The weather there couldn't be found. Please try again."
            }
            
            // Dispatching the message from the main queue so we can display it in the UI
            DispatchQueue.main.sync(execute: {
                
                self.resultLabel.text = weatherMessage
            })
        }
        
        // Remember to call this method to actually start the task.
        task.resume()
            
        } else {
            
            resultLabel.text = "The weather there couldn't be found. Please try again."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method that runs when the user taps anywhere on the View that is not the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Gets the View controlled by this ViewController, and ends the editing, ie. the keyboard.
        self.view.endEditing(true)
    }
    
    // Method run when the user hits return on the keyboard associated with this TextField.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Shuts down the keyboard associated with this TextField
        textField.resignFirstResponder()
        
        return true
    }
}

