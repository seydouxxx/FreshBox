//
//  AddItemViewController.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/19.
//
//  데이트피커 선택 시 레이블 변경
//  데이트피커 선택 시 셀 삭제
import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var currentFridge: Fridge?
    let sectionName: [String] = ["photo", "name", "storeDetail", "dateDetail"]
    let cellName: [[String]] = [["photo"], ["favorite", "name", "memo"], ["quantity", "location"], ["expire date", "boughtDate"]]
    var isExpanded: [Bool] = [false, false]
    struct CellStruct {
        var photoCell: AddItemPhotoCell?
        var favoriteCell: FavoriteFieldCell?
        var titleCell: AddItemTextFieldCell?
        var memoCell: AddItemTextFieldCell?
        var countCell: AddItemStepperCell?
        var expDateCell: AddItemDateCell?
        var expPickerCell: AddItemDatePickerCell?
        var buyDateCell: AddItemDateCell?
        var buyPickerCell: AddItemDatePickerCell?
    }
    var cells: CellStruct!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        print(currentFridge!.name)
        cells = CellStruct()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitBtnPressed(_ sender: UIBarButtonItem) {
        // need to do form validation
        
        
    }
}
extension AddItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            if isExpanded[0], isExpanded[1] {
                return cellName[section].count + 2
            } else if isExpanded[0] || isExpanded[1] {
                return cellName[section].count + 1
            } else {
                return cellName[section].count
            }
        }
        return cellName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cell = UITableViewCell()
        cell.isUserInteractionEnabled = true
//        print(indexPath.row)
        
        switch indexPath.section {
        case 0:
            let photoCell = AddItemPhotoCell(cell, "사진 추가")
            cells.photoCell = photoCell
            cell = photoCell.cell
        case 1:
            if indexPath.row == 0 {
                let favoriteCell = FavoriteFieldCell(cell, "즐겨찾기")
                cells.favoriteCell = favoriteCell
                cell = favoriteCell.cell
                
            } else if indexPath.row == 1 {
                let nameCell = AddItemTextFieldCell(cell, "이름")
                cells.titleCell = nameCell
                cell = nameCell.cell
                
            } else if indexPath.row == 2 {
                let memoCell = AddItemTextFieldCell(cell, "메모")
                cells.memoCell = memoCell
                cell = memoCell.cell
            }
        case 2:
            if indexPath.row == 0 {
                let quantityCell = AddItemStepperCell(cell, "수량")
                cells.countCell = quantityCell
                cell = quantityCell.cell
            } else if indexPath.row == 1 {
                // TODO: 보관 장소 선택
                
            }
        case 3:
            if indexPath.row == 0 {
                
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                let expireDateCell = AddItemDateCell(cell, "유통기한")
                cells.expDateCell = expireDateCell
                cell = expireDateCell.cell
                
            } else if indexPath.row == 1 {
                if isExpanded[0] {
                    
                    let expireDatePickerCell = AddItemDatePickerCell(cell)
                    expireDatePickerCell.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
                    
                    cells.expPickerCell = expireDatePickerCell
                    cell = expireDatePickerCell.cell
                    
                } else {
                    
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                    let boughtDateCell = AddItemDateCell(cell, "구매일자")
                    cells.buyDateCell = boughtDateCell
                    cell = boughtDateCell.cell
                    
                }
                
            } else if indexPath.row == 2 {
                if isExpanded[0] {
                    
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                    let boughtDateCell = AddItemDateCell(cell, "구매일자")
                    cells.buyDateCell = boughtDateCell
                    cell = boughtDateCell.cell
                } else {
                    
                    let boughtDatePickerCell = AddItemDatePickerCell(cell)
                    boughtDatePickerCell.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
                    cells.buyPickerCell = boughtDatePickerCell
                    cell = boughtDatePickerCell.cell
                    
                }
            } else if indexPath.row == 3 {
                
                let boughtDatePickerCell = AddItemDatePickerCell(cell)
                boughtDatePickerCell.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
                cells.buyPickerCell = boughtDatePickerCell
                cell = boughtDatePickerCell.cell
                
            }
        default: break
        }
        
        cell.backgroundColor = .blue.withAlphaComponent(0.2)
        cell.selectionStyle = .none
        return cell
    }
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        
        if let expPicker = cells.expPickerCell, let expDate = cells.expDateCell {
            expDate.cell.detailTextLabel?.text = dateFormatter(expPicker.datePicker.date)
        }
        if let buyPicker = cells.buyPickerCell, let buyDate = cells.buyDateCell {
            buyDate.cell.detailTextLabel?.text = dateFormatter(buyPicker.datePicker.date)
        }
    }
    func dateFormatter(_ date: Date) -> String {
        let dateArray = date.formatted(date: .numeric, time: .omitted).split{$0=="/"}
        return String(dateArray[2] + "년 " + dateArray[0] + "월 " + dateArray[1] + " 일")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var row2 = 2
        if isExpanded[0] {
            row2 += 1
            if indexPath.section == 3, indexPath.row == 1 {
                return 250
            }
        }
        if isExpanded[1] {
            if indexPath.section == 3, indexPath.row == row2 {
                return 250
            }
        }
        return tableView.rowHeight
    }
    
    // 날짜 셀 클릭시 expand
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var row2 = 1
        
        if isExpanded[0] {
            row2 += 1
        }
        if indexPath.section == 3, indexPath.row == 0 {
            isExpanded[0] = !isExpanded[0]
            if isExpanded[0] {
                
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 1, section: 3)], with: .fade)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [IndexPath(row: 1, section: 3)], with: .fade)
                tableView.endUpdates()
            }
        } else if indexPath.section == 3, indexPath.row == row2 {
            isExpanded[1] = !isExpanded[1]
            if isExpanded[1] {
                
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: row2+1, section: 3)], with: .fade)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [IndexPath(row: row2+1, section: 3)], with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
}
