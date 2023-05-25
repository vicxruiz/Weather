//
//  HomeView.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/25/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        makeBody()
    }
    
    func makeBody() -> some View {
        VStack {
            HomeControllerRepresentable()
        }
    }
}
