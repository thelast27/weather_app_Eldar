//
//  RealmWeatherHistoryVC.swift
//  
//
//  Created by Eldar Garbuzov on 6.07.22.
//

import UIKit
import RealmSwift

class RealmWeatherHistoryVC: UIViewController {
    
    
    @IBOutlet weak var historyTableView: UITableView!

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.register(UINib(nibName: "RealmDBTableViewCell", bundle: nil), forCellReuseIdentifier: "RealmDBTableViewCell")
        
        notificationToken = resultsRealmData.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.historyTableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
        historyTableView.reloadData()
    } //end of view did load
    
    deinit {
        notificationToken?.invalidate()
    }
    
} // end of class

extension RealmWeatherHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsRealmData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: "RealmDBTableViewCell", for: indexPath) as? RealmDBTableViewCell else { return UITableViewCell() }
        cell.configuration(data: resultsRealmData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyTableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let editingRow = resultsRealmData[indexPath.row]
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in
//            try! self.realm.write {
//                self.realm.delete(editingRow)
//            }
//        }
//        return [deleteAction]
//    }
}


