# Bow Ties
A demo application demonstrating how to subclass NSManagedObject along with how to use data validation with core data

### Materials Covered
- **NSCoding Protocol** - The NSCoding protocol is a simple way to archive and unarchive objects into data buffers so they can be saved to disk.
- **Transformable** - You can save any data type to Core Data (even ones you define) using the transformable type as long as your type conforms to the NSCoding protocol.
- **Corresponding class for each attribute type** 
    - String maps to String
    - Integer 16/32/64, Float, Double and Boolean map to NSNumber • Decimal maps to NSDecimalNumber
    - Date maps to NSDate
    - Binary data maps to NSData
    - Transformable maps to AnyObject
- **NSPredicate** - i.e `fetchRequest.predicate = NSPredicate(format: "searchKey != nil)`
- **Storing images in Core Data** - Instantiate the UIImage and immediately convert it into NSData by means of UIImagePNGRepresentation() before storing it in the imageData property.
- **NSError Standard Practice** - Check the domain and code for the error to determine what went wrong.

