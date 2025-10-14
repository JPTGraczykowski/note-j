import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tag-editor"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    // Focus the input when the controller connects
    if (this.hasInputTarget) {
      this.inputTarget.focus()
      this.inputTarget.select()
    }
  }

  cancel(event) {
    // Handle escape key to cancel editing
    if (event && event.key === "Escape") {
      event.preventDefault()
      // Find the cancel link and click it
      const cancelLink = this.element.querySelector("a[href*='tags']")
      if (cancelLink) {
        cancelLink.click()
      }
    }
  }
}
