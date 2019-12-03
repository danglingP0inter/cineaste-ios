//
//  SearchMoviesCell.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 02.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

class SearchMoviesCell: UITableViewCell {
    static let identifier = "SearchMoviesCell"

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var soonHint: HintView!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var swipeHintView: UIView!

    // MARK: - Actions

    func animateSwipeHint() {
        cellBackgroundView.slideIn(from: .trailing)
    }

    func configure(with movie: Movie, state: WatchState) {
        cellBackgroundView.backgroundColor = .cineCellBackground
        swipeHintView.backgroundColor = SwipeAction.moveToWatchlist.backgroundColor
        poster.accessibilityIgnoresInvertColors = true
        poster.loadingImage(from: movie.posterPath, in: .small)
        title.text = movie.title
        soonHint.content = .soonReleaseInformation
        soonHint.isHidden = !movie.soonAvailable
        placeholderView.isHidden = !movie.soonAvailable

        let nonbreakingSpace = "\u{00a0}"
        detailLabel.text = movie.formattedRelativeReleaseInformation
            + " ∙ "
            + movie.formattedVoteAverage
            + "\(nonbreakingSpace)/\(nonbreakingSpace)10"

        switch state {
        case .undefined:
            stateImageView.isHidden = true
        case .seen:
            stateImageView.isHidden = false
            stateImageView.image = UIImage.seenBadgeIcon
        case .watchlist:
            stateImageView.isHidden = false
            stateImageView.image = UIImage.watchlistBadgeIcon
        }

        applyAccessibility(for: movie, with: state)
    }

    private func applyAccessibility(for movie: Movie, with state: WatchState) {
        isAccessibilityElement = true

        accessibilityLabel = movie.title

        if let state = String.state(for: state) {
            accessibilityLabel?.append(", \(state)")
        }

        let voting = String.voting(for: movie.formattedVoteAverage)
        accessibilityLabel?.append(", \(voting)")

        let isSoonAvailable = !soonHint.isHidden
        accessibilityLabel?.append(
            isSoonAvailable
            ? ", \(String.soonReleaseInformationLong)"
            : ""
        )
        accessibilityLabel?.append(", \(movie.formattedRelativeReleaseInformation)")
    }
}
