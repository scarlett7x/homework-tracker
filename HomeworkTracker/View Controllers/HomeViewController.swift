//
//  HomeViewController.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/16/20.
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var classesTableView: UITableView!
    
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        user?.getClasses()  { () in
            // now update UI on main thread
            self.classesTableView.reloadData()
        }
        classesTableView.delegate = self
        classesTableView.dataSource = self
        classesTableView.tableFooterView = UIView(frame: CGRect.zero)
        addButton.layer.cornerRadius = 7
        updateButton.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        insertNewClass()
    }
    
    func insertNewClass() {
        guard let className = classTextField.text else { return }
        guard let classUrl = urlTextField.text else { return }
        if className != "" || classUrl != "" {
            if let setHasClassName = user?.classesSet.contains(className) {
                if !setHasClassName == true {
                    user?.classesSet.insert(className)
                    user?.classesArray.append(className)
                    user?.apiCall(classname: className, url: classUrl)
                    let indexPath = IndexPath(row: (user?.classesArray.count ?? 1) - 1, section: 0)
                    classesTableView.beginUpdates()
                    classesTableView.insertRows(at: [indexPath], with: .automatic)
                    classesTableView.endUpdates()
                    
                }
            }
        }
        classTextField.text = ""
        urlTextField.text = ""
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "dashboardToHW" {
                if let destination = segue.destination as? HWViewController {
                    destination.user = self.user
                }
            }
        }
    }
    
    @IBAction func updateClasses(_ sender: Any) {
        self.user?.storeClasses()
        self.performSegue(withIdentifier: "dashboardToHW", sender: self)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.classesArray.count
        //sampleClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as? DashboardTableViewCell
        cell?.classNameLabel.text = user?.classesArray[indexPath.row]
        //sampleClasses[indexPath.row]
        cell?.classNameLabel.font =  cell?.classNameLabel.font.withSize(20)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            user?.classesSet.remove((user?.classesArray[indexPath.row])!)
            user?.classesArray.remove(at: indexPath.row)
            classesTableView.beginUpdates()
            classesTableView.deleteRows(at: [indexPath], with: .automatic)
            classesTableView.endUpdates()
        }
    }
}
