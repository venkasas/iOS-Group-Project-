import SwiftUI
import CoreData

struct MyListingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Listing.timestamp, ascending: true)],
        animation: .default)
    private var listings: FetchedResults<Listing>

    let userRole: UserRole // Role to determine permissions

    var body: some View {
        List {
            ForEach(listings) { listing in
                VStack(alignment: .leading) {
                    Text(listing.name ?? "Unknown Name")
                        .font(.headline)
                    Text("Location: \(listing.address ?? "Unknown Address")")
                        .font(.subheadline)
                    Text("Price: $ \(listing.price ?? "N/A")")
                        .font(.caption)

                    // Edit option only for listers
                    if userRole == .lister {
                        NavigationLink(destination: EditListingView(listing: listing)) {
                            Text("Edit Listing")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()

                // Delete option only for listers
            }
            .onDelete(perform: userRole == .lister ? deleteListing : nil)
        }
        .navigationTitle("View/Edit Listings")
        .toolbar {
            if userRole == .lister {
                EditButton()
            }
        }
    }

    private func deleteListing(at offsets: IndexSet) {
        for index in offsets {
            let listing = listings[index]
            viewContext.delete(listing)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting listing: \(error.localizedDescription)")
        }
    }
}

