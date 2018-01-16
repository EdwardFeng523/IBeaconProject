//
//  ViewController.swift
//  iBeaconProj
//
//  Created by Edward Feng on 1/12/18.
//  Copyright © 2018 Edward Feng. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, identifier: "Gimbal")
    var lastframe: [Double] = []
    var proximity: Int? = nil
    var frequency: Int? = nil
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet var proximityButtons: [UIButton]!
    @IBOutlet var frequencyButtons: [UIButton]!
    @IBOutlet var machineButtons: [UIButton]!
    @IBOutlet weak var proximityDisplay: UILabel!
    @IBOutlet weak var frequencyDisplay: UILabel!
    @IBOutlet weak var machineDisplay: UILabel!
    @IBOutlet weak var console: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        time.text = ""
        proximityDisplay.text = "unknown"
        frequencyDisplay.text = "unknown"
        machineDisplay.text = "unknown"
        console.text = ""
    }
    
    /**
     *The start action and the stop action, starts and stops recording
     *first check if everything is already set up
    */
    @IBAction func Start(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.currentTitle == "Start" {
                if proximity != nil && frequency != nil && machineDisplay.text != "unknown"{
                    locationManager.startRangingBeacons(in: region)
                    console.text = "Recording started"
                } else {
                    print ("You must select a proximity, a frequency and a machine first")
                    console.text = "You must select a proximity, a frequency and a machine first"
                }

            }
            if button.currentTitle == "Stop" {
                locationManager.stopRangingBeacons(in: region)
                lastframe = []
                console.text = "Recording stopped"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *The proximity selection drop down menu
     *hide and show the drop down
     */
    @IBAction func proximitySelection(_ sender: UIButton) {
        proximityButtons.forEach{ (button) in
            button.isHidden = !button.isHidden
        }
    }
    
    /**
     *The different proximity choices
     *called when one is selected
     */
    @IBAction func proximityTapped(_ sender: UIButton) {
        if sender.currentTitle! == "Immediate (<1m)" {
            proximity = 1
            proximityDisplay.text = "Immediate (<1m)"
        }
        if sender.currentTitle! == "Near (<3m)" {
            proximity = 2
            proximityDisplay.text = "Near (<3m)"
        }
        if sender.currentTitle! == "Far (<10m)" {
            proximity = 3
            proximityDisplay.text = "Far (<10m)"
        }
    }
    
    /**
     *The frequency selection action
     */
    @IBAction func frequencySelection(_ sender: UIButton) {
        frequencyButtons.forEach{ (button) in
            button.isHidden = !button.isHidden
        }
    }
    
    /**
     *The different frequency choices, called when either one selected
     */
    @IBAction func frequencyTapped(_ sender: UIButton) {
        if sender.currentTitle! == "Every 1s" {
            frequency = 1
            frequencyDisplay.text = "Every 1s"
        }
        if sender.currentTitle! == "Every 10s" {
            frequency = 10
            frequencyDisplay.text = "Every 10s"
        }
        if sender.currentTitle! == "Every 30s" {
            frequency = 30
            frequencyDisplay.text = "Every 30s"
        }
        if sender.currentTitle! == "Every 60s" {
            frequency = 60
            frequencyDisplay.text = "Every 60s"
        }
    }
    
    /**
     *The action for select machine, show and hide the drop down
     */
    @IBAction func machineSelection(_ sender: UIButton) {
        machineButtons.forEach{ (button) in
            button.isHidden = !button.isHidden
        }
    }
    
    /**
     *The different machine choices, called when either one selected
     */
    @IBAction func machineTapped(_ sender: UIButton) {
        if sender.currentTitle! == "A" {
            machineDisplay.text = "A"
        }
        if sender.currentTitle! == "B" {
            machineDisplay.text = "B"
        }
        if sender.currentTitle! == "C" {
            machineDisplay.text = "C"
        }
        if sender.currentTitle! == "D" {
            machineDisplay.text = "D"
        }
    }
    
    /**
     *The comparison method, compares the beacons from last fram with that of this frame see if there's any change
     *@param: last - the array of doubles representing the minor id of beacons from last frame
     *@param: current - the array of doubles representing the minor id of beacons from current frame
     *@param: time - the string representing the current time
     *The function changes the console text to report the change
     */
    func compare(lastarray last: [Double]?, with current: [Double], at time: String) {
        //if there wasn't anything back then, directly detect the entrance of beacons
        if last == nil {
            for beacon in current {
                print("\(beacon) enters the region of machine " + machineDisplay.text! + " at " + time)
                console.text = "\(beacon) enters the region of machine " + machineDisplay.text! + "at" + time
            }
        } else {
            //if there was something back then, do the comparison to check if there's something new
        for beacon in current {
            if !(last!.contains(beacon)) {
                print("\(beacon) enters the region of machine " + machineDisplay.text! + " at " + time)
                console.text = "\(beacon) enters the region of machine " + machineDisplay.text! + " at " + time
            }
        }
            // if there was something back then, do the comparison to check if there's something leaving
        for beacon in last! {
            if !(current.contains(beacon)) {
                print("\(beacon) exists the region of machine " + machineDisplay.text! + " at " + time)
                console.text = "\(beacon) exits the region of machine " + machineDisplay.text! + " at " + time
            }
        }
        }
    }
    
    /**
     *The location manager that is ranging the beacons, ranging an array of beacons according to the set frequency
     * and the proximity level, feed them into the compare function to check whether there is any change
     */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //update time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let currenttime = ("\(hour):\(minutes):\(seconds)  \(month)/\(day)/\(year)")
        time.text = currenttime
        
        //filter according to proximity
        if seconds % frequency! == 0 {
            if proximity == 1 {
                let knownBeacons = beacons.filter{ $0.proximity == CLProximity.immediate}
                let knownBeaconMinors = knownBeacons.map{ $0.minor.doubleValue}
                compare(lastarray: lastframe, with: knownBeaconMinors, at: currenttime)
                lastframe = knownBeaconMinors
                print (knownBeacons)
            }
            if proximity == 2 {
                let knownBeacons = beacons.filter{ $0.proximity == CLProximity.immediate
                    || $0.proximity == CLProximity.near
                }
                let knownBeaconMinors = knownBeacons.map{ $0.minor.doubleValue}
                compare(lastarray: lastframe, with: knownBeaconMinors, at: currenttime)
                lastframe = knownBeaconMinors
                print (knownBeacons)
            }
            if proximity == 3 {
                let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown}
                let knownBeaconMinors = knownBeacons.map{ $0.minor.doubleValue}
                compare(lastarray: lastframe, with: knownBeaconMinors, at: currenttime)
                lastframe = knownBeaconMinors
                print (knownBeacons)
            }
//            print (beacons)
        }
    }
}

