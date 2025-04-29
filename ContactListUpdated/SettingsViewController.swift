//
//  SettingsViewController.swift
//  ContactListUpdated
//
//  Created by Alex Bringuel on 4/7/25.
//

import UIKit
import CoreMotion


class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var topView: UIView!
    @IBOutlet weak var pckSortField: UIPickerView!
    @IBOutlet weak var swAscending: UISwitch!
    
    @IBOutlet weak var lblBattery: UILabel!
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday", "email"]
    
    
    func updateLabel(data: CMAccelerometerData){
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let moveFactor: Double = 15.0
        var rect = lblBattery.frame
        let moveToX = Double(rect.origin.x) + data.acceleration.x * moveFactor
        let moveToY = Double(rect.origin.y + rect.size.height) - data.acceleration.y * moveFactor
        let maxX = Double(topView.frame.size.width - rect.width)
        let maxY = Double(topView.frame.size.height - tabBarHeight!)
        let minY = Double(rect.size.height + statusBarHeight)
        if (moveToX > 0 && moveToX < maxX) {
            rect.origin.x = CGFloat(data.acceleration.x * moveFactor)
        }
        if (moveToY > minY && moveToY < maxY) {
            rect.origin.y -= CGFloat(data.acceleration.y * moveFactor)
        }
        UIView.animate(withDuration: TimeInterval(0), delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {self.lblBattery.frame = rect}, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool){
        let device = UIDevice.current
        let orientation: String
        
        switch device.orientation {
        case .faceDown:
            orientation = "Face Down"
        case .landscapeLeft:
            orientation = "Landscape left"
        case .portrait:
            orientation = "Portrait"
        case .landscapeRight:
            orientation = "Landscape right"
        case .faceUp:
            orientation = "Face Up"
        case .portraitUpsideDown:
            orientation = "Portrait Upside Down"
        case .unknown:
            orientation = "Unknown Orientation"
        default:
            fatalError()
        }
        
        print("Orientation: \(orientation)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startMotionDetection()


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIDevice.current.isBatteryMonitoringEnabled = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.motionManager.stopAccelerometerUpdates()
    }
    
    
    func startMotionDetection() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mManager = appDelegate.motionManager
        if mManager.isAccelerometerAvailable {
            mManager.accelerometerUpdateInterval = 0.5
            mManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if let data = data {
                    self.updateLabel(data: data)
                }
            }
        }
    }

    
    
    

    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pckSortField.dataSource = self
        pckSortField.delegate = self
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        self.batteryChanged()
        
    }
    
    @objc func batteryChanged() {
        let device = UIDevice.current
        var batteryState: String
        switch (device.batteryState) {
        case .charging:
            batteryState = "+"
        case .full:
            batteryState = "!"
        case .unplugged:
            batteryState = "-"
        case .unknown:
            batteryState = "?"
        }
        
        let batteryLevelPercent = device.batteryLevel * 100
        let batteryLevel = String(format: "%.0f%%", batteryLevelPercent)
        let batteryStatus = "\(batteryState) \(batteryLevel)"
        lblBattery.text = batteryStatus
    }


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
}

