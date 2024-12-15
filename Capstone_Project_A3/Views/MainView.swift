import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showMenu = false
    @State private var selectedMenu: MenuOption? = .myListings
    @State private var userRole: UserRole = UserDefaults.standard
        .string(forKey: "userRole").flatMap(UserRole.init) ?? .lister

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if userRole == .lister {
                        switch selectedMenu {
                        case .addListing:
                            AddListingView(context: viewContext)
                        case .myListings:
                            MyListingsView(userRole: userRole)
                        case .profile:
                            ProfileView(userRole: $userRole)
                        case .none:
                            Text("Select an Option")
                        case .renterReservations:
                            EmptyView() // Placeholder since listers shouldn't see this
                        }
                    } else if userRole == .renter {
                        switch selectedMenu {
                        case .myListings:
                            RenterListingsView(context: viewContext)
                        case .renterReservations:
                            RenterReservationsView(context: viewContext)
                        case .profile:
                            ProfileView(userRole: $userRole)
                        default:
                            RenterListingsView(context: viewContext) // Fallback
                        }
                    }
                }
                .navigationTitle(selectedMenu?.title ?? "Menu")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                    }
                }
            }

            // Hamburger Menu
            if showMenu {
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(filteredMenuOptions, id: \.self) { menuOption in
                            Button(action: {
                                withAnimation {
                                    selectedMenu = menuOption
                                    showMenu = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: menuOption.icon)
                                    Text(menuOption.title)
                                        .font(.headline)
                                }
                                .padding()
                                .foregroundColor(.primary)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: 250)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    Spacer()
                }
                .background(Color.black.opacity(0.4))
                .onTapGesture {
                    withAnimation {
                        showMenu = false
                    }
                }
            }
        }
    }

    private var filteredMenuOptions: [MenuOption] {
        switch userRole {
        case .renter:
            return [.myListings, .renterReservations, .profile]
        case .lister:
            return [.addListing, .myListings, .profile]
        }
    }
}

enum MenuOption: CaseIterable {
    case addListing
    case myListings
    case profile
    case renterReservations

    var title: String {
        switch self {
        case .addListing: return "Post a Listing"
        case .myListings: return "View Listings"
        case .profile: return "Profile"
        case .renterReservations: return "My Reservations"
        }
    }

    var icon: String {
        switch self {
        case .addListing: return "plus.circle"
        case .myListings: return "list.bullet"
        case .profile: return "person.circle"
        case .renterReservations: return "bookmark.fill"
        }
    }
}

enum UserRole: String, CaseIterable {
    case renter = "renter"
    case lister = "lister"
}
