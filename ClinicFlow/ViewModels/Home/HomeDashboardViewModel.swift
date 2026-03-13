import SwiftUI
import Combine

final class HomeDashboardViewModel: ObservableObject {

    // MARK: - Navigation State
    @Published var navigateToPatientDetails = false
    @Published var navigateToConsultation   = false
    @Published var navigateToPharmacy       = false
    @Published var navigateToLab            = false
    @Published var navigateToDirections     = false

    // MARK: - Actions
    func openConsultation()   { navigateToConsultation   = true }
    func openLab()            { navigateToLab            = true }
    func openPharmacy()       { navigateToPharmacy       = true }
    func openDirections()     { navigateToDirections     = true }
    func openPatientDetails() { navigateToPatientDetails = true }

    // MARK: - Done Callbacks (collapse navigation stack)
    func dismissConsultation()   { navigateToConsultation   = false }
    func dismissLab()             { navigateToLab            = false }
    func dismissPharmacy()        { navigateToPharmacy       = false }
    func dismissPatientDetails()  { navigateToPatientDetails = false }
}
