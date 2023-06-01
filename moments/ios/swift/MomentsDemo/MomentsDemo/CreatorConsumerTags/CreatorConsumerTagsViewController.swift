//
//  CreatorConsumerTagsViewController.swift
//  MomentsDemo
//
//  Created by Yiğit Çalışkan on 3.05.2023.
//

import UIKit
import StorylyMoments
import Storyly

class CreatorConsumerTagsViewController: UIViewController {
    
    let STORYLY_INSTANCE_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjU1NiwiYXBwX2lkIjozMTksImluc19pZCI6MTcxODh9.tM1LHStw2UjaXDrvyBOAEB0ZsTnHZY6_r8QAFBpqf4s"
    let MOMENTS_INSTANCE_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NfaWQiOjU1NiwiaW5zX2lkIjo5OSwiaWF0IjoxNjgzMjA0NzUwfQ._MbZYoZurm3ekbSUCGE0jVD6TC-LMm9_ihWq5Awnbgs"
    let MOMENTS_INSTANCE_SECRET_KEY = "Y9KV2fPHnUp6Cn5NIDgyQdbrrlHshwzr"
    let MOMENTS_INSTANCE_INITIALIZATION_VECTOR = "V5ZA3WdmVRMspmla"
    
    
    var creatorStorylyView: StorylyView!
    var creatorStorylyView1: StorylyView!
    var consumerStorylyView: StorylyView!
    var consumerStorylyView1: StorylyView!
    var consumerStorylyView2: StorylyView!
    var creatorUserManager: StorylyMomentsManager!
    var creatorUserManager1: StorylyMomentsManager!
    
    private lazy var refreshInstancesButton: UIButton = {
        let _backButton = UIButton(frame: .zero)
        _backButton.translatesAutoresizingMaskIntoConstraints = false
        _backButton.addTarget(self, action: #selector(onRefreshButton(_:)), for: .touchUpInside)
        _backButton.setTitle("REFRESH", for: .normal)
        _backButton.backgroundColor = .darkGray
        _backButton.setTitleColor(.black, for: .normal)
        return _backButton
    }()
    
    override func viewDidLoad() {
        
        // Assume this is the userPayload of your broker id: 1 who will create a propery in SaudiArabia in city Riyadh in region AlMalqa
        let creatorUserPayload = createUserPayload(userId: "1-SaudiArabia-Riyadh-AlMalqa", username: "1", avatarURL: "https://img.icons8.com/?size=512&id=92&format=png", creatorTags: ["SaudiArabia", "SaudiArabia-Riyadh", "SaudiArabia-Riyadh-AlMalqa"], consumerTags: [])
        creatorUserManager = StorylyMomentsManager(config: Config(momentsToken: MOMENTS_INSTANCE_TOKEN, userPayload: creatorUserPayload ?? ""))
        creatorUserManager.rootViewController = self
        
        // Assume this is the userPayload of again your broker id: 2 who will create a propery in SaudiArabia in city Jeddah in  East region
        let creatorUserPayload1 = createUserPayload(userId: "2-SaudiArabia-Jeddah-East", username: "2", avatarURL: "https://img.icons8.com/?size=512&id=92&format=png", creatorTags: ["SaudiArabia", "SaudiArabia-Jeddah", "SaudiArabia-Jeddah-East"], consumerTags: [])
        creatorUserManager1 = StorylyMomentsManager(config: Config(momentsToken: MOMENTS_INSTANCE_TOKEN, userPayload: creatorUserPayload1 ?? ""))
        creatorUserManager1.rootViewController = self
        
        // Assume this is a guest customer who search a propert in SaudiArabia in city Jeddah in east region
        let consumerUserPayload = createUserPayload(userId: "guest", username: "guest", avatarURL: "https://img.icons8.com/?size=512&id=91&format=png", creatorTags: [], consumerTags: ["SaudiArabia-Jeddah-East"])
        
        // Assume this is a registered customer with id:10 who search a propert in SaudiArabia
        let consumerUserPayload1 = createUserPayload(userId: "10", username: "yigit", avatarURL: "https://img.icons8.com/?size=512&id=90&format=png", creatorTags: [], consumerTags: ["SaudiArabia"])
        
        // Assume this is a registered customer with id:11 who search a propert in SaudiArabia in city Riyadh in region AlMalqa
        let consumerUserPayload2 = createUserPayload(userId: "11", username: "cansu", avatarURL: "https://img.icons8.com/?size=512&id=89&format=png", creatorTags: [], consumerTags: ["SaudiArabia-Riyadh-AlMalqa"])
        
        // Assume this is the storylyView of your broker id: 1
        creatorStorylyView = StorylyView()
        creatorStorylyView.translatesAutoresizingMaskIntoConstraints = false
        creatorStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN, storylyPayload: creatorUserPayload)
        creatorStorylyView.rootViewController = self
        
        // Assume this is the storylyView of your broker id: 2
        creatorStorylyView1 = StorylyView()
        creatorStorylyView1.translatesAutoresizingMaskIntoConstraints = false
        creatorStorylyView1.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN, storylyPayload: creatorUserPayload1)
        creatorStorylyView1.rootViewController = self
        
        // This is your guest customer's view
        consumerStorylyView = StorylyView()
        consumerStorylyView.translatesAutoresizingMaskIntoConstraints = false
        consumerStorylyView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN, storylyPayload: consumerUserPayload)
        consumerStorylyView.rootViewController = self
        
        // This is the view of your customer id: 10
        consumerStorylyView1 = StorylyView()
        consumerStorylyView1.translatesAutoresizingMaskIntoConstraints = false
        consumerStorylyView1.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN, storylyPayload: consumerUserPayload1)
        consumerStorylyView1.rootViewController = self
        
        // This is the view of your customer id: 11
        consumerStorylyView2 = StorylyView()
        consumerStorylyView2.translatesAutoresizingMaskIntoConstraints = false
        consumerStorylyView2.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN, storylyPayload: consumerUserPayload2)
        consumerStorylyView2.rootViewController = self
        
        self.view.addSubview(creatorStorylyView)
        creatorStorylyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        creatorStorylyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        creatorStorylyView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        creatorStorylyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        creatorStorylyView.momentsItems = [createStoryViewPlaceholder(id: 1), createUserStoriesPlaceholder(id: 1)]
        
        self.view.addSubview(creatorStorylyView1)
        creatorStorylyView1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        creatorStorylyView1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        creatorStorylyView1.topAnchor.constraint(equalTo: self.creatorStorylyView.bottomAnchor).isActive = true
        creatorStorylyView1.heightAnchor.constraint(equalToConstant: 120).isActive = true
        creatorStorylyView1.momentsItems = [createStoryViewPlaceholder(id: 2), createUserStoriesPlaceholder(id: 2)]

        self.view.addSubview(consumerStorylyView)
        consumerStorylyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        consumerStorylyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        consumerStorylyView.topAnchor.constraint(equalTo: creatorStorylyView1.bottomAnchor).isActive = true
        consumerStorylyView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(consumerStorylyView1)
        consumerStorylyView1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        consumerStorylyView1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        consumerStorylyView1.topAnchor.constraint(equalTo: consumerStorylyView.bottomAnchor).isActive = true
        consumerStorylyView1.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(consumerStorylyView2)
        consumerStorylyView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        consumerStorylyView2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        consumerStorylyView2.topAnchor.constraint(equalTo: consumerStorylyView1.bottomAnchor).isActive = true
        consumerStorylyView2.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(refreshInstancesButton)
        refreshInstancesButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        refreshInstancesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        refreshInstancesButton.topAnchor.constraint(equalTo: consumerStorylyView2.bottomAnchor, constant: 40).isActive = true
        refreshInstancesButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    private func createUserPayload(userId: String, username: String, avatarURL: String, creatorTags: [String]?, consumerTags: [String]?) -> String? {
        let userId: String = userId
        let username: String = username
        let avatarURL: String = avatarURL
        let followings: [String] = []
        let creatorTags: [String]? = creatorTags
        let consumerTags: [String]? = consumerTags
        // Give the expiration time given in seconds that you want to expire this payload at that time
        let expirationTime: Int64 = Int64.max
        
        // This is just a sample for how to use helper method to create encrypted user payload
        // Create this structure with your own user information
        let momentsUserPayload = MomentsUserPayload(id: userId, username: username, avatarUrl: avatarURL, followings: followings, creatorTags: creatorTags, consumerTags: consumerTags, expirationTime: expirationTime)
        return momentsUserPayload.encryptUserPayload(secretKey: MOMENTS_INSTANCE_SECRET_KEY, initializationVector: MOMENTS_INSTANCE_INITIALIZATION_VECTOR)
    }
    
    private func createStoryViewPlaceholder(id: Int) -> MomentsItem {
        let _ugcView = UIView()
        _ugcView.translatesAutoresizingMaskIntoConstraints = false
        if id == 1 {
            _ugcView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onCreateStoryViewClicked(_:))))
        } else {
            _ugcView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onCreateStoryViewClicked1(_:))))
        }
        
        let _ugcProfileView = UIImageView(image: UIImage(named: "CreateStory"))
        _ugcProfileView.translatesAutoresizingMaskIntoConstraints = false
        _ugcView.addSubview(_ugcProfileView)
        _ugcProfileView.topAnchor.constraint(equalTo: _ugcView.topAnchor).isActive = true
        _ugcProfileView.leadingAnchor.constraint(equalTo: _ugcView.leadingAnchor).isActive = true
        _ugcProfileView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        _ugcProfileView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        _ugcProfileView.layer.cornerRadius = 40
        _ugcProfileView.backgroundColor = .gray

        let _ugcTextView = UILabel()
        _ugcTextView.translatesAutoresizingMaskIntoConstraints = false
        _ugcTextView.textAlignment = .center
        _ugcTextView.textColor = .white
        _ugcTextView.font = .systemFont(ofSize: 12)
        _ugcTextView.numberOfLines = 2
        _ugcTextView.text = "New Story"
        _ugcTextView.textColor = .black
        _ugcTextView.textAlignment = .center
        _ugcView.addSubview(_ugcTextView)
        _ugcTextView.leadingAnchor.constraint(equalTo: _ugcView.leadingAnchor).isActive = true
        _ugcTextView.trailingAnchor.constraint(equalTo: _ugcView.trailingAnchor).isActive = true
        _ugcTextView.topAnchor.constraint(equalTo: _ugcProfileView.bottomAnchor, constant: 6).isActive = true
        
        return MomentsItem(momentsView: _ugcView)
    }
    
    private func createUserStoriesPlaceholder(id: Int) -> MomentsItem {
        let _ugcView = UIView()
        _ugcView.translatesAutoresizingMaskIntoConstraints = false
        
        let _ugcProfileView = UIView()
        _ugcProfileView.translatesAutoresizingMaskIntoConstraints = false
        _ugcView.addSubview(_ugcProfileView)
        _ugcProfileView.topAnchor.constraint(equalTo: _ugcView.topAnchor).isActive = true
        _ugcProfileView.leadingAnchor.constraint(equalTo: _ugcView.leadingAnchor).isActive = true
        _ugcProfileView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        _ugcProfileView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        _ugcProfileView.layer.cornerRadius = 40
        
        let _ugcTextView = UILabel()
        _ugcTextView.translatesAutoresizingMaskIntoConstraints = false
        _ugcTextView.textAlignment = .center
        _ugcTextView.textColor = .black
        _ugcTextView.font = .systemFont(ofSize: 12)
        _ugcTextView.numberOfLines = 2
        _ugcView.addSubview(_ugcTextView)
        _ugcTextView.leadingAnchor.constraint(equalTo: _ugcView.leadingAnchor).isActive = true
        _ugcTextView.trailingAnchor.constraint(equalTo: _ugcView.trailingAnchor).isActive = true
        _ugcTextView.topAnchor.constraint(equalTo: _ugcProfileView.bottomAnchor, constant: 6).isActive = true
        _ugcTextView.text = "MyStories"
        if id == 1 {
            _ugcProfileView.backgroundColor = .red
            _ugcView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onUserStoryViewClicked(_:))))
        } else {
            _ugcProfileView.backgroundColor = .gray
            _ugcView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onUserStoryViewClicked1(_:))))
        }
        return MomentsItem(momentsView: _ugcView)
    }
    
    @objc private func onRefreshButton(_ sender: UIButton) {
        self.creatorStorylyView.refresh()
        self.creatorStorylyView1.refresh()
        self.consumerStorylyView.refresh()
        self.consumerStorylyView1.refresh()
        self.consumerStorylyView2.refresh()
    }
    
    @objc func onCreateStoryViewClicked(_ sender: UITapGestureRecognizer) {
        creatorUserManager.openStoryCreator()
    }
    
    @objc func onCreateStoryViewClicked1(_ sender: UITapGestureRecognizer) {
        creatorUserManager1.openStoryCreator()
    }
    
    @objc func onUserStoryViewClicked(_ sender: UITapGestureRecognizer) {
        creatorUserManager.openUserStories()
    }
    
    @objc func onUserStoryViewClicked1(_ sender: UITapGestureRecognizer) {
        creatorUserManager1.openUserStories()
    }
}
