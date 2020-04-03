//
//  ClipboardViewController.swift
//  Clipboard
//
//  Created by Gyani, Ravi, SKY on 01.04.20.
//  Copyright © 2020 Gyani, Ravi, SKY. All rights reserved.
//

import Cocoa

class ClipboardViewController: NSViewController {
    var emptyDict: [String: String] = [:]
    
    let prefix = "Clipboard."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key,value)  in UserDefaults.standard.dictionaryRepresentation()
        {
            if(key.hasPrefix(prefix))
            {
                emptyDict[String(key.dropFirst(prefix.count))] = value as? String
            }
        }
        
        
        table.delegate = self
        table.dataSource = self
        
        table.target = self
        table.doubleAction = #selector(tableViewDoubleClick(_:))
        
    }
    
    
    @IBOutlet weak var txtName: NSTextField!
    @IBOutlet weak var txtPassword: NSTextField!
    @IBOutlet weak var table: NSTableView!
    @IBAction func add(_ sender: Any)
    {
        if(txtName.stringValue.isEmpty)
        {
            return;
        }
        
        if(txtPassword.stringValue.isEmpty)
        {
            emptyDict.removeValue(forKey: txtName.stringValue)
            UserDefaults.standard.removeObject(forKey: prefix + txtName.stringValue)
            UserDefaults.standard.synchronize()
        }
        else
        {
            emptyDict[txtName.stringValue] = txtPassword.stringValue
            UserDefaults.standard.setValue(txtPassword.stringValue, forKey: prefix + txtName.stringValue)
            UserDefaults.standard.synchronize()
        }
        
        table.reloadData()
    }
    
    @objc func tableViewDoubleClick(_ sender:AnyObject) {
        
        let keys = Array(emptyDict.keys)
        
        var text: String = ""
        if(table.clickedRow >= 0)
        {
            if table.clickedColumn == 0
            {
                text = keys[table.selectedRow]
            }
            
            if table.clickedColumn == 1
            {
                text = emptyDict[keys[table.selectedRow]] ?? ""
            }
        }
        
        if !text.isEmpty
        {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
        }
    }
}

extension ClipboardViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return emptyDict.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        let keys = Array(emptyDict.keys)
        
        if tableColumn == tableView.tableColumns[0] {
            text = keys[row]
        } else if tableColumn == tableView.tableColumns[1] {
            text = emptyDict[keys[row]]!
        } else if tableColumn == tableView.tableColumns[2] {
            //text = item.isFolder ? "--" : sizeFormatter.string(fromByteCount: item.size)
        }
        
        //        let cell = NSTextField()
        //        cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "my_id")
        //
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        cell.textField?.stringValue = text
        
        return cell
    }
    
    
}


extension ClipboardViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> ClipboardViewController {
        //1.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("ClipboardViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ClipboardViewController else {
            fatalError("Why cant i find ClipboardViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
