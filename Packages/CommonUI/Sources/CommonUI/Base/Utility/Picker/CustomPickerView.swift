import UIKit

class CustomPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    private var pickerHandler: (([String]) -> Void)?
    private var selectedIndexHandler: ((Int) -> Void)?
    private var pickerComponent: [[String]] = []
    private var selectedRow: [String] = []
    
    // MARK: - Initialise
    convenience init(pickerComponent: [String], selectedIndexHandler: ((Int) -> Void)?) {
        self.init()
        self.selectedIndexHandler = selectedIndexHandler
        self.commonInit([pickerComponent])
    }

    convenience init(pickerComponent: [[String]], pickerHandler: (([String]) -> Void)?) {
        self.init()
        self.pickerHandler = pickerHandler
        self.commonInit(pickerComponent)
    }
    
    func commonInit(_ pickerComponent: [[String]]) {
        self.delegate = self
        self.dataSource = self
        self.pickerComponent = pickerComponent
        self.frame.size.height = 200.0
                
        //-- Setup selected row
        for component in pickerComponent {
            if component.count > 0 {
                selectedRow.append(component.first!)
            } else{
                selectedRow.append("")
            }
        }
    }
    
    //-- UIPickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerComponent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerComponent[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerComponent[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerComponent[component][row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerComponent.count > 0 && pickerComponent[component].count > 0 {
            self.selectedRow[component] = pickerComponent[component][row]
            pickerHandler?(selectedRow)
            selectedIndexHandler?(row)
        }
    }
    
    //MARK: - Access value
    func valueAt(indexPath: IndexPath) -> String {
        return pickerComponent[indexPath.section][indexPath.row]
    }
    
    func selectRow(item: String, inComponent: Int) {
        if let row = pickerComponent[inComponent].firstIndex(of: item) {
            self.selectRow(row, inComponent: inComponent, animated: false)
        }
    }
}

class CustomDatePicker: UIDatePicker {

    var handler: (Date) -> ()
    
    init(handler: @escaping (Date) -> ()) {
        self.handler = handler
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        
        self.date = Date()
        self.datePickerMode = .date
        self.preferredDatePickerStyle = .wheels
        self.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func valueChanged(_ : Any) {
        handler(self.date)
    }
}
