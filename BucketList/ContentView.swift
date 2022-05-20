//
//  ContentView.swift
//  BucketList
//
//  Created by Dmitryi Velko on 20.05.2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var loadingState = LoadingState.loading
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))


    
    var body: some View {
        Map(coordinateRegion: $mapRegion)

    }
    
    //MARK: - Get Documents Directory
    func getDocumentsDirectory() -> URL {
        // найдите все возможные каталоги документов для этого пользователя
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // просто отправьте обратно первое письмо, которое должно быть единственным
        return paths[0]
    }
}

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}


struct User: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String

    static func <(lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

//extension FileManager {
//    func decode<T: Encodable>(_ file: URL) ->
//}










struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
