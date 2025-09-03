import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mobile-nav"
export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.menuTarget.classList.add("animate-slide-down")

    // Lock body scroll when mobile menu is open
    document.body.style.overflow = "hidden"
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.menuTarget.classList.remove("animate-slide-down")

    // Restore body scroll
    document.body.style.overflow = ""
  }

  // Close menu when a navigation link is clicked
  navigateAndClose() {
    this.close()
  }
}
