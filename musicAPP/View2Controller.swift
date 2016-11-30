//
//  ViewController.swift
//  musicAPP
//
//  Created by Admin on 11/27/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import ReachabilitySwift




class View2Controller: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var url:String?
    var songArray: Variable<[Song]> = Variable<[Song]>([])
    var disposeBag = DisposeBag()
    let reachability = Reachability()
    var thamso:UserDefaults?
    
    @IBOutlet weak var imgGenre: UIImageView!
    @IBOutlet weak var lblGenre: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        thamso = UserDefaults.standard
        url = "https://itunes.apple.com/us/rss/topsongs/limit=50/genre=\(Int((thamso?.integer(forKey: "genre"))!))/explicit=true/json"
        initSongArray()
        bindToCell()
        setupView()
        

        
    }
    
    func setupView() {
        print(thamso?.string(forKey: "imgGenre"))
        imgGenre.image = UIImage(named: (thamso?.string(forKey: "imgGenre"))!)
        DataManager.shared.downloadGenre(url: url!) { (title) in
            self.lblGenre.text = title
        }
    }
    
    func bindToCell() {
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.songArray.asObservable().bindTo(
                    self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)
                ) { (row, song, cell) in
                    let labelName = cell.contentView.viewWithTag(100) as! UILabel
                    labelName.text = song.name
                    let labelArtist = cell.contentView.viewWithTag(101) as! UILabel
                    labelArtist.text = song.artist
                    

                    DataManager.shared.downloadImage(url: song.image, completed: { (img) in
                        let imageView = cell.contentView.viewWithTag(102) as! UIImageView
                        imageView.layer.masksToBounds = false
                        imageView.layer.borderColor = UIColor.black.cgColor
                        imageView.layer.cornerRadius = imageView.frame.height/2
                        imageView.clipsToBounds = true
                        imageView.image = img
                        
                    })

                }.addDisposableTo(self.disposeBag)
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            print("not connect")
        }
        
        try! reachability?.startNotifier()
    }
    
    func initSongArray() {
        DataManager.shared.downloadSong(url: url!) { (listS) in
            for song in listS {
                self.songArray.value.append(song)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}

