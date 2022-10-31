//
//  CollectionViewCell.swift
//  DNDGame
//
//  Created by Felipe Vieira on 31/10/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var life: UILabel!
    @IBOutlet weak var defense: UILabel!
    @IBOutlet weak var container: UIStackView!
    
    static let identifier = "collectionCellReuseIdentifier"
}
