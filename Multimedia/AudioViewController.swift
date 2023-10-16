//
//  AudioViewController.swift
//  Multimedia
//
//  Created by Максим Зиновьев on 17.10.2023.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var audioFileName: URL?


    private lazy var recordButton: CustomButton = {
        let button = CustomButton(title: "Record", width: 150, height: 50)
        return button
    }()

    private lazy var playButton: CustomButton = {
        let button = CustomButton(title: "Play", width: 150, height: 50)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupView()
        setupRecorder()
    }

    private func setupView() {
        view.addSubview(recordButton)
        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }

    func setupRecorder() {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission({(allowed: Bool)-> Void in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        print("Error")
                    }
                }
            }
        )} catch {
            print("Error")
        }
    }

    func loadRecordingUI() {
        recordButton.isEnabled = true
        recordButton.closure = { self.recordTapped() }
        playButton.isEnabled = false
        playButton.closure = { self.playAudioButtonTapped(self.playButton) }
    }

    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }

    func startRecording() {

        let audioFilename = getFileURL()
        self.audioFileName = audioFilename

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            recordButton.setTitle("Tap to Stop", for: .normal)
            playButton.isEnabled = false
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            playButton.isEnabled = true
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            print("Error")
        }
    }

    func playAudioButtonTapped(_ sender: UIButton) {
        print("play")
            if (sender.titleLabel?.text == "Play"){
                recordButton.isEnabled = false
                sender.setTitle("Stop", for: .normal)
                preparePlayer()
                audioPlayer.play()
            } else {
                audioPlayer.stop()
                sender.setTitle("Play", for: .normal)
            }
        }

    func preparePlayer() {
            var error: NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileName! as URL)
            } catch
                let error1 as NSError {
                error = error1
                audioPlayer = nil
            }

            if let err = error {
                print("AVAudioPlayer error: \(err.localizedDescription)")
            } else {
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 10.0
                playButton.titleLabel?.text = "Now"
            }
        }

    func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }

    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }


    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setTitle("Play", for: .normal)
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }

}
