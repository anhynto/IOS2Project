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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! DetailCharacterViewController
        
        destination.atDetail = listOfCharacters[collectionView.indexPath(for: sender as! UICollectionViewCell)!.row]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.collectionViewLayout = makeLayout()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        dataSource = UICollectionViewDiffableDataSource<Section, Card>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> PersonageCollectionViewCell? in
            
            switch item {
            case .personnage(let unPerso):
                
                let card = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCard", for: indexPath) as! PersonageCollectionViewCell
            
                
                card.display(atDisplay: unPerso)
                
                return card
            }
        
        })
        
        let snapshot = createSnapshot(characters: [])
        dataSource.apply(snapshot)

        NetworkManager.shared.fetchCharacters { (result) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let elements):
                let charactersList = elements.decodedElements
                self.listOfCharacters = charactersList
                let snapshot = self.createSnapshot(characters: charactersList)

                DispatchQueue.main.async {
                    self.dataSource.apply(snapshot)
                }
            }
        }
        
    }
    
    private func makeLayout()-> UICollectionViewLayout{
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, environment) -> NSCollectionLayoutSection? in
            
            let data = self.dataSource.snapshot()
            
            let sections = data.sectionIdentifiers[section]
            
            switch sections {
            case .grilleDePersos:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                      heightDimension: .estimated(150))
                                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                                let groupeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                        heightDimension: .estimated(150))

                                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupeSize,
                                                                               subitem: item,
                                                                               count: 2)

                                let section = NSCollectionLayoutSection(group: group)

                                return section

            }
        })

        return layout
        
    }

    private func createSnapshot(characters: [Personnage]) -> NSDiffableDataSourceSnapshot<Section, Card> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Card>()
        snapshot.appendSections([.grilleDePersos])

        let cards = characters.map(Card.personnage)

        snapshot.appendItems(cards, toSection: .grilleDePersos)

        return snapshot
    }

}

extension ColletionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Card>()
        if searchQuery == nil || searchQuery == "" {
            newSnapshot = createSnapshot(characters: listOfCharacters)
        }else{
            let result = listOfCharacters.filter{$0.name.localizedCaseInsensitiveContains(searchQuery ?? "")
            }
            newSnapshot = createSnapshot(characters: result)
            
        }
        dataSource.apply(newSnapshot)
    }
}
