//
//  ViewController.swift
//  GenericDataSourceExample
//
//  Created by Rich Long on 19/07/2018.
//  Copyright © 2018 Bipsync LTD. All rights reserved.
//

import UIKit

enum SortMenuOptions: String, CaseIterable {
    case newestFirst = "Newest First"
    case oldestFirst = "Oldest First"
    case recentlyUpdatedFirst = "Recently Updated First"
    case highestPriorityFirst = "Highest Priority First"
}

class ViewController: UIViewController, GenericPickerDataSourceDelegate {

    @IBOutlet weak var pickerView: UIPickerView!

    var dataSource: GenericPickerDataSource<SortMenuOptions>?

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = SortMenuOptions.allCases.map {
            GenericRow<SortMenuOptions>(type: $0, title: $0.rawValue)
        }

        dataSource = GenericPickerDataSource<SortMenuOptions>(withItems: items)
        pickerView.delegate = dataSource
        pickerView.dataSource = dataSource
        dataSource?.delegate = self
    }

    func selected(item: Any) {
        if let selectedItem = item as? SortMenuOptions {
            print(selectedItem)
        }
    }

}

struct GenericRow<T> {
    let type: T
    let title: String
}

protocol GenericPickerDataSourceDelegate: AnyObject {
    func selected(item: Any)
}

/**
 The aim of this class is to use a set of enums as a pickerView data source, instead of creating multiple classes
 We use generics to populate this class.
 */
class GenericPickerDataSource<T>: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    var items: [GenericRow<T>]
    weak var delegate: GenericPickerDataSourceDelegate?

    init(withItems items: [GenericRow<T>]) {
        self.items = items
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.selected(item: items[row].type)
    }
}
