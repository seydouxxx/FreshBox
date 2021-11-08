//
//  ItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/18.
//

import UIKit
import RealmSwift
import UserNotifications

class ItemViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var realm = try! Realm()
    var items: Results<Item>?
    var filteredItems: Results<Item>?
    var searchedItems: Results<Item>?
    var selectedFridge: Fridge?
    //0: 이름순, 1: 유통기한 임박순, 2: 등록일순
    var currentSort = 0
    var currentSegment = 0
    var currentKeyword = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.rowHeight = 100
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        title = selectedFridge!.name
        self.loadData()
        
        setKeyboardDismiss()
        self.tableView.keyboardDismissMode = .onDrag
        
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        searchBar.placeholder = "검색"
        searchBar.searchTextField.textAlignment = .center
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        
        // 앱 알림 관련
    }
    // 필드 이외 화면 클릭 시 키보드 dismiss
    func setKeyboardDismiss() {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        touchGesture.isEnabled = true
        touchGesture.cancelsTouchesInView = false
        touchGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(touchGesture)
    }
    @objc func keyboardDismiss () {
        self.view.endEditing(true)
    }
    
    //MARK: - Load Data From Realm
    func loadData() {
        items = selectedFridge?.items.sorted(byKeyPath: "name")
        if currentKeyword.count == 0 {
            filteredItems = items
        } else {
            filteredItems = items!.filter("name CONTAINS[cd] %@", currentKeyword)
        }
        filteredItems = filterItems(filteredItems!, by: currentSegment)
        filteredItems = sortItems(filteredItems!, by: currentSort)
        tableView.reloadData()
    }
    // 결과 정렬
    func sortItems(_ items: Results<Item>, by standard: Int) -> Results<Item> {
        switch standard {
        case 0:
            return items.sorted(byKeyPath: "expireDate", ascending: true)
        case 1:
            return items.sorted(byKeyPath: "name", ascending: true)
        case 2:
            return items.sorted(byKeyPath: "createdDate", ascending: true)
        default: break
        }
        return items
    }
    func filterItems(_ items: Results<Item>, by location: Int) -> Results<Item> {
        switch location {
        case 0:
            currentSegment = 0
            return items
        case 1:
            currentSegment = 1
            return items.filter("itemLocation == 0")
        case 2:
            currentSegment = 2
            return items.filter("itemLocation == 1")
        case 3:
            currentSegment = 3
            return items.filter("itemLocation == 2")
        default: break
        }
        return items
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "AddItemSegue":
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.currentFridge = selectedFridge!
            addItemVC.parentVC = self
        case "ItemDetailSegue":
            let itemDetailVC = segue.destination as! ItemDetailViewController
            itemDetailVC.parentVC = self
        default:
            break
        }
    }
}
extension ItemViewController: UITableViewDelegate {
    
}
extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        guard let item = filteredItems?[indexPath.row] else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.titleLabel.text = item.name
        cell.memoLabel.text = item.memo
        cell.foodImageView.image = ImageFileManager.shared.loadImage(name: item.itemThumbnail)
        cell.quantityLabel.text = String(item.quantity)
        cell.alertBtn.setImage(UIImage(systemName: item.favorite ? "bell.fill" : "bell"), for: .normal)

        let expireLeft = Int(trunc((item.expireDate.timeIntervalSince1970 - Date().timeIntervalSince1970)/60/60/24))
        if expireLeft > 0 {
            // 유통기한 아직 남음
            cell.expireDateLabel.text = "\(expireLeft)일 남음   "
        } else if expireLeft == 0 {
            // 유통기한 당일
            cell.expireDateLabel.text = "오늘까지   "
        } else {
            // 유통기한 지남
            cell.expireDateLabel.text = "\(abs(expireLeft))일 경과   "
        }
        
        cell.increaseQuantity = { [unowned self] in
            do {
                try self.realm.write {
                    self.items?.filter("id == %@", item.id).setValue(item.quantity+1, forKey: "quantity")
                }
            } catch {
                print("Error occured in editing database. \(error)")
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.decreaseQuantity = { [unowned self] in
            if item.quantity > 0 {
                do {
                    try self.realm.write {
                        self.items?.filter("id == %@", item.id).setValue(item.quantity-1, forKey: "quantity")
                    }
                } catch {
                    print("Error occured in editing database. \(error)")
                }
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        cell.toggleAlert = { [unowned self] in
            do {
                try self.realm.write {
                    self.items?.filter("id == %@", item.id).setValue(!item.favorite, forKey: "favorite")
                }
            } catch {
                print("Error occured in editing database. \(error)")
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemDetailSegue", sender: nil)
    }
    
    @objc func quantityBtnPressed(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let filterView = UIStackView()
            filterView.axis = .vertical
            filterView.alignment = .center
            filterView.distribution = .fillEqually
//            filterView.spacing = 5
            
            let segmentControl = UISegmentedControl(items: ["모두", "냉장", "냉동", "실온"])
            segmentControl.selectedSegmentIndex = currentSegment
//            segmentControl.layer.cornerRadius = segmentControl.bounds.height/2
//            segmentControl.layer.borderWidth = 1.0
//            segmentControl.layer.borderColor = UIColor.white.cgColor
//            segmentControl.layer.masksToBounds = true
//            segmentControl.clipsToBounds = true
            segmentControl.addTarget(self, action: #selector(self.segmentControlChanged(_:)), for: .valueChanged)
            
            let btnView = UIView()
            let filterBtn = UIButton()
            switch currentSort {
            case 1: filterBtn.setTitle("이름순 ↓", for: .normal)
            case 2: filterBtn.setTitle("등록일순 ↓", for: .normal)
            default: filterBtn.setTitle("유통기한 임박순 ↓", for: .normal)
            }
            filterBtn.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize*0.9)
            filterBtn.setTitleColor(UIColor.systemBlue, for: .normal)
            filterBtn.addTarget(self, action: #selector(filterBtnPressed(_:)), for: .touchUpInside)
            btnView.addSubview(filterBtn)
            
            filterBtn.translatesAutoresizingMaskIntoConstraints = false
            filterBtn.trailingAnchor.constraint(equalTo: btnView.trailingAnchor).isActive = true
            filterBtn.centerYAnchor.constraint(equalTo: btnView.centerYAnchor).isActive = true
            
            filterView.addArrangedSubview(segmentControl)
            filterView.addArrangedSubview(btnView)
            
            segmentControl.translatesAutoresizingMaskIntoConstraints = false
            segmentControl.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 20.0).isActive = true
            segmentControl.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -20.0).isActive = true
            
            btnView.translatesAutoresizingMaskIntoConstraints = false
            btnView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 20.0).isActive = true
            btnView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -20.0).isActive = true
            
            filterView.layer.borderColor = UIColor.clear.cgColor
            return filterView
        }
        return UIView()
    }
    // 필터버튼 핸들러
    @objc func filterBtnPressed(_ btn: UIButton) {
        
        let sheet = UIAlertController(title: "정렬 방식", message: "", preferredStyle: .actionSheet)
        let sortByExpireDate = UIAlertAction(title: "유통기한 임박순", style: .default) { action in
            self.currentSort = 0
            self.loadData()
        }
        let sortByName = UIAlertAction(title: "이름순", style: .default) { action in
            self.currentSort = 1
            self.loadData()
        }
        let sortByCreatedDate = UIAlertAction(title: "등록일순", style: .default) { action in
            self.currentSort = 2
            self.loadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        sheet.addAction(sortByExpireDate)
        sheet.addAction(sortByName)
        sheet.addAction(sortByCreatedDate)
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true, completion: nil)
    }
    // 세그먼트 핸들러
    @objc func segmentControlChanged(_ seg: UISegmentedControl) {
        currentSegment = seg.selectedSegmentIndex
        loadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
}

// 검색창 델리게이트
extension ItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            currentKeyword = searchText
            loadData()
        } else if searchBar.text?.count == 0 {
            currentKeyword = ""
            loadData()
        }
    }
}
