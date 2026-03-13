import SwiftUI
import Combine

// MARK: - Booking Model
struct BookingItem: Identifiable {
    let id = UUID()
    var doctorName:     String
    var specialty:      String
    var date:           String
    var time:           String
    var status:         BookingStatus
    var tokenNumber:    String
}

enum BookingStatus: String {
    case upcoming  = "Upcoming"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

// MARK: - ViewModel
final class BookingsViewModel: ObservableObject {

    @Published var selectedFilter: BookingStatus = .upcoming

    @Published var bookings: [BookingItem] = [
        BookingItem(doctorName: "Dr. Mohan Silva",    specialty: "Dermatologist",    date: "18 Mar 2026", time: "10:00 AM", status: .upcoming,  tokenNumber: "055"),
        BookingItem(doctorName: "Dr. Sarah Johnson",  specialty: "Cardiologist",     date: "20 Mar 2026", time: "02:30 PM", status: .upcoming,  tokenNumber: "023"),
        BookingItem(doctorName: "Dr. Michael Chen",   specialty: "Neurologist",      date: "10 Mar 2026", time: "09:00 AM", status: .completed, tokenNumber: "041"),
        BookingItem(doctorName: "Dr. Emily Rodriguez",specialty: "General Physician",date: "05 Mar 2026", time: "11:15 AM", status: .cancelled, tokenNumber: "017"),
    ]

    var filteredBookings: [BookingItem] {
        bookings.filter { $0.status == selectedFilter }
    }

    var upcomingCount: Int   { bookings.filter { $0.status == .upcoming }.count }
    var completedCount: Int  { bookings.filter { $0.status == .completed }.count }
    var cancelledCount: Int  { bookings.filter { $0.status == .cancelled }.count }

    func cancelBooking(_ item: BookingItem) {
        if let idx = bookings.firstIndex(where: { $0.id == item.id }) {
            bookings[idx].status = .cancelled
        }
    }
}
