import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="tom-select"
export default class extends Controller {
  connect() {
    console.log("TomSelect controller connected")
    // Initialize TomSelect on the select element
    this.tomSelect = new TomSelect(this.element, {
      plugins: ['remove_button'],
      maxItems: null, // Allow unlimited selections
      hideSelected: true, // Hide selected items from dropdown
      closeAfterSelect: false, // Keep dropdown open for multiple selections
      placeholder: 'Select tags...',
      // Styling options
      render: {
        no_results: function(data, escape) {
          return '<div class="no-results">No tags found</div>';
        }
      }
    })
  }

  disconnect() {
    // Clean up TomSelect instance when controller disconnects
    if (this.tomSelect) {
      this.tomSelect.destroy()
    }
  }
}
