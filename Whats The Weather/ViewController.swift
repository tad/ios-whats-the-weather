//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Terry Donaghe on 10/12/16.
//  Copyright © 2016 Donaghe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtCityName: UITextField!
    @IBOutlet weak var lblWeatherData: UILabel!
    
    @IBAction func btnSubmit(_ sender: AnyObject) {
        var city = txtCityName.text!
        city = city.replacingOccurrences(of: " ", with: "-")
        let url = URL(string: "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest")
      
        let request = NSMutableURLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print(error)
                self.lblWeatherData.text = "Unable to retrieve weather data"
            } else {
                var forecast = ""
                if let unwrappedData = data {
                    let dataString = String(data: unwrappedData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
//                    print(dataString)
                    
                    if dataString.contains("3 Day Weather Forecast Summary") {
                        print("Got the weather!")
                    } else {
                      forecast = "No weather information available"
                      self.lblWeatherData.text = forecast
                      return
                    }
                
                  
                    forecast = dataString.components(separatedBy: "3 Day Weather Forecast Summary:")[1].components(separatedBy: "<span class=\"phrase\">")[1].components(separatedBy: "</span>")[0]
                        
                    print(forecast)

                  let options: [String : AnyObject] = [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType as AnyObject, NSCharacterEncodingDocumentAttribute : String.Encoding.utf8.rawValue as AnyObject]
                  
                  if let data = forecast.data(using: String.Encoding.utf8) {
                    do {
                      let unescaped = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                      forecast = unescaped.string
                    } catch {
                      print(error)
                    }
                  }
                    DispatchQueue.main.sync(execute: {
                        // Code here happens immediately after the task is complete
                        self.lblWeatherData.text = forecast
                    })
                }
            }
        }
        task.resume()
        // Code below will run before the task above.
        lblWeatherData.text = "Retrieving weather data..."
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

