//
//  PostsTableViewController.swift
//  DownloadImage
//
//  Created by Александр Астапенко on 20.04.22.
//

import UIKit
import Alamofire

// MARK: - PostsTableViewController

class PostsTableViewController: UITableViewController {
    // MARK: Internal

    var users: Users?
    var posts: [Post] = []
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    var delegate: PostTableVCProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.isEditing = true
        fetchPosts()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.2 // optional
        tableView.addGestureRecognizer(longPress)
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }


    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            let index = self.posts[indexPath.row].id
            self.deletePosts(index: index ?? 0)
            self.posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        let changeAction = UIContextualAction(style: .normal, title: "Editing") { _, _, complete in
            guard let detailsView = self.storyboard?.instantiateViewController(withIdentifier: "AddPostVC") as? AddPostVC else { return }
            detailsView.state = true
            detailsView.post = self.posts[indexPath.row]
            self.navigationController?.pushViewController(detailsView, animated: true)
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, changeAction])
        configuration.performsFirstActionWithFullSwipe = false
        print("swaip")
        return configuration
    }


     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         return true
     }
    
    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
      let locationInView = sender.location(in: tableView)
      let indexPath = tableView.indexPathForRow(at: locationInView)

      if sender.state == .began {
        if indexPath != nil {
          dragInitialIndexPath = indexPath
          let cell = tableView.cellForRow(at: indexPath!)
          dragCellSnapshot = snapshotOfCell(inputView: cell!)
          var center = cell?.center
          dragCellSnapshot?.center = center!
          dragCellSnapshot?.alpha = 0.0
          tableView.addSubview(dragCellSnapshot!)

          UIView.animate(withDuration: 0.25, animations: { () -> Void in
            center?.y = locationInView.y
            self.dragCellSnapshot?.center = center!
            self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
            self.dragCellSnapshot?.alpha = 0.99
            cell?.alpha = 0.0
          }, completion: { (finished) -> Void in
            if finished {
              cell?.isHidden = true
            }
          })
        }
      } else if sender.state == .changed && dragInitialIndexPath != nil {
        var center = dragCellSnapshot?.center
        center?.y = locationInView.y
        dragCellSnapshot?.center = center!

        // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
        if indexPath != nil && indexPath != dragInitialIndexPath {
          // update your data model
          let dataToMove = posts[dragInitialIndexPath!.row]
          posts.remove(at: dragInitialIndexPath!.row)
          posts.insert(dataToMove, at: indexPath!.row)

          tableView.moveRow(at: dragInitialIndexPath!, to: indexPath!)
          dragInitialIndexPath = indexPath
        }
      } else if sender.state == .ended && dragInitialIndexPath != nil {
        let cell = tableView.cellForRow(at: dragInitialIndexPath!)
        cell?.isHidden = false
        cell?.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.dragCellSnapshot?.center = (cell?.center)!
          self.dragCellSnapshot?.transform = CGAffineTransform.identity
          self.dragCellSnapshot?.alpha = 0.0
          cell?.alpha = 1.0
        }, completion: { (finished) -> Void in
          if finished {
            self.dragInitialIndexPath = nil
            self.dragCellSnapshot?.removeFromSuperview()
            self.dragCellSnapshot = nil
          }
        })
      }
    }

    func snapshotOfCell(inputView: UIView) -> UIView {
      UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
      inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      let cellSnapshot = UIImageView(image: image)
      cellSnapshot.layer.masksToBounds = false
      cellSnapshot.layer.cornerRadius = 0.0
      cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
      cellSnapshot.layer.shadowRadius = 5.0
      cellSnapshot.layer.shadowOpacity = 0.4
      return cellSnapshot
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let detVc = segue.destination as? AddPostVC {
            detVc.user = users
            detVc.delegate = self
        }
    }

    // MARK: Private

    private func fetchPosts() {
        guard let id = users?.id else { return }
        let urlPath = "\(ApiContstans.posts)?userId=\(id)"
        guard let url = URL(string: urlPath) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error { print(error) }
            guard let data = data else { return }
            do {
                self?.posts = try JSONDecoder().decode([Post].self, from: data)
            } catch {
                print(error)
            }

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        task.resume()
    }
    private func deletePosts(index: Int) {
        let urlPath = "\(ApiContstans.posts)/\(index)"
        guard let url = URL(string: urlPath) else { return }
        
        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let response = response {
                print(response)
            } else if let data = data {
                DispatchQueue.main.async {
                    self?.delegate?.newPostAdded()
                    self?.tableView.reloadData()
                }
            }
        }.resume()
    }
}

// MARK: PostTableVCProtocol

extension PostsTableViewController: PostTableVCProtocol {
    func newPostAdded() {
        fetchPosts()
    }
}
