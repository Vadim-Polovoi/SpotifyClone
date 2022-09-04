//
//  MusicPlayerViewController.swift
//  SpotifyClone
//
//  Created by Вадим on 3.09.22.
//

import UIKit


final class MusicPlayerViewController: UIViewController {
    
    private let song: Song
    
    private lazy var mediaPlayer: MediaPlayerView = {
        let player = MediaPlayerView(song: song)
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    init(song: Song) {
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mediaPlayer.play()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mediaPlayer.stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func configureView() {
        addBlurredView()
        view.addSubview(mediaPlayer)
        setupConstraints()
    }
    
    private func addBlurredView() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.view.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = .black
        }
    }
    
    private func setupConstraints() {
        let mediaPlayerConstraints = [
            mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(mediaPlayerConstraints)
    }
}
