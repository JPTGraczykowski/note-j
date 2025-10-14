import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="folder-editor"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    // Focus the input when the controller connects
    if (this.hasInputTarget) {
      this.inputTarget.focus()
      this.inputTarget.select()
    }
  }

  cancelModal(event) {
    // Handle escape key to close modal
    if (event && event.key === "Escape") {
      event.preventDefault()
      // Find the modal controller and close it
      const modalElement = this.element.closest('[data-controller="modal"]')
      if (modalElement) {
        const modalController = this.application.getControllerForElementAndIdentifier(modalElement, "modal")
        if (modalController) {
          modalController.close()
        }
      }
    }
  }

  cancelByEscape(event) {
    // Handle escape key to cancel editing (for inline edit forms)
    if (event && event.key === "Escape") {
      event.preventDefault()
      // Check if this is the new folder form
      const turboFrame = this.element.closest("#new_folder")
      if (turboFrame) {
        // Clear the new folder form
        turboFrame.innerHTML = ""
      } else {
        // Find the cancel link and click it (for edit form)
        const cancelLink = this.element.querySelector("a[href*='folders']")
        if (cancelLink) {
          cancelLink.click()
        }
      }
    }
  }

  cancelNew(event) {
    // Clear the new folder form by clearing the turbo frame
    event.preventDefault()
    const turboFrame = document.getElementById("new_folder")
    if (turboFrame) {
      turboFrame.innerHTML = ""
    }
  }
}
