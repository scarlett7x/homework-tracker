//
//  ClassTableViewCell.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/29/20.
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var classNameLabel: UILabel!
    
    @IBOutlet weak var HWcollectionView: UICollectionView!
    
    var didSelectItemAction: ((String) -> Void)?
    
    var assignments: [Assignment]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        HWcollectionView.delegate = self
        HWcollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension ClassTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assignments!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classHWCell", for: indexPath) as? HWCollectionViewCell else { return HWCollectionViewCell() }
        
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
        let assignment = self.assignments?[indexPath.row]
        cell.assignmentName.text = assignment!.name
        cell.dueDate.text = "\(df.string(from: assignment!.date))"
        cell.layer.borderWidth = 0.2
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HWCollectionViewCell {
            if let assignmentName = cell.assignmentName.text {
                didSelectItemAction?(assignmentName)
            }
        }
    }
}
