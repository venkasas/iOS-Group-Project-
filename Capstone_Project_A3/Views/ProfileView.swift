//
//  ProfileView.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-12-15.
//

import SwiftUI

struct ProfileView: View {
    @Binding var userRole: UserRole
    

    var body: some View {
        VStack(spacing: 20) {
//            Text("Profile")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.top, 40)

            Text("Select Your Role")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            Spacer()

            

            Picker("Role", selection: $userRole) {
                ForEach(UserRole.allCases, id: \.self) { role in
                    Text(role.rawValue.capitalized).tag(role)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            Spacer()

            Text("You are currently viewing as:")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("\(userRole.rawValue.capitalized)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.blue)

            Spacer()
        }

        .padding()
        .onChange(of: userRole) { _, newRole in
            // Save the selected role in UserDefaults
            UserDefaults.standard.setValue(newRole.rawValue, forKey: "userRole")
        }
    }
}




