//
//  ViewController.swift
//  Ipuzzle
//
//  Created by Asgedom Teklu on 10/31/18.
//  Copyright © 2018 Asgedom Y. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let questionImageArray = [#imageLiteral(resourceName: "Layer 1.jpg"),#imageLiteral(resourceName: "Layer 2.jpg"),#imageLiteral(resourceName: "Layer 3.jpg"),#imageLiteral(resourceName: "Layer 4.jpg"),#imageLiteral(resourceName: "Layer 5.jpg"),#imageLiteral(resourceName: "Layer 6.jpg"),#imageLiteral(resourceName: "Layer 7.jpg"),#imageLiteral(resourceName: "Layer 8.jpg"),#imageLiteral(resourceName: "Layer 9.jpg"),#imageLiteral(resourceName: "Layer 10.jpg"),#imageLiteral(resourceName: "Layer 11.jpg"),#imageLiteral(resourceName: "Layer 12.jpg"),#imageLiteral(resourceName: "Layer 13.jpg"),#imageLiteral(resourceName: "Layer 14.jpg"),#imageLiteral(resourceName: "Layer 15.jpg"),#imageLiteral(resourceName: "Layer 16.jpg")]
    let correctAns = [0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16]
    var wrongAns = Array(0..<17)
    var wrongImageArray=[UIImage]()
    var undoMovesArray = [(first: IndexPath, second: IndexPath)]()
    var numberOfMoves = 0
    
    var firstIndexPath: IndexPath?
    var secondIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "IPuzzle"
        self.navigationController?.navigationBar.isTranslucent = false
        
        wrongImageArray = questionImageArray
        setupViews()
    }
    
    @objc func btnSwapAction() {
        guard let start = firstIndexPath, let end = secondIndexPath else { return }
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        }) { (finished) in
            // update data source here
            //            print(wrongAns)
            self.myCollectionView.deselectItem(at: start, animated: true)
            self.myCollectionView.deselectItem(at: end, animated: true)
            self.firstIndexPath = nil
            self.secondIndexPath = nil
            self.wrongImageArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            self.undoMovesArray.append((first: start, second: end))
            self.numberOfMoves += 1
            self.lblMoves.text = "Moves: \(self.numberOfMoves)"
            if self.wrongAns == self.correctAns {
                let alert=UIAlertController(title: "You Won!", message: "Congratulations 👍", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (action) in
                    self.restartGame()
                })
                alert.addAction(okAction)
                alert.addAction(restartAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func restartGame() {
        self.undoMovesArray.removeAll()
        wrongAns = Array(0..<17)
        wrongImageArray = questionImageArray
        firstIndexPath = nil
        secondIndexPath = nil
        self.numberOfMoves = 0
        self.lblMoves.text = "Moves: \(numberOfMoves)"
        self.myCollectionView.reloadData()
    }
    
    @objc func btnUndoAction() {
        if undoMovesArray.count == 0 {
            return
        }
        let start = undoMovesArray.last!.first
        let end = undoMovesArray.last!.second
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        }) { (finished) in
            // update data source here
            self.wrongImageArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            self.undoMovesArray.removeLast()
            self.numberOfMoves += 1
            self.lblMoves.text = "Moves: \(self.numberOfMoves)"
        }
    }
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageViewCVCell
        cell.imgView.image=wrongImageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if firstIndexPath == nil {
            firstIndexPath = indexPath
            collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else if secondIndexPath == nil {
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else {
            collectionView.deselectItem(at: secondIndexPath!, animated: true)
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath == firstIndexPath {
            firstIndexPath = nil
        } else if indexPath == secondIndexPath {
            secondIndexPath = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        _ = collectionView.frame.height
        return CGSize(width: width/4, height: width/4)
    }
    
    func setupViews() {
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(ImageViewCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor=UIColor.white
        
        self.view.addSubview(myCollectionView)
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive=true
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -21).isActive=true
        myCollectionView.heightAnchor.constraint(equalTo: myCollectionView.widthAnchor).isActive=true
        
        self.view.addSubview(btnSwap)
        btnSwap.widthAnchor.constraint(equalToConstant: 200).isActive=true
        btnSwap.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 20).isActive=true
        btnSwap.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        btnSwap.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnSwap.addTarget(self, action: #selector(btnSwapAction), for: .touchUpInside)
        
        self.view.addSubview(btnUndo)
        btnUndo.widthAnchor.constraint(equalToConstant: 200).isActive=true
        btnUndo.topAnchor.constraint(equalTo: btnSwap.bottomAnchor, constant: 30).isActive=true
        btnUndo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        btnUndo.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnUndo.addTarget(self, action: #selector(btnUndoAction), for: .touchUpInside)
        
        self.view.addSubview(lblMoves)
        lblMoves.widthAnchor.constraint(equalToConstant: 200).isActive=true
        lblMoves.topAnchor.constraint(equalTo: btnUndo.bottomAnchor, constant: 20).isActive=true
        lblMoves.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
        lblMoves.heightAnchor.constraint(equalToConstant: 50).isActive=true
        lblMoves.text = "Moves: \(numberOfMoves)"
    }
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.allowsMultipleSelection = true
        cv.translatesAutoresizingMaskIntoConstraints=false
        return cv
    }()
    
    let btnSwap: UIButton = {
        let btn=UIButton(type: .system)
        btn.setTitle("Swap", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnUndo: UIButton = {
        let btn=UIButton(type: .system)
        btn.setTitle("Undo", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let lblMoves: UILabel = {
        let lbl=UILabel()
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
}
