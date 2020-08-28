////
////  getClassInfo.swift
////  HomeworkTracker
////
////  Created by Angela Jiang on 5/1/20.
////  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
////
//
//import Foundation
//func apiCall(url: String) {
//    let api_url = URL(string: "https://scraperserverapp.wl.r.appspot.com/api/queries")
//    guard let requestUrl = api_url else { fatalError() }
//
//    // Prepare URL Request Object
//    var request = URLRequest(url: requestUrl)
//    request.httpMethod = "POST"
//
//    // HTTP Request Parameters which will be sent in HTTP Request Body
//    let parameters = ["link": url]
//
//    // Set HTTP Request Body
//    do {
//        // pass dictionary to nsdata object and set it as request body
//        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//    } catch let error {
//        print(error.localizedDescription)
//    }
//
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//    guard let dataResponse = data,
//              error == nil else {
//              print(error?.localizedDescription ?? "Response Error")
//              return }
//        do{
//            //here dataResponse received from a network request
//            let jsonResponse = try JSONSerialization.jsonObject(with:
//                                   dataResponse, options: [])
//            print(jsonResponse) //Response result
//            
//            var data = ["link":
//                            [ "Homework":
//                                ["Due Dates":nil, "Specs":nil],
//                              "Projects":
//                                ["Due Dates":nil, "Specs":nil],
//                              "Labs":
//                                ["Due Dates":nil, "Specs":nil]
//                            ]
//                        ]
//            
//            if let jsonDictLink = jsonResponse as? [String: Any] {
//                
//                if let jsonDictAssignments = jsonDictLink["link"] as? [String: Any] {
//                    
//                    if let jsonDictHomework = jsonDictAssignments["Homework"] as? [String: Any] {
//                        
//                        if let jsonDictHomeworkDue = jsonDictHomework["Due Dates"] as? [String:Any] {
//                            
//                            data["link"]!["Homework"]!["Due Dates"]! = jsonDictHomeworkDue
//                            
//                        }
//                        if let jsonDictHomeworkSpecs = jsonDictHomework["Specs"] as? [String: Any] {
//                            
//                            data["link"]!["Homework"]!["Specs"]! = jsonDictHomeworkSpecs
//                        }
//                    }
//                    if let jsonDictProjects = jsonDictAssignments["Projects"] as? [String: Any] {
//                        
//                        if let jsonDictProjectDue = jsonDictProjects["Due Dates"] as? [String: Any] {
//                            
//                            data["link"]!["Projects"]!["Due Dates"]! = jsonDictProjectDue
//                        }
//                        if let jsonDictProjectSpecs = jsonDictProjects["Specs"] as? [String: Any] {
//                            
//                            data["link"]!["Projects"]!["Specs"]! = jsonDictProjectSpecs
//                        }
//                    }
//                    if let jsonDictLabs = jsonDictAssignments["Labs"] as? [String: Any] {
//                        
//                        if let jsonDictLabDue = jsonDictLabs["Due Dates"] as? [String: Any] {
//                            
//                            data["link"]!["Labs"]!["Due Dates"]! = jsonDictLabDue
//                        }
//                        if let jsonDictLabSpecs = jsonDictLabs["Specs"] as? [String: Any] {
//                            
//                            data["link"]!["Labs"]!["Specs"]! = jsonDictLabSpecs
//                        }
//                         
//                    }
//                    
//                }
//                
//            }
//            return data
//            
//         } catch let parsingError {
//            print("Error", parsingError)
//       }
//    }
//    task.resume()
//}
//func getClassInfo() {
//    let classname = classnameTextField.text
//    let url = urlTextField.text
//    //query backend link=url, return dictionary below for cs61b
//    let classDict = apiCall(url: url)
////    var cs61b = [
////        "link": [
////            "Homework": [
////                "Due Dates": [
////                    "HW0": "due 1/31",
////                    "HW1": "due 2/7",
////                    "HW2": "due 2/14",
////                    "HW3": "due 2/21",
////                    "HW4": "due 3/6",
////                    "HW5": "due 3/18",
////                    "HW6": "due 3/23",
////                    "HW7": "due 4/10",
////                    "HW8": "due 4/17",
////                    "HW9": "due 4/24"
////                ],
////                "Specs": [
////                    "HW0": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw0/index.html",
////                    "HW1": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw1/index.html",
////                    "HW2": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw2/index.html",
////                    "HW3": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw3/index.html",
////                    "HW4": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw4/index.html",
////                    "HW5": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw5/index.html",
////                    "HW6": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw6/index.html",
////                    "HW7": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw7/index.html",
////                    "HW8": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw8/index.html",
////                    "HW9": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/hw/hw9/index.html"
////                ]
////            ],
////            "Labs": [
////                "Due Dates": [],
////                "Specs": []
////            ],
////            "Projects": [
////                "Due Dates": [
////                    "Project 0": "due 2/18",
////                    "Project 1": "due 3/12",
////                    "Project 2": "due 4/6",
////                    "Project 3": "due 5/4"
////                ],
////                "Specs": [
////                    "Project 0": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/proj/proj0/index.html",
////                    "Project 1": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/proj/proj1/index.html",
////                    "Project 2": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/proj/proj2/index.html",
////                    "Project 3": "https://inst.eecs.berkeley.edu/~cs61b/sp20/materials/proj/proj3/index.html"
////                ]
////            ],
////            "Unknown": [
////                "Due Dates": [],
////                "Specs": []
////            ]
////        ]
////    ]
//    
//    //let sampleAssignments = [
//    //    "CS61B" : [Assignment(name: "Gitlet", date: datee ?? Date()), Assignment(name: "Lab 14", date: datee ?? Date())],
//    //    "EECS16B" : [Assignment(name: "HW 12", date: datee ?? Date())],
//    //    "iOSDecal": [Assignment(name: "Project", date: datee ?? Date())]
//    //]
//
//
//    let dictOfAssignments = classDict["link"]
//
//    user.assignments[classname] = Assignment[]()
//
//    for (name, date) in dictOfAssignments!["Homework"]!["Due Dates"]! {
//        date = date.substring(from: 4)
//        date = date.components(separatedBy: "/")
//        //turn into Date object
//        var dateComponents = DateComponents()
//        dateComponents.year = 2020
//        dateComponents.month = date[0]
//        dateComponents.day = date[1]
//        // Create date from components
//        let userCalendar = Calendar.current // user calendar
//        date = userCalendar.date(from: dateComponents)
//        user.assignments[classname].append(Assignment(name: name, date: date))
//    }
//    for (name, link) in dictOfAssignments!["Homework"]!["Specs"]! {
//        user.urls[name] = link
//    }
//
//    for (name, date) in dictOfAssignments!["Projects"]!["Due Dates"]! {
//        date = date.substring(from: 4)
//        date = date.components(separatedBy: "/")
//        //turn into Date object
//        var dateComponents = DateComponents()
//        dateComponents.year = 2020
//        dateComponents.month = date[0]
//        dateComponents.day = date[1]
//        // Create date from components
//        let userCalendar = Calendar.current // user calendar
//        date = userCalendar.date(from: dateComponents)
//        user.assignments[classname].append(Assignment(name: name, date: date))
//    }
//    for (name, link) in dictOfAssignments!["Project"]!["Specs"]! {
//        user.urls[name] = link
//    }
//
//    for (name, date) in dictOfAssignments!["Labs"]!["Due Dates"]! {
//        date = date.substring(from: 4)
//        date = date.components(separatedBy: "/")
//        //turn into Date object
//        var dateComponents = DateComponents()
//        dateComponents.year = 2020
//        dateComponents.month = date[0]
//        dateComponents.day = date[1]
//        // Create date from components
//        let userCalendar = Calendar.current // user calendar
//        date = userCalendar.date(from: dateComponents)
//        user.assignments[classname].append(Assignment(name: name, date: date))
//    }
//    for (name, link) in dictOfAssignments!["Labs"]!["Specs"]! {
//        user.urls[name] = link
//    }
//
//
//}
//
//
//
//struct classInfo {
//    var link : [String : [String : [String : Any]]]
//}
