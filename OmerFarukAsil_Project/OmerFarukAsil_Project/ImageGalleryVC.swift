//
//  ImageGalleryVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 29.12.2025.
//

//
//  ImageGalleryVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 24.12.2025.
//

import UIKit
import Kingfisher

class ImageGalleryVC: UIViewController, UIScrollViewDelegate {

    var images: [String] = []

    private let pagingScrollView = UIScrollView()
    private let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupPagingScrollView()
        setupImages()
        setupPageControl()
    }

    // MARK: - Paging ScrollView
    private func setupPagingScrollView() {
        pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.showsHorizontalScrollIndicator = false
        pagingScrollView.delegate = self

        view.addSubview(pagingScrollView)

        NSLayoutConstraint.activate([
            pagingScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }

    // MARK: - Images + Zoom
    private func setupImages() {
        view.layoutIfNeeded()

        for (index, imgURL) in images.enumerated() {

            let zoomScrollView = UIScrollView()
            zoomScrollView.minimumZoomScale = 1.0
            zoomScrollView.maximumZoomScale = 3.0
            zoomScrollView.delegate = self
            zoomScrollView.frame = CGRect(
                x: view.frame.width * CGFloat(index),
                y: 0,
                width: view.frame.width,
                height: pagingScrollView.frame.height
            )

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .black
            imageView.frame = zoomScrollView.bounds

            if let url = URL(string: imgURL) {
                imageView.kf.setImage(with: url)
            }

            zoomScrollView.addSubview(imageView)
            pagingScrollView.addSubview(zoomScrollView)
        }

        pagingScrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(images.count),
            height: pagingScrollView.frame.height
        )
    }

    // MARK: - PageControl
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        pageControl.addTarget(
            self,
            action: #selector(pageControlChanged),
            for: .valueChanged
        )

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -12
            ),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - PageControl Action
    @objc private func pageControlChanged() {
        let x = CGFloat(pageControl.currentPage) * pagingScrollView.frame.width
        pagingScrollView.setContentOffset(
            CGPoint(x: x, y: 0),
            animated: true
        )
    }

    // MARK: - Scroll Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == pagingScrollView {
            let page = Int(round(scrollView.contentOffset.x / view.frame.width))
            pageControl.currentPage = page
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != pagingScrollView {
            return scrollView.subviews.first
        }
        return nil
    }
}
