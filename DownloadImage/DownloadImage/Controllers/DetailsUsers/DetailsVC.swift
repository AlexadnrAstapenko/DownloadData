//
//  DetailsVC.swift
//  DownloadImage
//
//  Created by Александр Астапенко on 17.04.22.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var lastNameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var streetLbl: UILabel!
    @IBOutlet var suiteLbl: UILabel!
    @IBOutlet var cityLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var weblbl: UILabel!
    @IBOutlet var streetComLbl: UILabel!
    @IBOutlet var suiteComLbl: UILabel!
    @IBOutlet var cityComLbl: UILabel!

    @IBOutlet var showMap: UIButton!
    var users: Users?

    override func viewDidLoad() {
        setupUI()
    }

    func setupUI() {
        namelbl.text = "Name: " + " " + (users?.name ?? "")
        lastNameLbl.text = "User name: " + " " + (users?.username ?? "")
        emailLbl.text = "E-mail : " + " " + (users?.email ?? "")
        streetLbl.text = "Street : " + " " + (users?.address?.street ?? "")
        suiteLbl.text = "Suite : " + " " + (users?.address?.suite ?? "")
        cityLbl.text = "City : " + " " + (users?.address?.city ?? "")
        phoneLbl.text = "Phone number : " + " " + (users?.phone ?? "")
        weblbl.text = "Web site : " + " " + (users?.website ?? "")
        streetComLbl.text = "Name Company : " + " " + (users?.company?.name ?? "")
        suiteComLbl.text = "catchPhrase : " + " " + (users?.company?.catchPhrase ?? "")
        cityComLbl.text = "BS : " + " " + (users?.company?.bs ?? "")
    }

    // MARK: - Navigation

    @IBAction func showMap(_: Any) {
        guard let detailsView = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        let lat = NSString(string: users?.address?.geo?.lat ?? "")
        let long = NSString(string: users?.address?.geo?.lng ?? "")
        detailsView.titleUser = users?.name
        detailsView.lat = lat.doubleValue
        detailsView.long = long.doubleValue
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPosts",
           let postVC = segue.destination as? PostsTableViewController
        {
            postVC.users = users
//        } else if segue.identifier == "AlbomsSegue",
//                  let albomsTableVC = segue.destination as? AlbomsTableVC
//        {
//            albomsTableVC.users = users
//        }
    }
}
}
