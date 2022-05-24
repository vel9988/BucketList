//
//  ContentView.swift
//  BucketList
//
//  Created by Dmitryi Velko on 20.05.2022.
//

import SwiftUI
import MapKit
import LocalAuthentication


struct ContentView: View {
    var loadingState = LoadingState.loading
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    @State private var selectedPlace: Location?

    @State private var locations = [Location]()

    @State private var isUnlocked = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())

                        Text(location.name)
                            .fixedSize()
                    }
                    .onTapGesture {
                        selectedPlace = location
                    }
                }
            }
            .ignoresSafeArea()
            
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        // create a new location
                        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
        .sheet(item: $selectedPlace) { place in
            EditView(location: place) { newLocation in
                if let index = locations.firstIndex(of: place) {
                    locations[index] = newLocation
                }
            }
        }

    }
    //MARK: - Authenticate
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // проверьте, возможна ли биометрическая аутентификация
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // это возможно, так что идите вперед и используйте это
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // аутентификация завершена
                if success {
                    // аутентификация прошла успешно
                    isUnlocked = true
                } else {
                    // возникла проблема
                }
            }
        } else {
            // никаких биометрических данных
        }
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












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
