//
//  Issue-CoreDataHelper.swift
//  SpringApp
//
//  Created by Naveen Yalla on 5/23/23.
//

import Foundation
extension Issue {
    var issueTitle: String {
        get {title ?? ""}
        set {title = newValue }
    }
    var issueContent: String {
        get { content ?? ""}
        set { content = newValue }
    }
    
    var issueCreationDate: Date {
        creationDate ?? .now
    }
    
    var issueModificationDate : Date {
        modificationDate ?? .now
        
    }
    
    var issueStatus: String {
        if completed {
            return "Closed"
        } else {
            return "Open"
        }
    }
    var issueFormattedCreationDate: String {
        issueCreationDate.formatted(date: .numeric, time: .omitted)
    }
    var issueTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    
    static var example: Issue {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let issue = Issue(context: viewContext)
        issue.title = "Example Issue"
        issue.content = "This is a example issue"
        issue.priority = 2
        issue.creationDate = .now
        return issue
    }
}
extension Issue:Comparable {
    public static func<(lhs:Issue ,rhs:Issue) -> Bool {
        let left = lhs.issueTitle.localizedLowercase
        let right = rhs.issueTitle.localizedLowercase
        
        if left == right {
            return lhs.issueCreationDate < rhs.issueCreationDate
        }
        else{
            return left < right
        }
    }
    var issueTagsList: String {
        guard let tags else { return "No tags" }

        if tags.count == 0 {
            return "No tags"
        } else {
            return issueTags.map(\.tagName).formatted()
        }
    }
}
