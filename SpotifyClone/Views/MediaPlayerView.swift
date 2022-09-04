//
//  MediaPlayer.swift
//  SpotifyClone
//
//  Created by Вадим on 2.09.22.
//

import UIKit
import AVKit


final class MediaPlayerView: UIView {
    
    private var player = AVAudioPlayer()
    
    private var timer: Timer?
    
    private var playingIndex = 0
    
    private let song: Song
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    
    private let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "00:00"
        label.textColor = .lightGray
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "00:00"
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(progressScrubbed(_:)), for: .valueChanged)
        slider.minimumTrackTintColor = .darkGray
        return slider
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        button.setImage(UIImage(systemName: "backward.end", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        button.tintColor = .lightGray
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 75)
        button.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapPlayPause(_:)), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        button.setImage(UIImage(systemName: "forward.end", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        button.tintColor = .lightGray
        return button
    }()
    
    private lazy var controlStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 20
        return stack
    }()
    
    init(song: Song) {
        self.song = song
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func play() {
        progressBar.value = 0.0
        progressBar.maximumValue = Float(player.duration)
        player.play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    func stop() {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    private func configureView() {
        coverImageView.image = UIImage(named: song.image)
        setupPlayer(song: song)
        [coverImageView, songNameLabel, artistNameLabel, progressBar, elapsedTimeLabel, remainingTimeLabel, controlStack].forEach { element in
            addSubview(element)
        }
        setupConstraints()
    }
    
    private func setupPlayer(song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else { return }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        }
        songNameLabel.text = song.name
        artistNameLabel.text = song.artist
        coverImageView.image = UIImage(named: song.image)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func setPlayPauseIcon(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 75)
        playPauseButton.setImage(UIImage(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill", withConfiguration: config), for: .normal)
    }
    
    private func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)),
              let secStr = timeFormatter.string(from: NSNumber(value: secs)) else { return "00:00" }
        return "\(minsString):\(secStr)"
    }
    
    private func setupConstraints() {
        let coverImageViewConstraints = [
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            coverImageView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            coverImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
        ]
        let songLabelConstraints = [
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            songNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16)
        ]
        let artistLabelConstraints = [
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8)
        ]
        let progressBarConstraints = [
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressBar.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 8)
        ]
        let elapsedTimeLabelConstraints = [
            elapsedTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            elapsedTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
        ]
        let remainingTimeLabelConstraints = [
            remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
        ]
        let controlStackConstraints = [
            controlStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 82),
            controlStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -82),
            controlStack.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(coverImageViewConstraints)
        NSLayoutConstraint.activate(songLabelConstraints)
        NSLayoutConstraint.activate(artistLabelConstraints)
        NSLayoutConstraint.activate(progressBarConstraints)
        NSLayoutConstraint.activate(elapsedTimeLabelConstraints)
        NSLayoutConstraint.activate(remainingTimeLabelConstraints)
        NSLayoutConstraint.activate(controlStackConstraints)
    }
    
    @objc private func updateProgress() {
        progressBar.value = Float(player.currentTime)
        elapsedTimeLabel.text = getFormattedTime(timeInterval: player.currentTime)
        let remainingTime = player.duration - player.currentTime
        remainingTimeLabel.text = getFormattedTime(timeInterval: remainingTime)
    }
    
    @objc private func progressScrubbed(_ sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    @objc private func didTapPrevious(_ sender: UIButton) {
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = Song.get().count - 1
        }
        setupPlayer(song: Song.get()[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func didTapPlayPause(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func didTapNext(_ sender: UIButton) {
        playingIndex += 1
        if playingIndex >= Song.get().count {
            playingIndex = 0
        }
        setupPlayer(song: Song.get()[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
}

extension MediaPlayerView: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didTapNext(nextButton)
    }
}
