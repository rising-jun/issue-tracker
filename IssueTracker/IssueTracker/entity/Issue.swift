//
//  Issue.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/20.
//

import Foundation

// MARK: - WelcomeElement
struct Issue: Codable {
    let url, repositoryURL: String
    let labelsURL: String
    let commentsURL, eventsURL, htmlURL: String
    let id: Int
    let nodeID: String
    let number: Int
    let title: String
    let user: User
    let labels: [Label]
    let state: String
    let locked: Bool
    let assignee: User?
    let assignees: [User]
    let milestone: Milestone?
    let comments: Int
    let createdAt, updatedAt: Date
    let closedAt: JSONNull?
    let authorAssociation: String
    let activeLockReason: JSONNull?
    let body: String?
    let reactions: Reactions
    let timelineURL: String
    let performedViaGithubApp, stateReason: JSONNull?

    enum CodingKeys: String, CodingKey {
        case url
        case repositoryURL = "repository_url"
        case labelsURL = "labels_url"
        case commentsURL = "comments_url"
        case eventsURL = "events_url"
        case htmlURL = "html_url"
        case id
        case nodeID = "node_id"
        case number, title, user, labels, state, locked, assignee, assignees, milestone, comments
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case authorAssociation = "author_association"
        case activeLockReason = "active_lock_reason"
        case body, reactions
        case timelineURL = "timeline_url"
        case performedViaGithubApp = "performed_via_github_app"
        case stateReason = "state_reason"
    }
}

// MARK: - User
struct User: Codable {
    let login: Login
    let id: Int
    let nodeID: NodeID
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL: String
    let gistsURL: GistsURL
    let starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: EventsURL
    let receivedEventsURL: String
    let type: TypeEnum
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

enum EventsURL: String, Codable {
    case httpsAPIGithubCOMUsersRisingJunEventsPrivacy = "https://api.github.com/users/rising-jun/events{/privacy}"
    case httpsAPIGithubCOMUsersSanghyeokKimEventsPrivacy = "https://api.github.com/users/sanghyeok-kim/events{/privacy}"
}

enum GistsURL: String, Codable {
    case httpsAPIGithubCOMUsersRisingJunGistsGistID = "https://api.github.com/users/rising-jun/gists{/gist_id}"
    case httpsAPIGithubCOMUsersSanghyeokKimGistsGistID = "https://api.github.com/users/sanghyeok-kim/gists{/gist_id}"
}

enum Login: String, Codable {
    case risingJun = "rising-jun"
    case sanghyeokKim = "sanghyeok-kim"
}

enum NodeID: String, Codable {
    case mdq6VXNlcjU3NjY3NzM4 = "MDQ6VXNlcjU3NjY3NzM4"
    case mdq6VXNlcjYyNjg3OTE5 = "MDQ6VXNlcjYyNjg3OTE5"
}

enum TypeEnum: String, Codable {
    case user = "User"
}

// MARK: - Label
struct Label: Codable {
    let id: Int
    let nodeID: String
    let url: String
    let name, color: String
    let labelDefault: Bool
    let labelDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case url, name, color
        case labelDefault = "default"
        case labelDescription = "description"
    }
}

// MARK: - Milestone
struct Milestone: Codable {
    let url, htmlURL, labelsURL: String
    let id: Int
    let nodeID: String
    let number: Int
    let title, milestoneDescription: String
    let creator: User
    let openIssues, closedIssues: Int
    let state: String
    let createdAt, updatedAt, dueOn: Date
    let closedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case url
        case htmlURL = "html_url"
        case labelsURL = "labels_url"
        case id
        case nodeID = "node_id"
        case number, title
        case milestoneDescription = "description"
        case creator
        case openIssues = "open_issues"
        case closedIssues = "closed_issues"
        case state
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dueOn = "due_on"
        case closedAt = "closed_at"
    }
}

// MARK: - Reactions
struct Reactions: Codable {
    let url: String
    let totalCount, the1, reactions1, laugh: Int
    let hooray, confused, heart, rocket: Int
    let eyes: Int

    enum CodingKeys: String, CodingKey {
        case url
        case totalCount = "total_count"
        case the1 = "+1"
        case reactions1 = "-1"
        case laugh, hooray, confused, heart, rocket, eyes
    }
}

typealias Welcome = [Issue]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
