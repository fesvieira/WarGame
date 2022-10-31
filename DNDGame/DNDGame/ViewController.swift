//
//  ViewController.swift
//  DNDGame
//
//  Created by Felipe Vieira on 31/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, DNDCharacter>! = nil
    var snapshot: NSDiffableDataSourceSnapshot<Section, DNDCharacter>! = nil
    
    var skeletonDamage = 30
    
    @IBOutlet weak var skeletonAttackLabel: UILabel!
    
    @IBAction func onStepperClick(_ sender: UIStepper) {
        
        skeletonAttackLabel.text = "\(Int(sender.value))"
        skeletonDamage = Int(sender.value)
    }
    @IBOutlet weak var enemiesCollectionView: UICollectionView!
    
    var characters = [
        DNDCharacter(name: "Leozin", role: "Archer", life: 100, defense: 20),
        DNDCharacter(name: "Forcinha", role: "Warrior", life: 100, defense: 10),
        DNDCharacter(name: "Felipe", role: "Druid", life: 100, defense: 30),
        DNDCharacter(name: "Marcela", role: "Necromant", life: 100, defense: 50),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDataSource()
        
        enemiesCollectionView.collectionViewLayout = createRowLayout()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DNDCharacter>(collectionView: enemiesCollectionView) { [self]
            
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: DNDCharacter) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewCell.identifier,
                for: indexPath) as? CollectionViewCell else { fatalError("Cannot create new cell") }
            
            // Populate the cell with our item description.
            cell.name.text = identifier.name
            cell.role.text = identifier.role
            cell.defense.text = "\(identifier.defense)"
            cell.life.text = identifier.life > 0 ? "\(identifier.life) HP" : "DEAD"
            
            cell.life.textColor = identifier.life > 30 ? .systemGreen : .red
            
            // Initialize Tap Gesture Recognizer
            let tapGestureRecognizer = MyUITap(target: self, action: #selector(didTapView(_:)))
            tapGestureRecognizer.character = identifier
            
            // Add Tap Gesture Recognizer
            cell.container.addGestureRecognizer(tapGestureRecognizer)
            
            // Return the cell.
            return cell
        }
        
        // initial data
        snapshot = NSDiffableDataSourceSnapshot<Section, DNDCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createRowLayout() -> UICollectionViewLayout {
        //2
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //3
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(50.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        //4
        let section = NSCollectionLayoutSection(group: group)
        //        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        //5
        //        let spacing = CGFloat(4)
        //        group.interItemSpacing = .fixed(spacing)
        //        section.interGroupSpacing = spacing
        
        //6
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @objc func didTapView(_ sender: MyUITap) {
        if (sender.character != nil) {
            let currentCharacterIndex = characters.firstIndex(of: sender.character!) ?? 0
            
            if (characters[currentCharacterIndex].defense < skeletonDamage) {
                characters[currentCharacterIndex].life -= skeletonDamage - characters[currentCharacterIndex].defense
            }
            
            self.snapshot.deleteAllItems()
            snapshot.appendSections([.main])
            snapshot.appendItems(characters)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

class MyUITap : UITapGestureRecognizer {
    var character : DNDCharacter? = nil
}
