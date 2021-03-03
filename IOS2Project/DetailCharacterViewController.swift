//
//  DetailCharacterViewController.swift
//  IOS2Project
//
//  Created by LPIEM on 03/03/2021.
//

import UIKit

class DetailCharacterViewController: UITableViewController {
    
    var atDetail : Personnage!

    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var idLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = atDetail.name
        
        idLabel.text = "Id : \(atDetail.id)"
        
        dateLabel.text = "Created the : " + DateFormatter.localizedString(from: atDetail.createdDate,
                                                                   dateStyle: .medium,
                                                                   timeStyle: .short)
        
        loadImage(characters: atDetail)
        
        speciesLabel.text = "Species : " + atDetail.species

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
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
