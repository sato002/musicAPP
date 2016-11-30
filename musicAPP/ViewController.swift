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


class ViewController: UIViewController,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let url = "https://itunes.apple.com/us/rss/topsongs/limit=50/genre=%d/explicit=true/json"
    var imageArray:[Int] = [2,3,4,5,6,7,9,10,11,12,14,15,16,17,18,19,20,21,22,24,34,50,51]
    
    var urlArray: Variable<[String]> = Variable<[String]>([])
    var disposeBag = DisposeBag()
    let reachability = Reachability()
    var thamso:UserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thamso = UserDefaults.standard
        self.collectionView.delegate = self
        initListUrl()
        bindToCell()

    }
    
    func bindToCell() {
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.urlArray.asObservable().bindTo(
                    self.collectionView.rx.items(cellIdentifier: "Cell", cellType: UICollectionViewCell.self)
                )   { (row, url, cell) in
                    DataManager.shared.downloadGenre(url: url, compteled: { (title) in
                        let labelGenre = cell.contentView.viewWithTag(101) as! UILabel
                        labelGenre.text = title
                        let imageView = cell.contentView.viewWithTag(100) as! UIImageView
                        imageView.image = UIImage(named: "genre-\(self.imageArray[row])")
                    })
                    }.addDisposableTo(self.disposeBag)
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            print("not connect")
        }
        
        try! reachability?.startNotifier()

        
        

    }
    
    func initListUrl() {
        for i in imageArray {
            let str = String(format: url, i)
            urlArray.value.append(str)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        thamso?.set(imageArray[indexPath.row], forKey: "genre")
        thamso?.set("genre-\(self.imageArray[indexPath.row])", forKey: "imgGenre")

        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "View2Controller") as! View2Controller
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

