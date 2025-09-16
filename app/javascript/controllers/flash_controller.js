import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static values = {
    duration: { type: Number, default: 5000 } // 5 seconds default
  }

  connect() {
    // Add entrance animation
    this.element.classList.add("animate-slide-in")

    // Set up auto-dismiss timer
    this.timeoutId = setTimeout(() => {
      this.dismiss()
    }, this.durationValue)
  }

  disconnect() {
    // Clean up timer if component is disconnected before timeout
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  dismiss() {
    // Add exit animation
    this.element.classList.add("animate-slide-out")

    // Remove element after animation completes
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 300) // Match animation duration
  }

  // Allow manual dismissal by clicking
  close() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
    this.dismiss()
  }
}
