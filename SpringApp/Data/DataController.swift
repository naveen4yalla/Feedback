//
//  DataController.swift
//  SpringApp
//
//  Created by Naveen Yalla on 5/11/23.
//

import Foundation
import CoreData
class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    @Published var selectedFilter: Filter? = Filter.all
    
    
    static var preview:DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
        
    }()
                                            
    
    init(inMemory: Bool = false)
    {
        container = NSPersistentCloudKitContainer(name: "Model")
        if inMemory {
            
            container.persistentStoreDescriptions.first?.url = URL(string: "/dev/null")
            
        }
        container.loadPersistentStores{ storeDescription , error in
            if let error {
                fatalError("fatal error loading store:\(error.localizedDescription)")
            }
            
        }
    }
    
    func createSampleData(){
        let viewContext = container.viewContext
        for i in 1...5{
            let tag = Tag(context:viewContext)
            tag.id = UUID()
            tag.name = "Tag\(i)"
            
            for j in 1...10{
                let issue = Issue(context: viewContext)
                issue.title = "Issue\(i)-\(j)"
                issue.content = "Description goes here"
                issue.creationDate = .now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
            }
        }
        try? viewContext.save()
        
    }
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    func delete(_ object: NSManagedObject){
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
        
    }
    private func delete(_ fetchRequest:NSFetchRequest<NSFetchRequestResult>)
    {
        //Get what have been deleted
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult{
            let changes = [NSDeletedObjectsKey:delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave:changes,into:[container.viewContext])
            
            
        }
    }
    func deleteAll(){
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request2)
        
        save()
    }
        
}
