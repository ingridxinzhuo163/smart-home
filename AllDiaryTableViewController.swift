//
//  AllDiaryTableViewController.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit

class AllDiaryTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    

    

    let SECTION_DIARY = 0;
    let SECTION_COUNT = 1;
    let CELL_DIARY = "diaryCell"
    let CELL_COUNT = "totalDiaryCount"
    var selectedDiary:Diary?
    
    var allDiaries: [Diary] = []
    var filteredDiary: [Diary] = []
    weak var dairyDelegate: AddDiaryDelegate?
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Heroes"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredDiary = allDiaries.filter({(diary: Diary) -> Bool in
                return diary.title.lowercased().contains(searchText)
            })
        }
        else {
            filteredDiary = allDiaries;
        }
        
        tableView.reloadData();
    }
    
    // MARK: - Database Listener
    
    var listenerType = ListenerType.diary
    
    func onDiaryListChange(change: DatabaseChange, diaries: [Diary]) {
        allDiaries = diaries
        updateSearchResults(for: navigationItem.searchController!)

    }
    
    func onRgbChange(change: DatabaseChange, rgb: Rgb) {
        
    }
    
    func onWeatherChange(change: DatabaseChange, weather: Weather) {
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_DIARY {
            return filteredDiary.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_DIARY {
            let diaryCell = tableView.dequeueReusableCell(withIdentifier: CELL_DIARY, for: indexPath) as! DiaryTableViewCell
            let diaryOne = filteredDiary[indexPath.row]
            
            diaryCell.diaryTitle.text = diaryOne.title
            diaryCell.diaryDate.text = diaryOne.date
            
            return diaryCell

        }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        countCell.textLabel?.text = "\(allDiaries.count) daires in the database"
        countCell.selectionStyle = .none
        return countCell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDiary = filteredDiary[indexPath.row]
        performSegue(withIdentifier: "viewDetail", sender: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
        let diaryDelete = filteredDiary[indexPath.row]
        databaseController?.deleteDiary(diary: diaryDelete)
     }
        
     }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetail" {
            let controller = segue.destination as! DiaryDetailViewController
            controller.diarySelected = self.selectedDiary!
        }
    }
    
    
}
