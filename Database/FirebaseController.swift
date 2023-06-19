//
//  FirebaseController.swift
//  ass2-5140
//
//  Created by haofang Liu on 1/10/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class FirebaseController: NSObject, DatabaseProtocol {
    
    //let DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()
    //    The variables authController and database are used to store a reference to the
    //    (singleton) instance of each class.
    var authController: Auth
    var database: Firestore
    //    heroesRef and teamsRef each hold a reference to the SuperHero collection and
    //    Team collection respectively in Firestore
    //    We can maintain references to either collections or documents themselves
    //    o In this application we are using top level listeners.
    //    ▪ For this use case that is fine. However, in large complex datasets this
    //    can mean huge complex lists of data to maintain.
    var rgbRef: CollectionReference?
    var weatherRef: CollectionReference?
    var diaryRef:CollectionReference?
    
    //    Unlike the CoreDataController from last week, our FirebaseController will maintain a
    //    list of SuperHeroes and the default team itself.
    var rgb: Rgb
    var weather: Weather
    var diaryList: [Diary]
    
    //    The initialiser method:
    //    o We use the function signInAnonymously on FirebaseAuth to generate a logon
    //    for our application. All users will see the same data.
    //    o This signIn method requires no information from the user and will generate a
    //    unique authentication ID. This ID is retained for this device across multiple
    //    application runs (the user stays logged in).
    //    o Only if the authentication is successful do we then tell the controller to setup
    //    the Firestore listeners. Due to our security settings we MUST have a valid
    //    authentication to access Firestore.
    //    o Do note this sign in happens ASYNCRONOUSLY. The closure here that sets
    //    up the listeners will happen at some point later (we do not know when!)
    
    override init() {
        // To use Firebase in our application we first must run the FirebaseApp configure method
        FirebaseApp.configure()
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
        rgb = Rgb()
        weather = Weather()
        diaryList = [Diary]()
        
        super.init()
        
        // This will START THE PROCESS of signing in with an anonymous account
        // The closure will not execute until its recieved a message back which can be any time later
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            // Once we have authenticated we can attach our listeners to the firebase firestore
            self.setUpListeners()
        }
    }
    
    
    //    The setUpListeners method does as its name implies! The function sets up a listener
    //    to both the SuperHero collection and the Team collection.
    //    o Firestore allows us several methods of getting data.
    //    o The snapshot listener will return a snapshot of the data for the given
    //    reference. In our case this is the ENTIRE collection of SuperHeroes.
    //    o It is important to note that this query contains ALL heroes not just ones that
    //    have been updated. We need to filter this out ourselves.
    //    o Every time an update is made to the SuperHeroes this method will be called
    //    and will call parseHeroesSnapshot.
    //    o This all happens asynchronously (again, we don’t know exactly when).
    //    o The teamsRef snapshot functions identically. However, when it passes to the
    //    parseTeamSnapshot method it only provides the first Team.
    
    func setUpListeners() {
        
        rgbRef = database.collection("rgbUpdate")
        rgbRef?.addSnapshotListener { querySnapshot,error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching rgb: \(error!)")
                return
            }
            self.parseRgbSnapshot(snapshot: documents)
        }
            
            weatherRef = database.collection("weatherUpdate")
            weatherRef?.addSnapshotListener { querySnapshot,error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching weather: \(error!)")
                    return
                }
                self.parseWeatherSnapshot(snapshot: documents.first!)
        }
        
        diaryRef = database.collection("diary")
        diaryRef?.addSnapshotListener { querySnapshot,error in
            guard (querySnapshot?.documents) != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseDiarySnapshot(snapshot: querySnapshot!)
        }
    }
    
    func parseRgbSnapshot(snapshot: [QueryDocumentSnapshot]) {
        for snap in snapshot{
            
            let uid = "340"
            if uid == snap.data()["blue"] as! String{
                rgb = Rgb()
                rgb.red = (snap.data()["red"] as! String)
                print(".........++++++++ this time yes!!!!!!!!!!++++++++++++......\(rgb.red)")
                rgb.green = (snap.data()["green"] as! String)
                rgb.blue = (snap.data()["blue"] as! String)
            }
            //rgb.id = snap.documentID
        }
        
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.rgb || listener.listenerType == ListenerType.all {
                listener.onRgbChange(change: .update, rgb: rgb)
            }
        }
    }
    
    func parseWeatherSnapshot(snapshot: QueryDocumentSnapshot) {
        
        weather = Weather()
        weather.temp = (snapshot.data()["temp"] as! String)
        weather.pressure = (snapshot.data()["pressure"] as! String)
        weather.id = snapshot.documentID
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.weather || listener.listenerType == ListenerType.all {
                listener.onWeatherChange(change: .update, weather: weather)
            }
        }
    }
    
    
    
    
      
    
    //    The parseTeamSnapshot method takes the single team snapshot and parses it into
    //    a useable format in our application.
    //    o We create a new team object here and fill it in using the details from the
    //    snapshot
    //    o If the document contains a “heroes” field (a list of references), we loop
    //    through each of them and get that hero from the main hero list.
    //    ▪ These references are FireStore references, which we could listen to or
    //    pull data from directly if we wanted to!
    //    • That is not done here as it’s not really needed, but it’s useful to
    //    know for other use cases
    func parseDiarySnapshot(snapshot: QuerySnapshot) {
        
        snapshot.documentChanges.forEach { change in
            
            //    o Inside this loop we can get the SuperHero data for each document. The data
            //    is stored as a Dictionary of Any with Strings as the keys.
            let documentRef = change.document.documentID
            let title = change.document.data()["title"] as! String
            let content = change.document.data()["content"] as! String
            let date = change.document.data()["date"] as! String
            let red = change.document.data()["red"] as! String
            let green = change.document.data()["green"] as! String
            let blue = change.document.data()["blue"] as! String
            let pressure = change.document.data()["pressure"] as! String
            let temp = change.document.data()["temp"] as! String
            print(documentRef)
            
            if change.type == .added {
                print("New Diary: \(change.document.data())")
                let diaryNew = Diary()
                diaryNew.title = title
                diaryNew.content = content
                diaryNew.date = date
                diaryNew.red = red
                diaryNew.green = green
                diaryNew.blue = blue
                diaryNew.pressure = pressure
                diaryNew.temp = temp
                diaryNew.id = documentRef
                
                diaryList.append(diaryNew)
            }
            
            if change.type == .removed {
                print("Removed Diary: \(change.document.data())")
                if let index = getDiaryIndexByID(reference: documentRef) {
                    diaryList.remove(at: index)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.diary || listener.listenerType == ListenerType.all {
                listener.onDiaryListChange(change: .update, diaries: diaryList)
            }
        }
    }

    
    //    The getHeroIndexByID method takes in an ID and returns the index of the hero in
    //    the array. If it’s not present in the array, the method returns nil instead.
    
    func getDiaryIndexByID(reference: String) -> Int? {
        for diary in diaryList {
            if(diary.id == reference) {
                return diaryList.firstIndex(of: diary)
            }
        }
        
        return nil
    }
   
    func addDiary(title: String, content: String, date: String, red :String,green :String,blue :String, temp :String, pressure : String) -> Diary {
        let diary = Diary()
        let id = diaryRef?.addDocument(data: ["title" : title, "content" : content, "date" : date, "red" : red, "green" : green, "blue" : blue, "temp" : temp, "pressure" : pressure])
        diary.title = title
        diary.content = content
        diary.date = content
        diary.red = red
        diary.green = green
        diary.blue = blue
        diary.temp = temp
        diary.pressure = pressure
        
        diary.id = id!.documentID
        
        return diary
    }
    
    func getWeather() -> Weather{
        let weatherOne = Weather()
        let weatherRefDoc = weatherRef?.document("weather1")
        
        weatherRefDoc!.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let temp = (document.data()!["temp"] as! String)
                let pressure = (document.data()!["pressure"] as! String)
//                weatherOne.pressure = (document.data()!["pressure"] as! String)
//                weatherOne.temp = (document.data()!["temp"] as! String)
                print("Document data: \(dataDescription)")
                
                weatherOne.pressure = pressure
                weatherOne.temp = temp
                weatherOne.id = document.documentID
                print("temp: \(weatherOne.temp)")
                print("pressure: \(weatherOne.pressure)")
            } else {
                print("Document does not exist")
            }
        }
        
        return weatherOne
    }
    
    func getRgb() -> Rgb{
        let rgbOne = Rgb()
        let rgbRefDoc = rgbRef?.document("rgb1")
        rgbRefDoc!.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let red = (document.data()!["red"] as! String)
                let green = (document.data()!["green"] as! String)
                let blue = (document.data()!["blue"] as! String)
                //                weatherOne.pressure = (document.data()!["pressure"] as! String)
                //                weatherOne.temp = (document.data()!["temp"] as! String)
                print("Document data: \(dataDescription)")
                
                rgbOne.red = red
                rgbOne.green = green
                rgbOne.blue = blue
                rgbOne.id = document.documentID
                print("red: \(rgbOne.red)")
                print("green: \(rgbOne.green)")
                print("blue: \(rgbOne.blue)")
            } else {
                print("Document does not exist")
            }
        }
        
        return rgbOne
    }
    
//    func getRgb() -> Rgb{
//        let newRgb = Rgb()
//        let docRef = rgbRef!.document("rgb1")
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                newRgb.red = document.data()!["red"] as! String
//                newRgb.green = document.data()!["green"] as! String
//                newRgb.blue = document.data()!["blue"] as! String
//            } else {
//                print("Document does not exist")
//            }
//        }
//        return newRgb
//    }
    
    
    
    func deleteDiary(diary: Diary) {
        diaryRef?.document(diary.id).delete()
    }
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.diary || listener.listenerType == ListenerType.all {
            listener.onDiaryListChange(change: .update, diaries: diaryList)
        }
//
//        if listener.listenerType == ListenerType.heroes || listener.listenerType == ListenerType.all {
//            listener.onHeroListChange(change: .update, heroes: heroList)
//        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

}
