//
//  PlacesTableViewController.swift
//  Saving Places
//
//  Created by Christian Alvarez on 12/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    private var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        self.tableView.reloadData()
    }

    //MARK: - Data populators
    
    private func loadData() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Place] {
            places = data
            print("Data unarchived!")
        } else {
            print("No data unarchivable")
        }
    }
    
    private func saveData() {
        NSKeyedArchiver.archiveRootObject(places, toFile: filePath)
    }
    
    var filePath: String {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url?.appendingPathComponent("Places").path)!
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name ?? "Error getting cell name"
        
        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            saveData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ViewController {
            destinationVC.places = self.places
            if tableView.indexPathForSelectedRow != nil {
               destinationVC.placeSelected = places[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    

}
