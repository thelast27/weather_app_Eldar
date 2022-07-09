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
    
    var realmManager: RealmDataBaseProtocol = RealmManager()
    var array: [WeatherForRealm] = []
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
       
        historyTableView.register(UINib(nibName: "RealmDBTableViewCell", bundle: nil), forCellReuseIdentifier: "RealmDBTableViewCell")
        update()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .databaseUpdated, object: nil)
        
    } //end of view did load

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func update() {
        array = self.realmManager.giveData()
        historyTableView.reloadData()
    }
} // end of class

extension RealmWeatherHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: "RealmDBTableViewCell", for: indexPath) as? RealmDBTableViewCell else { return UITableViewCell() }
        cell.configuration(data: array[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyTableView.deselectRow(at: indexPath, animated: true)
    }
}


