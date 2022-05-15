//
//  SharedMemeViewController.swift
//  meme_ap
//
//  Created by Marvellous Dirisu on 12/05/2022.
//

import Foundation
import UIKit

class SharedMemeViewController: UIViewController{
    var meme : Meme!
    @IBOutlet weak var sharedMeme: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sharedMeme!.image = meme.memedImage
        
    }
}
