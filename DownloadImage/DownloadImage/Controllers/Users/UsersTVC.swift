//
//  UsserTVCell.swift
//  DownloadImage
//
//  Created by Александр Астапенко on 17.04.22.
//
import UIKit

// MARK: - UsersTVC

class UsersTVC: UITableViewController {
    static var users: [Users] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return UsersTVC.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UsserTVCell else { return UITableViewCell() }
        cell.userNamelbl.text = UsersTVC.users[indexPath.row].name
        cell.nameLbl.text = UsersTVC.users[indexPath.row].username
        print(UsersTVC.users[indexPath.row])
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = UsersTVC.users[indexPath.row]
        guard let detailsView = storyboard?.instantiateViewController(withIdentifier: "detTVC") as? DetailsVC else { return }
        detailsView.users = person
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
}

// MARK: UsersTVCProtocol

extension UsersTVC: UsersTVCProtocol {
    func fetchData() {
        guard let url = URL(string: ApiContstans.users) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

            if let error = error { print(error) }

            guard let data = data else { return }

            do {
                UsersTVC.users = try JSONDecoder().decode([Users].self, from: data)
            } catch {
                print(error)
            }

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        task.resume()
    }
}
