//
//  DiaryDetailViewController.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    var diarySelected: Diary?
    
    @IBOutlet weak var color: UIView!
    
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        if diarySelected != nil{
            titleLabel?.text = diarySelected?.title
            dateLabel?.text = diarySelected?.date
            contentLabel.text = diarySelected?.content
            tempLabel.text = diarySelected?.temp
            pressureLabel.text = diarySelected?.pressure
            //photo.image = UIImage(named: annotation!.siteFile!)
            contentLabel.numberOfLines = 0
            contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            let clearRed = Double(diarySelected!.red)!.squareRoot()
            let clearGreen = Double(diarySelected!.green)!.squareRoot()
            let clearBlue = Double(diarySelected!.blue)!.squareRoot()
            
            loadColor(clearRed: clearRed,clearGreen: clearGreen,clearBlue: clearBlue)
        }
    }
    
    func loadColor(clearRed:Double, clearGreen:Double,clearBlue:Double){
        color.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        color.backgroundColor = UIColor(red: CGFloat(clearRed/256), green: CGFloat(clearGreen/256), blue: CGFloat(clearBlue/256), alpha: 1.0)
        view.addSubview(color)
        color.layer.cornerRadius = 8
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
