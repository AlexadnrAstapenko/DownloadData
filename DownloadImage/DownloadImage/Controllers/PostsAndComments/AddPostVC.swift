//
//  AddPostVC.swift
//  DownloadImage
//
//  Created by Александр Астапенко on 20.04.22.
//
import Alamofire
import UIKit

class AddPostVC: UIViewController {
    // MARK: Internal

    @IBOutlet var titleForPost: UITextField!
    @IBOutlet var bodyForPostTV: UITextView!
    var user: Users!
    var delegate: PostTableVCProtocol?
    var state = false
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleForPost.text = post?.title ?? ""
        bodyForPostTV.text = post?.body ?? ""
    }

    @IBAction func addNewPostURLSession(_: Any) {
        if state == false {
            addPost()
        } else {
            editPost()
        }
    }

    @IBAction func addNewPostAlamofire(_: Any) {
        if let title = titleForPost.text,
           let body = bodyForPostTV.text,
           let url = URL(string: ApiContstans.posts)
        {
            let body: [String: Any] = ["userId": user.id,
                                       "title": title,
                                       "body": body]
            AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default)
                .responseJSON { [weak self] dataResponse in
                    switch dataResponse.result {
                    case .success:
                        DispatchQueue.main.async {
                            self?.delegate?.newPostAdded()
                            self?.navigationController?.popViewController(animated: true)
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
        }
    }

    // MARK: Private

    private func addPost() {
        if let title = titleForPost.text,
           let body = bodyForPostTV.text,
           let url = URL(string: ApiContstans.posts)
        {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["userId": user.id,
                                       "title": title,
                                       "body": body]
            guard let httpDate = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
            request.httpBody = httpDate
            URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                if let error = error {
                    print(error)
                } else if data != nil {
                    DispatchQueue.main.async {
                        self?.delegate?.newPostAdded()
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }.resume()
        }
    }

    private func editPost() {
        if let title = titleForPost.text,
           let body = bodyForPostTV.text,
           let url = URL(string: "\(ApiContstans.posts)/\((post.id)!)")
        {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["userId": post.userId,
                                       "title": title,
                                       "body": body]
            guard let httpDate = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
            request.httpBody = httpDate
            URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                if let error = error {
                    print(error)
                } else if data != nil {
                    DispatchQueue.main.async {
                        self?.delegate?.newPostAdded()
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }.resume()
        }
    }
}
