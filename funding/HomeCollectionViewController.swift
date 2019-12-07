//
//  HomeCollectionViewController.swift
//  funding
//
//  Created by Daniel Nzioka on 10/26/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    
    var objects = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }


}
