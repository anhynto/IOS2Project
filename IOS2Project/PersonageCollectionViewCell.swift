//
//  PersonageCollectionViewCell.swift
//  IOS2Project
//
//  Created by LPIEM on 24/02/2021.
//

import UIKit

class PersonageCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "characterCard"
    

    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var nameLabel: UILabel!
    
    public func display(atDisplay:Personnage){
        
        nameLabel.text = atDisplay.name
        
        loadImage(characters: atDisplay)
        
    }
    
    private func loadImage(characters:Personnage){
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: characters.photoURL) else{ return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
    }
    
}
