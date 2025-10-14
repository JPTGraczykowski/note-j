import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["container", "backdrop"]

  connect() {
    // Prevent body scroll when modal is open
    document.body.style.overflow = "hidden"
  }

  disconnect() {
    // Restore body scroll when modal is closed
    document.body.style.overflow = ""
  }

  close(event) {
    // Close modal when clicking backdrop or close button
    if (event) {
      event.preventDefault()
    }

    // Remove the modal element from the DOM
    this.element.remove()
  }

  closeOnEscape(event) {
    // Close modal when pressing Escape key
    if (event.key === "Escape") {
      this.close(event)
    }
  }

  // Prevent closing when clicking inside the modal container
  stopPropagation(event) {
    event.stopPropagation()
  }
}
