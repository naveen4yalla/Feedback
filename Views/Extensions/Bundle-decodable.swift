//
//  Bundle-decodable.swift
//  SpringApp
//
//  Created by Naveen Yalla on 6/18/23.
//

import Foundation

extension Bundle {
    
//    We’re extending Foundation’s Bundle class, which is responsible for working with all our main app’s code and resources – the binary itself, any asset catalogs, the Info.plist file, and more. You can actually have several bundles inside an app, for example if you have extensions to communicate with Siri or WidgetKit, so by extending Bundle we’re making our code available in any part of our app.
//
//    Now for the most important part of this code: the method signature. This is going to use generics, which means we tell Swift that we don’t know what specific type of data we’ll use it with – it will figure that out from how we use the method. Rather than referring to Int or String, we use a placeholder type that can be named whatever we want: ObjectType, MyType, all Banana all do exactly the same thing, because it’s just a placeholder and its meaning will change based on how we actually use the method.
//
//    Swift developers conventionally use T to represent these placeholders, but this is a great place where you have room to discuss your choice during an interview – do you go with a common convention, or choose a name that works better for you?
//
//    Anyway, let’s put in the method signature so you can see what’s going on – put this inside the Bundle extension:
    
    func decode<T: Decodable>(
        _ file: String,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
                    fatalError("Failed to locate \(file) in bundle.")
                }

                guard let data = try? Data(contentsOf: url) else {
                    fatalError("Failed to load \(file) from bundle.")
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy
                decoder.keyDecodingStrategy = keyDecodingStrategy

                do {
                    return try decoder.decode(T.self, from: data)
                } catch DecodingError.keyNotFound(let key, let context) {
                    fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
                } catch DecodingError.typeMismatch(_, let context) {
                    fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(_) {
                    fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
                } catch {
                    fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
                }
            }
        }

        
    



//Yes, that’s a hefty signature, so let’s break it down.
//
//The method itself is called decode(), so when using it we’ll write something like Bundle.main.decode(…).
//
//We don’t know what kind of data we’ll be working with, so we give our method a generic type parameter – that placeholder type I mentioned – and name it T.
//
//However, T can’t be anything because Swift can’t decode any kind of data. Instead, we want to use Swift’s Codable system, and that means we are happy for T to be any kind of data at all as long as it’s something that conforms to Decodable. (In case you didn’t know, Codable isn’t actually a protocol by itself, and is instead just a typealias for Encodable and Decodable.
//
//As for the method’s parameters, the first parameter is an easy one: a file name that exists in whatever bundle is being used, so we know which file to load.
//
//The second parameter is of T.Type, and is more complicated. Remember, T is a placeholder for some unknown type, but for now let’s pretend it’s Int because this makes this part easier to understand.
//
//You know that 5 is an Int, as are 44, 444, and 44,444,444; they are all instances of the Int type. When we want to refer to Int itself – to say “I want to refer to all integers generally, rather than a specific number” – we write Int.self.
//
//You can see this in action when you use Codable normally – you’d write something like this:
//
//let items = JSONDecoder().decode(WishList.self, from: jsonData)
//That means we want to decode something new as a WishList object, rather to decode some specific WishList value we already have. So, Int.self refers to the Int type itself, just like WishList.self refers to the WishList type itself.
//
//All this is important because we’re saying our method will accept a T.Type. Remember, T is our placeholder, so it might be an integer, a string, or something else. Type means a type rather than an instance of a type, so this means writing Int.self or WishList.self rather than 5 or a specific WishList object.
//
//So, put together T.Type means “some kind of type, as long as it conforms to the Decodable protocol.” Yes, that’s a lot of explanation for a tiny piece of code, but this is what really makes the method awesome: we can make it load any kind of decodable data.
//
//To make things slightly more complex (but just an extra bit easier to use!), the type parameter has a default value of T.self. So, combined it means “tell me what type to decode, and if possible try to figure it out based on context.” So, that means if Swift knows we’ll be returning an array of strings (for example, if we’re assigning to a property declared with that type) then we can just give this method a filename, but if Swift doesn’t know what type will be decoded then we need to be explicit.
//
//Moving on, we have two straightforward parameters:
//
//A date decoding strategy, so we can handle dates in whatever way makes sense for this JSON file. It defaults to .deferredToDate, which is the default behavior for Codable.
//A key decoding strategy, so we can convert between snake_case and camelCase. Again, this has a default value that matches Codable.
//Finally, the method will return a T. So, we have T being used in four ways:
//
//We write the generic type parameter T in angle brackets after the method name, to tell Swift there’s a placeholder called T and it must be Decodable.
//We specify T.Type as the second parameter, meaning that we can say exactly which type we’re trying to decode using something like [String].self.
//Using T.self as the default value for the type means that if Swift can figure out we’re decoding an array of strings from other context (like how the return value is being used), then it will fill in the [String].self part for us.
//The return type is T.
//Swift is really smart here: if we call this method with [String].self, Swift can work backwards and realize that if T.Type is [String].self, then T must be [String]. Similarly, if all it knows is the return type must be a [String] then it will fill in the rest of the parameters from that.
//
//Phew! That was a lot of explaining, but I hope it’s really clear.
//
//Anyway, let’s move on with the much easier part of this code: the body of the method.
//
//First, we’re going to find the actual location of the requested file inside the current bundle, and if that fails call fatalError() to crash the app. Replace the // more code to come comment with this:
