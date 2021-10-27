//
//  ItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/18.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var realm = try! Realm()
    var items: Results<Item>?
    var selectedFridge: Fridge?
    
    var itemss: List<Item>?
    var testFridge: Results<Fridge>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = selectedFridge!.name
        self.loadData()
    }
    
    func loadData() {
        itemss = realm.objects(Fridge.self).filter("id == \(selectedFridge!.id)").first?.items
//        items = selectedFridge?.items
        
        
        tableView.reloadData()
        print(itemss)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addItemVC = segue.destination as! AddItemViewController
        addItemVC.currentFridge = selectedFridge!
    }
}
extension ItemViewController: UITableViewDelegate {
    
}
extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        return cell
    }
    
    
}
extension ItemViewController: UISearchBarDelegate {
}
