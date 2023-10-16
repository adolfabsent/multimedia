//
//  VideoViewController.swift
//  Multimedia
//
//  Created by Максим Зиновьев on 17.10.2023.
//

import UIKit
import AVFoundation
import AVKit
import WebKit

class NewController: UIViewController {

    init(player: WKWebView, request: URLRequest) {
        super.init(nibName: nil, bundle: nil)
        player.load(request)
        self.view = player
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoViewController: UITableViewController {

    var webPlayer: WKWebView = {
        let player = WKWebView(frame: .zero)
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()

    var mediaArray: [String] = [
    "https://www.youtube.com/embed/FSNXhmBxRKE?playsinline=1",
    "https://www.youtube.com/embed/LeqKIzeZel4?playsinline=1",
    "https://www.youtube.com/embed/jwI1j7sslYI?playsinline=1",
    "https://www.youtube.com/embed/RWOHKOCr00U?playsinline=1",
    "https://www.youtube.com/embed/k85mRPqvMbE?playsinline=1",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupPlayer()
    }

    func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func setupPlayer() {
        view.addSubview(webPlayer)

        NSLayoutConstraint.activate([
            webPlayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("tableView frame", tableView.frame)


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutSubviews()
        print(webPlayer.frame)
        print("view frame", view.frame)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mediaArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .gray
        cell.textLabel?.text = mediaArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true

        guard let videoURL = URL(string: self.mediaArray[indexPath.row]) else {
            return }
        let request = URLRequest(url: videoURL)

        let viewController = NewController(player: webPlayer, request: request)
        present(viewController, animated: true)

    }
}
