//
//  DiaryContentViewController.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit

class DiaryContentViewController: UIViewController {
    
    var temp : String?
    var pressure : String?
    var red : String?
    var green : String?
    var blue : String?
    var date : String?
    
    
    @IBOutlet weak var diaryTitle: UITextField!
    
    @IBOutlet weak var diaryContent: UITextField!
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    
    @IBAction func createDiary(_ sender: Any) {
        
        if diaryTitle.text != "" && diaryContent.text != "" {
            let title = diaryTitle.text!
            let content = diaryContent.text!
            let _ = databaseController!.addDiary(title: title, content: content, date: date!, red: red!, green: green!, blue: blue!, temp: temp!, pressure: pressure!)
            navigationController?.popViewController(animated: true)
            return
        }
        
        var errorMsg = "Please ensure all fields are filled:\n"
        
        if diaryTitle.text == "" {
            errorMsg += "- Must provide a title\n"
        }
        if diaryContent.text == "" {
            errorMsg += "- Must provide content"
        }
        
        displayMessage(title: "Not all fields filled", message: errorMsg)
        
    }
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
