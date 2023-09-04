//
//  TableCell.swift
//  StorylyDemo
//
//  Created by Yiğit Çalışkan on 4.09.2023.
//  Copyright © 2023 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class TableCell: UITableViewCell {
    
    private lazy var portraitViewFactory: StoryGroupViewFactory = GradientPortraitViewFactory()
    
    private let tokens = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjIzODAsImFwcF9pZCI6MTg0NiwiaW5zX2lkIjoxNzk4N30.VsjPuAJsXZ-xkHZ2qnq6ub6PNgRoUasBN9uEasbXBtw"
    
    internal static var reuseIdentifier = String(describing: TableCell.self)
    
    internal var indexPath: Int? {
        didSet {
            guard let path = indexPath else { return }
            var groupStylingBuilder = StorylyStoryGroupStyling.Builder()
            switch path {
                case 0:
                    groupStylingBuilder = groupStylingBuilder.setSize(size: StoryGroupSize.Small)
                case 1:
                    groupStylingBuilder = groupStylingBuilder.setSize(size: StoryGroupSize.Large)
                case 2:
                    groupStylingBuilder = groupStylingBuilder.setSize(size: StoryGroupSize.Custom)
                        .setIconWidth(width: 100)
                        .setIconHeight(height: 200)
                default:
                    groupStylingBuilder = groupStylingBuilder.setCustomGroupViewFactory(factory: portraitViewFactory)
            }
            
            let config = StorylyConfig.Builder()
                .setStoryGroupStyling(styling: groupStylingBuilder.build())
                .build()
            storylyView.storylyInit = StorylyInit(storylyId: tokens, config: config)
        }
    }
        
    let storylyView: StorylyView = {
        let _storylyView = StorylyView()
        _storylyView.translatesAutoresizingMaskIntoConstraints = false
        return _storylyView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(storylyView)
        self.storylyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.storylyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.storylyView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.storylyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
