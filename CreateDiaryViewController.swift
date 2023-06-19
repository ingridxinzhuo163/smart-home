//
//  CreateDiaryViewController.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit


class CreateDiaryViewController: UIViewController{
    
    
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var colorSet: UIView!
    
    
    private var datePicker: UIDatePicker?
    
    weak var databaseController: DatabaseProtocol?
    
    var weatherOne = Weather()
    var rgbOne = Rgb()
    var red: String?
    var green: String?
    var blue: String?
    
    @IBAction func getWeather(_ sender: Any) {
        
        
        temp.text = weatherOne.temp
        pressure.text = weatherOne.pressure
        print("temp: \(weatherOne.temp)")
        print("pressure: \(weatherOne.pressure)")
        weatherOne = databaseController!.getWeather()
        
    }
    
    @IBAction func getColor(_ sender: Any) {
        red = rgbOne.red
        green = rgbOne.green
        blue = rgbOne.blue
        let clearRed = Double(red!)!.squareRoot()
        let clearGreen = Double(green!)!.squareRoot()
        let clearBlue = Double(blue!)!.squareRoot()
        loadColor(clearRed: clearRed,clearGreen: clearGreen,clearBlue: clearBlue)
        rgbOne = databaseController!.getRgb()
    }
    
    func loadColor(clearRed:Double, clearGreen:Double,clearBlue:Double){
        colorSet.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        colorSet.backgroundColor = UIColor(red: CGFloat(clearRed/256), green: CGFloat(clearGreen/256), blue: CGFloat(clearBlue/256), alpha: 1.0)
        view.addSubview(colorSet)
        colorSet.layer.cornerRadius = 8
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        weatherOne = databaseController!.getWeather()
        rgbOne = databaseController!.getRgb()

//        // Do any additional setup after loading the view.
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        date.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date.text = dateFormatter.string(from: datePicker.date)
    }

    @objc func viewTaped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContent" {
            let controller = segue.destination as! DiaryContentViewController
            controller.temp = temp.text
            controller.pressure = pressure.text
            controller.red = red
            controller.blue = blue
            controller.green = green
            controller.date = date.text
        }
    }

}
