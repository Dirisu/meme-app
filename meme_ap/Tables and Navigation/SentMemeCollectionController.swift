//
//  SentMemeCollectionController.swift
//  meme_ap
//
//  Created by Marvellous Dirisu on 12/05/2022.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController{
    
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let layoutWidth = (view.frame.size.width - (2*space))/3.0
        let layoutHeight = (view.frame.size.height - (2*space))/5.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: layoutWidth, height: layoutHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! CollectionViewCell
        let memes = self.memes[(indexPath as NSIndexPath).row]
        
        cell.collectionCellImage?.image = memes.memedImage
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sharedMemeController = storyboard.instantiateViewController(withIdentifier: "sharedMemeController") as! SharedMemeViewController
        sharedMemeController.meme = self.memes[(indexPath as NSIndexPath).row]
        if let navigationController = navigationController{
            navigationController.pushViewController(sharedMemeController, animated: true)
        }
    }
    
    @IBAction func createNewMeme(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeController = storyboard.instantiateViewController(withIdentifier: "memeViewController") as! MemeViewController
        memeController.modalPresentationStyle = .fullScreen
        present(memeController, animated: true, completion: nil)
    }
    
}

