import SwiftUI
import MessageUI

struct FeatureRequestView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["chriskersov@gmail.com"]) // Replace with your email
        vc.setSubject("LeetCode Statistics Feature Request")
        vc.setMessageBody("I would like to request the following feature:\n\n", isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: FeatureRequestView
        
        init(_ parent: FeatureRequestView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                 didFinishWith result: MFMailComposeResult,
                                 error: Error?) {
            parent.isShowing = false
        }
    }
}
