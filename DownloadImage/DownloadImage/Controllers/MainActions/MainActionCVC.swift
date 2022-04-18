//
//  MainActionCVC.swift
//  DownloadImage
//
//  Created by Александр Астапенко on 13.04.22.
//

import UIKit

// MARK: - UserAction

enum UserAction: String, CaseIterable {
    case downloadImage = "Download Image"
    case users = "Users"
}

// MARK: - MainActionCVC

class MainActionCVC: UICollectionViewController {
    // MARK: UICollectionViewDataSource

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let users = segue.destination as? UsersTVCProtocol else { return }
        users.fetchData()
    }

    override func numberOfSections(in _: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return UserAction.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionVCell
        cell.actionLbl.text = UserAction.allCases[indexPath.item].rawValue
        // Configure the cell

        return cell
    }

    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = UserAction.allCases[indexPath.item]
        switch userAction {
        case .downloadImage: performSegue(withIdentifier: "showImageVC", sender: nil)
        case .users: performSegue(withIdentifier: "showUser", sender: nil)
        }
    }

    // MARK: UICollectionViewDelegate
}

// MARK: UICollectionViewDelegateFlowLayout

extension MainActionCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
    }
}
