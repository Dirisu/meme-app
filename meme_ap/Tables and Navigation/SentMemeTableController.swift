//
//  SentMemeTableController.swift
//  meme_ap
//
//  Created by Marvellous Dirisu on 12/05/2022.
//

import Foundation
import UIKit

class SentMemeTableController : UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    var memes: [Meme]!{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell")!
        let memes = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(memes.topText)  \(memes.bottomText)"
        cell.imageView?.image = memes.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sharedMemeController = storyboard.instantiateViewController(withIdentifier:"sharedMemeController") as! SharedMemeViewController

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

