//
//  CellWrapper.swift
//  FreshBox
//
//  Created by Seydoux on 2021/10/22.
//

//import Foundation

// 사진

// 추적
// 이름
// 메모

// 양
// 위치

// 유통기한
// 구매일자
import UIKit

class AddItemCell: NSObject {
    var cell: UITableViewCell
    
    init (_ cell: UITableViewCell) {
        self.cell = cell
    }
}
class AddItemPhotoCell: AddItemCell {
    // TODO: add context menu
    var button: UIButton?
    var image: UIImage?
    var imageName: String?
    
    init (_ cell: UITableViewCell, _ buttonTitle: String) {
        let button = UIButton()
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        
        cell.contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20.0).isActive = true
        
        self.button = button
        super.init(cell)
    }
}

class AddItemImageCell: AddItemCell {
//    var image: UIImage?

    init (_ cell: UITableViewCell, _ image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        
        cell.contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        super.init(cell)
    }
}

class AddItemTextFieldCell: AddItemCell {
    var textField: UITextField
    
    init (_ cell: UITableViewCell, _ placeholderText: String) {
        let textField = UITextField()
        textField.placeholder = placeholderText
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        cell.contentView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20.0).isActive = true
        textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20.0).isActive = true
        textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        
        self.textField = textField
        super.init(cell)
    }
}

class FavoriteFieldCell: AddItemCell {
    var fSwitch: UISwitch
    
    init (_ cell: UITableViewCell, _ labelText: String) {
        let fLabel = UILabel()
        fLabel.text = labelText
        
        let fSwitch = UISwitch()
        fSwitch.isOn = false
        
        cell.contentView.addSubview(fLabel)
        cell.contentView.addSubview(fSwitch)
        
        fLabel.translatesAutoresizingMaskIntoConstraints = false
        fLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        fLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20.0).isActive = true
        
        fSwitch.translatesAutoresizingMaskIntoConstraints = false
        fSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        fSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20.0).isActive = true
        
        self.fSwitch = fSwitch
        super.init(cell)
        self.cell = cell
    }
}
class AddItemStepperCell: AddItemCell {
    var valueLabel: UILabel
    
    init (_ cell: UITableViewCell, _ labelText: String) {
        let titleLabel = UILabel()
        titleLabel.text = labelText
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        let decreaseBtn = UIButton()
        decreaseBtn.setTitle("-", for: .normal)
        decreaseBtn.setTitleColor(.systemBlue, for: .normal)
        stackView.addArrangedSubview(decreaseBtn)
        
        let valueLabel = UILabel()
        valueLabel.text = String(0)
        stackView.addArrangedSubview(valueLabel)
        
        let increaseBtn = UIButton()
        increaseBtn.setTitle("+", for: .normal)
        increaseBtn.setTitleColor(.systemBlue, for: .normal)
        stackView.addArrangedSubview(increaseBtn)
        
        decreaseBtn.addAction(UIAction(handler: { _ in
            if Int(valueLabel.text!)! > 0 {
                valueLabel.text = String( Int(valueLabel.text!)! - 1 )
            }
        }), for: .touchUpInside)
        increaseBtn.addAction(UIAction(handler: { _ in
            valueLabel.text = String( Int(valueLabel.text!)! + 1 )
        }), for: .touchUpInside)
        
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20.0).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20.0).isActive = true
        
        self.valueLabel = valueLabel
        super.init(cell)
    }
}

class AddItemDateCell: AddItemCell {
    var date: Date
    
    init (_ cell: UITableViewCell, _ titleString: String) {
        cell.detailTextLabel!.textColor = .systemBlue
        let titleLabel = UILabel()
        titleLabel.text = titleString
        
        cell.contentView.addSubview(titleLabel)
//        cell.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20.0).isActive = true
        
        self.date = Date()
        super.init(cell)
        cell.detailTextLabel!.text = self.dateFormatter(self.date)
    }
    func setDateLabel() {
        self.cell.detailTextLabel!.text = self.dateFormatter(self.date)
    }
    
    func dateFormatter(_ date: Date) -> String {
        let dateArray = date.formatted(date: .numeric, time: .omitted).split{$0=="/"}
        return String(dateArray[0] + "년 " + dateArray[1] + "월 " + dateArray[2] + " 일")
    }
}

class AddItemDatePickerCell: AddItemCell {
    var datePicker: UIDatePicker
    
    override init (_ cell: UITableViewCell) {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        
        cell.contentView.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalTo: cell.heightAnchor, constant: 0).isActive = true
        
        self.datePicker = datePicker
        super.init(cell)
    }
}

class AddItemSegmentCell: AddItemCell {
    var position: [String] = ["냉장", "냉동", "실온"]
    var segment: UISegmentedControl
    
    init (_ cell: UITableViewCell, _ titleString: String) {
        let title = UILabel()
        title.text = titleString
        let segment = UISegmentedControl(items: position)
        segment.selectedSegmentIndex = 0
        
        cell.contentView.addSubview(title)
        cell.contentView.addSubview(segment)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20.0).isActive = true
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        segment.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20.0).isActive = true
        
        self.segment = segment
        super.init(cell)
    }
}
