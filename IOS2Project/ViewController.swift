//
//  ViewController.swift
//  IOS2Project
//
//  Created by LPIEM on 24/02/2021.
//

import UIKit

class ColletionViewController: UICollectionViewController {
    
    private enum Section {
        case grilleDePersos
    }

    private enum Card: Hashable {
        case personnage(Personnage)
    }
    
    var listOfCharacters: [Personnage] = []
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Card>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataSource = UICollectionViewDiffableDataSource<Section, Card>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> PersonageCollectionViewCell? in
            
            switch item {
            case .personnage(let unPerso):
                
                let card = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCard", for: indexPath) as! PersonageCollectionViewCell
                
                card.display(atDisplay: unPerso)
                
                
                //cell.textLabel?.text = unPerso.name
                //cell.imageView?.loadImage(from: unPerso.photoURL) {
                //    cell.setNeedsLayout()
                //}
                //cell.detailTextLabel?.text = DateFormatter.localizedString(from: unPerso.createdDate,
                //                                                           dateStyle: .medium,
                //                                                           timeStyle: .short)
                return card
            }
        })
        
        let snapshot = createSnapshot(characters: [])
        dataSource.apply(snapshot)

        NetworkManager.shared.fetchCharacters { (result) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                let characters = paginatedElements.decodedElements
                let snapshot = self.createSnapshot(characters: characters)

                DispatchQueue.main.async {
                    self.dataSource.apply(snapshot)
                }
            }
        }
        
    }

    private func createSnapshot(characters: [Personnage]) -> NSDiffableDataSourceSnapshot<Section, Card> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Card>()
        snapshot.appendSections([.grilleDePersos])

        let cards = characters.map(Card.personnage)

        snapshot.appendItems(cards, toSection: .grilleDePersos)

        return snapshot
    }

}

