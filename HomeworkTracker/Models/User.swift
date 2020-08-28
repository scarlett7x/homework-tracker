//
//  User.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/16/20.
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import Foundation
import Firebase

let sampleClasses = ["EECS16B", "CS61B", "iOS Decal"]

struct Assignment {
    var name: String
    var date: Date
    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
}
let datee = Calendar.current.date(byAdding: .day, value: 2, to: Date())
let sampleAssignments = [
    "CS61B" : [Assignment(name: "Gitlet", date: datee ?? Date()), Assignment(name: "Lab 14", date: datee ?? Date())],
    "EECS16B" : [Assignment(name: "HW 12", date: datee ?? Date())],
    "iOS Decal": [Assignment(name: "Project", date: datee ?? Date())]
]

class User {
    var accountType: String
    var email: String
    var classesSet = Set<String>()
    var classesArray = [String]()
//    var assignments = sampleAssignments
//    var urls = ["Gitlet"  : "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/proj/proj3/index.html",
//                "Lab 14"  : "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/lab/lab14/index.html",
//                "HW 12"   : "http://www.eecs16b.org/homework/prob12.pdf",
//                "Project" : "https://iosdev.berkeley.edu/project/finalProject/"
//    ]
    var assignments = [String : [Assignment]]()
    var urls = [String : String]()
    let db = Firestore.firestore()
    
    init(accountType: String, email: String) {
        self.accountType = accountType
        self.email = email
    }
    func getClasses(completion: @escaping() -> ()) -> Void {
        db.collection("users").document(self.email).getDocument { (document, error) in
            if let error = error {
                print("\(error)")
            }
            else if let document = document, document.exists {
                if let data = document.data() {
                    if let classes = data["classes"] as? NSArray {
                        self.classesArray = NSMutableArray(array: classes).compactMap({ $0 as? String })
                        self.classesSet = Set(self.classesArray)
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            }
        }
    }
    func storeClasses() {
        db.collection("users").document(self.email).setData(["classes": self.classesArray])
    }
    
    func apiCall(classname: String, url: String) {
        let api_url = URL(string: "https://scraperserverapp.wl.r.appspot.com/api/queries")
        guard let requestUrl = api_url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        // HTTP Request Parameters which will be sent in HTTP Request Body
        let parameters = ["link": url]

        // Set HTTP Request Body
        do {
            // pass dictionary to nsdata object and set it as request body
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
//        var result = ["link":
//            [ "Homework":
//                ["Due Dates":nil, "Specs":nil],
//              "Projects":
//                ["Due Dates":nil, "Specs":nil],
//              "Labs":
//                ["Due Dates":nil, "Specs":nil]
//            ]
//        ]

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                print(jsonResponse) //Response result
                var result = ["link":
                                [ "Homework":
                                    ["Due Dates":nil, "Specs":nil],
                                  "Projects":
                                    ["Due Dates":nil, "Specs":nil],
                                  "Labs":
                                    ["Due Dates":nil, "Specs":nil]
                                ]
                            ]
                if let jsonDictLink = jsonResponse as? [String: Any] {
                    
                    if let jsonDictAssignments = jsonDictLink["link"] as? [String: Any] {
                        
                        if let jsonDictHomework = jsonDictAssignments["Homework"] as? [String: Any] {
                            
                            if let jsonDictHomeworkDue = jsonDictHomework["Due Dates"] as? [String:Any] {
                                
                                result["link"]!["Homework"]!["Due Dates"]! = jsonDictHomeworkDue
                                
                            }
                            if let jsonDictHomeworkSpecs = jsonDictHomework["Specs"] as? [String: Any] {
                                
                                result["link"]!["Homework"]!["Specs"]! = jsonDictHomeworkSpecs
                            }
                        }
                        if let jsonDictProjects = jsonDictAssignments["Projects"] as? [String: Any] {
                            
                            if let jsonDictProjectDue = jsonDictProjects["Due Dates"] as? [String: Any] {
                                
                                result["link"]!["Projects"]!["Due Dates"]! = jsonDictProjectDue
                            }
                            if let jsonDictProjectSpecs = jsonDictProjects["Specs"] as? [String: Any] {
                                
                                result["link"]!["Projects"]!["Specs"]! = jsonDictProjectSpecs
                            }
                        }
                        if let jsonDictLabs = jsonDictAssignments["Labs"] as? [String: Any] {
                            
                            if let jsonDictLabDue = jsonDictLabs["Due Dates"] as? [String: Any] {
                                
                                result["link"]!["Labs"]!["Due Dates"]! = jsonDictLabDue
                            }
                            if let jsonDictLabSpecs = jsonDictLabs["Specs"] as? [String: Any] {
                                
                                result["link"]!["Labs"]!["Specs"]! = jsonDictLabSpecs
                            }
                        }
                    }
                }
                self.getClassInfo(classname: classname, url: url, classDict: result as [String : Any] as! [String : [String : [String : Any]]])
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
    
    func getClassInfo(classname: String, url: String, classDict: [String : [String : [String : Any]]]) {
        //query backend link=url, return dictionary below for cs61b
        let dictOfAssignments = classDict["link"]
        self.assignments[classname] = [Assignment]()

        if let hwdates = dictOfAssignments!["Homework"]!["Due Dates"] as! [String : String]? {
            for (name, dates) in hwdates {
                var date = dates.components(separatedBy: " ")
                date = date[1].components(separatedBy: "/")
                //turn into Date object
                var dateComponents = DateComponents()
                dateComponents.year = 2020
                dateComponents.month = Int(date[0])
                dateComponents.day = Int(date[1])
                // Create date from components
                let userCalendar = Calendar.current // user calendar
                let duedate = userCalendar.date(from: dateComponents)
                self.assignments[classname]!.append(Assignment(name: name, date: duedate!))
            }
        }
        if let hwspecs = dictOfAssignments!["Homework"]!["Specs"] as! [String : String]? {
            for (name, link) in hwspecs {
                self.urls[name] = link
            }
        }
        if let projdates = dictOfAssignments!["Projects"]!["Due Dates"] as! [String : String]? {
            for (name, dates) in projdates {
                var date = dates.components(separatedBy: " ")
                date = date[1].components(separatedBy: "/")
                //turn into Date object
                var dateComponents = DateComponents()
                dateComponents.year = 2020
                dateComponents.month = Int(date[0])
                dateComponents.day = Int(date[1])
                // Create date from components
                let userCalendar = Calendar.current // user calendar
                let duedate = userCalendar.date(from: dateComponents)
                self.assignments[classname]!.append(Assignment(name: name, date: duedate!))
            }
        }
        if let projspecs = dictOfAssignments!["Projects"]!["Specs"] as! [String : String]? {
            for (name, link) in projspecs {
                self.urls[name] = link
            }
        }

        if let labdates = dictOfAssignments!["Labs"]!["Due Dates"] as! [String : String]? {
            for (name, dates) in labdates {
                var date = dates.components(separatedBy: " ")
                date = date[1].components(separatedBy: "/")
                //turn into Date object
                var dateComponents = DateComponents()
                dateComponents.year = 2020
                dateComponents.month = Int(date[0])
                dateComponents.day = Int(date[1])
                // Create date from components
                let userCalendar = Calendar.current // user calendar
                let duedate = userCalendar.date(from: dateComponents)
                self.assignments[classname]!.append(Assignment(name: name, date: duedate!))
            }
        }
        if let labspecs = dictOfAssignments!["Labs"]!["Specs"] as! [String : String]? {
            for (name, link) in labspecs {
                self.urls[name] = link
            }
        }
    }
    
}

class NativeUser: User {
    var password: String
    init(email: String, password: String) {
        self.password = password
        super.init(accountType: "Native", email: email)
    }
}

class GoogleUser: User {
    var username: String

    init(email: String, username: String) {
        self.username = username
        super.init(accountType: "Google", email: email)
    }
}
