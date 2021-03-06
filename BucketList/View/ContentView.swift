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
    
    @StateObject private var viewModel = ViewModel()
    
    @State private var isUnlocked = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
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
                        viewModel.selectedPlace = location
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
                        viewModel.addLocation()
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
        .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
                viewModel.update(location: newLocation)
            }
        }
    }
    
    
    //MARK: - Authenticate
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // ??????????????????, ???????????????? ???? ???????????????????????????? ????????????????????????????
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // ?????? ????????????????, ?????? ?????? ?????????? ???????????? ?? ?????????????????????? ??????
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // ???????????????????????????? ??????????????????
                if success {
                    // ???????????????????????????? ???????????? ??????????????
                    isUnlocked = true
                } else {
                    // ???????????????? ????????????????
                }
            }
        } else {
            // ?????????????? ???????????????????????????? ????????????
        }
    }
    
    //MARK: - Get Documents Directory
    func getDocumentsDirectory() -> URL {
        // ?????????????? ?????? ?????????????????? ???????????????? ???????????????????? ?????? ?????????? ????????????????????????
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // ???????????? ?????????????????? ?????????????? ???????????? ????????????, ?????????????? ???????????? ???????? ????????????????????????
        return paths[0]
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
    
    
    
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
