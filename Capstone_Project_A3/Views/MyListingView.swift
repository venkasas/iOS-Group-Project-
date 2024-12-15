import SwiftUI
import CoreData

struct MyListingsView: View {
    @StateObject private var viewModel: ListingViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ListingViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.listings) { listing in
                    VStack(alignment: .leading) {
                        Text(listing.name ?? "Unknown Name")
                            .font(.headline)
                        Text(listing.location ?? "Unknown Location")
                            .font(.subheadline)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let listing = viewModel.listings[index]
                        viewModel.deleteListing(listing)
                    }
                }
            }
            .navigationTitle("My Listings")
            .toolbar {
                EditButton()
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
