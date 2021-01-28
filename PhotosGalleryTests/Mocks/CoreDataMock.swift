//
//  CoreDataMock.swift
//  PhotosGalleryTests
//
//  Created by Malek TRABELSI on 28/01/2021.
//

import XCTest
import CoreData
@testable import PhotosGallery

class CoreDataMock {

    public static let modelName = "PhotosGallery"

    public static let model: NSManagedObjectModel = {
      let modelURL = Bundle.main.url(forResource: CoreDataMock.modelName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    public lazy var mainContext: NSManagedObjectContext = {
      return storeContainer.viewContext
    }()
    public lazy var storeContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: CoreDataMock.modelName, managedObjectModel: CoreDataMock.model)
      container.loadPersistentStores { _, error in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()
    public init() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(
            name: CoreDataMock.modelName,
            managedObjectModel: CoreDataMock.model)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        storeContainer = container
    }
}

class UserWorker {
    let managedObjectContext: NSManagedObjectContext
    let coreDataMock: CoreDataMock

    public init(managedObjectContext: NSManagedObjectContext, coreDataMock: CoreDataMock) {
      self.managedObjectContext = managedObjectContext
      self.coreDataMock = coreDataMock
    }
    func addUser(_ user: User) -> UserEntity {
      let newUser = UserEntity(context: managedObjectContext)
      newUser.id = user.id
      newUser.name = user.name
      newUser.email = user.email
      newUser.username = user.username
      newUser.website = user.website
      newUser.phone_number = user.phone
      do {
          try managedObjectContext.save()
      } catch let error as NSError {
          fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      return newUser
    }
}
@objc(UserEntity)
class UserEntity: NSManagedObject {}
extension UserEntity {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<UserEntity> {
    return NSFetchRequest<UserEntity>(entityName: "PhotosGallery")
  }
  // swiftlint:disable identifier_name
  @NSManaged public var id: Int
  @NSManaged public var name: String
  @NSManaged public var email: String
  @NSManaged public var phone_number: String
  @NSManaged public var username: String
  @NSManaged public var website: String
}
