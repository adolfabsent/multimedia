//
//  ViewController.swift
//  Multimedia
//
//  Created by Максим Зиновьев on 16.10.2023.
//


import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player = AVAudioPlayer()

    private let mediaArray: [String] = ["Dollhouse", "BAMBAM", "Daughter", "Naked", "Miley"]

    var currentMedia: String?
    var currentMediaCount: Int?

    private lazy var buttonsStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()


    private lazy var showPostButton: CustomButton = {
        let button = CustomButton(title: "Push", width: 250, height: 50, backgroundColor: .purple)
        button.closure = { self.didTapPushButton() }
        return button
    }()

    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Check", width: 250, height: 50, backgroundColor: .systemYellow)
        button.closure = { self.didTapCheckButton(text: self.textField.text ?? "") }
        return button
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.text = "0"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var indicatorLabel: UILabel = {
        let textField = UILabel()
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        currentMedia = mediaArray.first
        currentMediaCount = 0
        setupPlayer()
        setupUI()
    }

    private lazy var playButton: CustomButton = {
        let button = CustomButton(title: "Play/pause Song", width: 250, height: 50, backgroundColor: .green)
        button.closure = {
            self.playPauseMedia()
        }
        return button
    }()

    private lazy var stopButton: CustomButton = {
        let button = CustomButton(title: "Stop Song", width: 250, height: 50, backgroundColor: .red)
        button.closure = {
            self.stopMedia()
        }
        return button
    }()

    private lazy var nextButton: CustomButton = {
        let button = CustomButton(title: "Next Song", width: 100, height: 50, backgroundColor: .red)
        button.closure = {
            self.nextSong()
        }
        return button
    }()

    private lazy var prevButton: CustomButton = {
        let button = CustomButton(title: "Prev Song", width: 100, height: 50, backgroundColor: .red)
        button.closure = {
            self.prevSong()
        }
        return button
    }()

    private lazy var videoButton: CustomButton = {
        let button = CustomButton(title: "Video", width: 100, height: 50, backgroundColor: .red)
        button.closure = {
            self.pushVideo()
        }
        return button
    }()

    private lazy var recordButton: CustomButton = {
        let button = CustomButton(title: "Record", width: 100, height: 50, backgroundColor: .red)
        button.closure = {
            self.recordButtonDidTap()
        }
        return button
    }()

    private func setupUI() {
        view.backgroundColor = .systemBrown
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(indicatorLabel)
        buttonsStackView.addArrangedSubview(playButton)
        buttonsStackView.addArrangedSubview(stopButton)
        buttonsStackView.addArrangedSubview(nextButton)
        buttonsStackView.addArrangedSubview(prevButton)
        buttonsStackView.addArrangedSubview(videoButton)
        buttonsStackView.addArrangedSubview(recordButton)

        NSLayoutConstraint.activate([
            buttonsStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 300),

        ])
    }

    private func setupPlayer() {

        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: currentMedia, ofType: "mp3")!))
            player.prepareToPlay()
        } catch {
            print(error)
        }
    }


    private func playPauseMedia() {
        indicatorLabel.text = mediaArray[currentMediaCount!]
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    private func stopMedia() {
        player.stop()
        player.currentTime = 0
        indicatorLabel.text = ""
    }

    private func nextSong() {
        let playNow = player.isPlaying
        do {
            let nextSongCount: Int?
            if currentMediaCount == mediaArray.count - 1 {
                nextSongCount = 0
                currentMediaCount = nextSongCount
            } else {
                nextSongCount = currentMediaCount! + 1
                currentMediaCount! += 1

            }
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: mediaArray[nextSongCount!], ofType: "mp3")!))
            player.prepareToPlay()

            if playNow {
                player.play()
            }
            indicatorLabel.text = mediaArray[currentMediaCount!]
        } catch {
            print(error)
        }
    }

    private func prevSong() {
        let playNow = player.isPlaying
        do {
            if player.currentTime > 2 {
                stopMedia()
                playPauseMedia()
            } else {
                let prevSongCount: Int?
                if currentMediaCount == 0 {
                    prevSongCount = mediaArray.count - 1
                    currentMediaCount = prevSongCount
                } else {
                    prevSongCount = currentMediaCount! - 1
                    currentMediaCount! -= 1
                }
                player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: mediaArray[prevSongCount!], ofType: "mp3")!))
                player.prepareToPlay()

                if playNow {
                    player.play()
                }
                indicatorLabel.text = mediaArray[currentMediaCount!]
            }

        } catch {
            print(error)
        }
    }

    func pushVideo() {
        let video = VideoViewController()
        self.navigationController?.pushViewController(video, animated: true)
    }

    func recordButtonDidTap() {
        let audio = AudioViewController()
        self.navigationController?.pushViewController(audio, animated: true)
    }

    @objc func didTapCheckButton(text: String) {
       }

       @objc func didTapPushButton() {
       }

}
