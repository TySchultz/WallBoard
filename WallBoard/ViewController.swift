//
//  ViewController.swift
//  WallStatusBoard
//
//  Created by Ty Schultz on 6/20/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit
import SwiftMoment
import Kanna
import AVKit
import AVFoundation


struct WeatherData {
    var temperature: Int
    var highTemp: Int
    var lowTemp: Int
    var date: Moment
}

struct HourData {
    var temperature: Int
    var date: Moment
}

struct CourtActivity {
    var time: String
    var location: String
    var activity: String
}



class ViewController: UIViewController {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var risingLoweringTemp: UILabel!
    
    @IBOutlet weak var hourlyTempStack: UIStackView!
    @IBOutlet weak var hourlyHourStack: UIStackView!
    var currentData: WeatherData!
    
    @IBOutlet weak var refreshLabel: UILabel!
    var hourlyDataSet: [HourData]!
    var courtData: [CourtActivity]!

    var clockTimer: NSTimer?
    var weatherTimer: NSTimer?
    
    var player: AVPlayer?

    @IBOutlet weak var topShadow: UIView!
    @IBOutlet weak var bottomShadow: UIView!

    @IBOutlet weak var bar: TimerAnimation!
    @IBOutlet weak var courtTimeStack: UIStackView!
    @IBOutlet weak var courtLocationStack: UIStackView!
    
    let COLORS = [UIColor(red:0.46, green:0.89, blue:0.56, alpha:1.00),
                  UIColor(red:0.99, green:0.29, blue:0.37, alpha:1.00),
                  UIColor(red:0.22, green:0.64, blue:0.90, alpha:1.00),
                  UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.00),
                  UIColor(red:0.15, green:0.16, blue:0.13, alpha:1.00)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        
        currentData = WeatherData(temperature: 0, highTemp: 0, lowTemp: 1000, date: moment())
        
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateTimeLabel), userInfo: nil, repeats: true)
        weatherTimer = NSTimer.scheduledTimerWithTimeInterval(600, target: self, selector: #selector(ViewController.refreshWebData), userInfo: nil, repeats: true)
        getWeatherData()
        
        getCourtData()
        
        
        bar.backgroundColor = UIColor.clearColor()
        
        
      
        
        let HEIGHT :CGFloat = 240
        
        let topGradient = CAGradientLayer()
        topGradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: HEIGHT)
        var color1 = UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor
        var color2 = UIColor.clearColor().colorWithAlphaComponent(0.0).CGColor
        topGradient.colors = [color1, color2]
        topGradient.locations = [0.0, 1.0]
        
        
        let bottomGradient = CAGradientLayer()
        bottomGradient.frame = CGRect(x: 0, y: self.view.frame.height-HEIGHT, width: self.view.frame.width, height: HEIGHT)
        color1 = UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor
        color2 = UIColor.clearColor().colorWithAlphaComponent(0.0).CGColor
        bottomGradient.colors = [color2, color1]
        bottomGradient.locations = [0.0, 1.0]
        
        
        
        //Video background 
        // Load the video from the app bundle.
//        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("b7-1", withExtension: "mov")!
        
        let videoURL: NSURL = NSURL(string: "http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/b7-1.mov")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        playerLayer.addSublayer(topGradient)
        playerLayer.addSublayer(bottomGradient)
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ViewController.loopVideo),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
    }
    
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
    
    func changeBackgroundColor(sender : UIButton){
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.CurveEaseInOut], animations: {
            self.view.backgroundColor = sender.backgroundColor
            }, completion: nil)
    }
    
    func updateInterface() {
        date.text        = "\(currentData.date.weekdayName) \(currentData.date.monthName) \(currentData.date.day)"
        highTemp.text    = "\(currentData.highTemp)"
        lowTemp.text     = "\(currentData.lowTemp)"
        currentTemp.text = "\(currentData.temperature)"

        print(currentData)
        
        clearStackViews(hourlyHourStack)
        clearStackViews(hourlyTempStack)
        clearStackViews(courtTimeStack)
        clearStackViews(courtLocationStack)
        
        
        for hour in hourlyDataSet {
            hourlyHourStack.addArrangedSubview(createLabelForWeather(hour.date.format("h a")))
            hourlyTempStack.addArrangedSubview(createLabel(String(hour.temperature)))
            print("\(hour.temperature) \(hour.date.format("h a"))")
        }
        
        for court in courtData {
            courtTimeStack.addArrangedSubview(createLabel(court.time))
            courtLocationStack.addArrangedSubview(createLabel(String(court.location)))
        }
    }
    
    
    func clearStackViews(stack : UIStackView) {
        for view in stack.arrangedSubviews{
            view.removeFromSuperview()
        }
    }
    
    func updateTimeLabel() {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        time.text = formatter.stringFromDate(NSDate(timeIntervalSinceNow: 0))
    }
    
    
    func refreshWebData(){
        getWeatherData()
        getCourtData()
        let formatter = NSDateFormatter(
        )
        formatter.timeStyle = .ShortStyle
    }
    
    func getWeatherData(){

        let requestURL: NSURL = NSURL(string: "https://api.forecast.io/forecast/3e8f482cafb24d4ffa5d244094e7be27/40.0215550,-83.0092800")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: [])
                //Main thread
                dispatch_async(dispatch_get_main_queue(), {
                    self.parseWeatherData(json)
                })
            }
        }
        task.resume()
    }
    
    func getCourtData(){
        
        courtData = []
        // Set the page URL we want to download
        let URL = NSURL(string: "https://recsports.osu.edu/schedule/")
        
        // Try downloading it
        do {
            let htmlSource = try String(contentsOfURL: URL!, encoding: NSUTF8StringEncoding)
            
            if let doc = Kanna.HTML(html: htmlSource, encoding: NSUTF8StringEncoding) {

                var found = false
                var time = ""
                var activity = ""
                
                let css = doc.css("td").dropFirst()
                
                for row in css {
                    if row.text!.containsString("Schedule : Recreational Sports"){
                        break
                    }else if found {
                        if time.containsString("AM") || time.containsString("PM"){
                            let courtEvent = CourtActivity(time: time, location: row.text!, activity: activity)
                            courtData.append(courtEvent)
                        }
                        found = false
                    }else if (row.text!.containsString("Basketball")){
                        activity = row.text!
                        found = true
                    }else{
                        time = row.text!
                    }
                }
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    deinit {
        if let timer = self.clockTimer {
            timer.invalidate()
        }
        if let wTimer = self.weatherTimer {
            wTimer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create a label for the weather stackview
    func createLabel(singleHour : String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        label.text = singleHour
        label.font = UIFont(name: "Avenir Book", size: 23)
        label.textColor = UIColor.whiteColor()
        label.widthAnchor.constraintEqualToConstant(75)
        label.textAlignment = .Center
        return label
    }
    
    func createLabelForWeather(singleHour : String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        
        label.text = singleHour.lowercaseString
        label.font = UIFont(name: "Avenir Book", size: 19)
        label.textColor = UIColor.whiteColor()
        label.widthAnchor.constraintEqualToConstant(75)
        label.textAlignment = .Center
        return label
    }
}

extension ViewController {
    
    func parseWeatherData(data : AnyObject?){
        hourlyDataSet = []

        //Get current temp
        if let currentWeather = data?["currently"] as? [String: AnyObject] {
            //            for item in currentWeather {
            //                //                        print(item)
            //            }
            let temperature = currentWeather["temperature"] as! Int
            self.currentData.temperature = temperature
            
            let time = currentWeather["time"] as! Double
            self.currentData.date = moment(NSDate(timeIntervalSince1970: time))
        }
        
        currentData.lowTemp = 1000
        currentData.highTemp = 0
        //Get hourly data
        if let hourlyData = data?["hourly"] as? [String: AnyObject] {
            
            if let hours = hourlyData["data"] as? [[String: AnyObject]] {
                for index in 0...14{
                    if index%2 == 0{
                        let singleHour = hours[index]
                        let temperature = singleHour["temperature"] as! Int
                        let date = moment(NSDate(timeIntervalSince1970: singleHour["time"] as! Double))
                        hourlyDataSet.append(HourData(temperature: temperature, date: date))
                        checkForLowHigh(temperature)
                    }
                }
            }
        }
        self.updateInterface()
    }
    
    func checkForLowHigh(temperature : Int){
        if temperature > currentData.highTemp{
            currentData.highTemp = temperature
        }else if temperature < currentData.lowTemp{
            currentData.lowTemp = temperature
        }
    }
    

}

