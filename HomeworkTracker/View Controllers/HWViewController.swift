//
//  HWViewController.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/29/20.
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import UIKit
import EventKit

class HWViewController: UIViewController {
    var user: User?
    var assignmentName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func intergrateWithCalendar(_ sender: Any) {
        if let sender = sender as? UISwitch {
            if sender.isOn == true {
                let eventStore = EKEventStore()
                
                eventStore.requestAccess(to: .event) { (granted, error) in
                    if granted && error == nil {
                        
                        for assignment in self.user!.assignments {
                            var i = 1
                            let className = assignment.key
                            for assignement in assignment.value {
                                let name = assignement.name
                                let dueDate = assignement.date
                                let event = EKEvent(eventStore: eventStore)
                                event.title = "\(className) \(name)"
                                event.startDate = Date()
                                
                                event.endDate = dueDate
                                event.notes = "\(i) assignment for \(className)"
                                event.calendar = eventStore.defaultCalendarForNewEvents
                                do {
                                    try eventStore.save(event, span: .thisEvent)
                                    i += 1
                                } catch let error as NSError {
                                    print("\(error)")
                                }
                            }
                        }
                    } else {
                        if let error = error {
                            print("\(error)")
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "assigmentToWebView" {
                if let destination = segue.destination as? WebViewController {
                    destination.urlString = self.user?.urls[self.assignmentName!]
                }
            }
        }
    }
}
extension HWViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.classesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "classTableCell", for: indexPath) as? ClassTableViewCell else { return ClassTableViewCell() }
        let className = user!.classesArray[indexPath.row]
        cell.classNameLabel.text = className
        cell.assignments = user!.assignments[className]
        
        cell.didSelectItemAction = { [weak self] assignmentName in
            self?.assignmentName = assignmentName
            self?.performSegue(withIdentifier: "assigmentToWebView", sender: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }}
