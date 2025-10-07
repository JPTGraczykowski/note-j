import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["writeTab", "previewTab", "writePane", "preview", "textarea"]

  connect() {
    this.showWrite()
  }

  showWrite() {
    // Update tab styles
    this.writeTabTarget.classList.remove("bg-neutral-100", "text-neutral-700")
    this.writeTabTarget.classList.add("bg-white", "text-neutral-900", "border-b-2", "border-primary-500")

    this.previewTabTarget.classList.remove("bg-white", "text-neutral-900", "border-b-2", "border-primary-500")
    this.previewTabTarget.classList.add("bg-neutral-100", "text-neutral-700")

    // Show/hide panes
    this.writePaneTarget.classList.remove("hidden")
    this.previewTarget.classList.add("hidden")

    // Focus textarea
    this.textareaTarget.focus()
  }

  showPreview() {
    // Update tab styles
    this.previewTabTarget.classList.remove("bg-neutral-100", "text-neutral-700")
    this.previewTabTarget.classList.add("bg-white", "text-neutral-900", "border-b-2", "border-primary-500")

    this.writeTabTarget.classList.remove("bg-white", "text-neutral-900", "border-b-2", "border-primary-500")
    this.writeTabTarget.classList.add("bg-neutral-100", "text-neutral-700")

    // Show/hide panes
    this.writePaneTarget.classList.add("hidden")
    this.previewTarget.classList.remove("hidden")

    // Update preview content
    this.updatePreview()
  }

  async updatePreview() {
    const content = this.textareaTarget.value

    if (!content.trim()) {
      this.previewTarget.innerHTML = '<p class="text-neutral-500 italic">Start writing to see preview...</p>'
      return
    }

    try {
      const response = await fetch('/notes/preview_markdown', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ content })
      })

      if (!response.ok) {
        throw new Error('Failed to render markdown')
      }

      const data = await response.json()
      this.previewTarget.innerHTML = data.html
    } catch (error) {
      console.error('Error rendering markdown:', error)
      this.previewTarget.innerHTML = '<p class="text-error-600">Failed to render preview</p>'
    }
  }
}
