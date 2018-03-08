//
//  RecordViewController.swift
//  iBeaconProj
//
//  Created by Edward Feng on 2/8/18.
//  Copyright © 2018 Edward Feng. All rights reserved.
//

import UIKit
import CoreData

class RecordViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var records = [Record]()

    @IBAction func DeleteAllRecords(_ sender: Any) {
        let alert = UIAlertController(title: "Deletion Confirmation", message: "Are you sure you want to delete all history?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (_) in
            for record in self.records {
                PersistenceService.context.delete(record)
            }
            self.records = []
            self.tableView.reloadData()
        }
        let regret = UIAlertAction(title: "No", style: .default)
        alert.addAction(action)
        alert.addAction(regret)
        present(alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()

        do {
            let fetchedRecords = try PersistenceService.context.fetch(fetchRequest)
            self.records = fetchedRecords
            print ("fetched data successfully")
            for record in self.records {
                print (record.text!)
            }
            self.tableView.reloadData()
            print ("data reloaded")
        } catch {

        }
        
    }
}

extension RecordViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = records[indexPath.row].text
        cell.detailTextLabel?.text = ""
        return cell
    }
}
