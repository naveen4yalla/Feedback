//
//  Tag-CoreDatahelper.swift
//  SpringApp
//
//  Created by Naveen Yalla on 5/23/23.
//

import Foundation

extension Tag {
    var tagId: UUID {
        id ?? UUID()
    }
    
    var tagName: String{
        name ?? ""
    }
    var tagActiveIssues:[Issue]{
        var result = issues?.allObjects as? [Issue] ?? []
        result = result.filter { $0.completed == false }
       
        return result
    }
    
    static var example: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let tag = Tag(context: viewContext)
        tag.id = UUID()
        tag.name = "Example Tag"
        return tag
        
    }
}
extension Tag:Comparable {
    public static func <(lhs: Tag ,rhs: Tag) -> Bool {
        let left = lhs.tagName.localizedLowercase
        let right = rhs.tagName.localizedLowercase
        
        if left == right {
            return lhs.tagId.uuidString < rhs.tagId.uuidString
        }
        else{
            return left<right
        }
    }
}
