import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropZone", "preview"]

  connect() {
    this.setupInput()
  }

  setupInput() {
    this.inputTarget.addEventListener('change', (e) => {
      this.handleFiles(e.target.files)
    })
  }

  clickInput() {
    this.inputTarget.click()
  }

  dragOver(event) {
    event.preventDefault()
    event.stopPropagation()
    this.dropZoneTarget.classList.add('border-primary-400', 'bg-primary-50')
  }

  dragLeave(event) {
    event.preventDefault()
    event.stopPropagation()
    this.dropZoneTarget.classList.remove('border-primary-400', 'bg-primary-50')
  }

  drop(event) {
    event.preventDefault()
    event.stopPropagation()
    this.dropZoneTarget.classList.remove('border-primary-400', 'bg-primary-50')

    const files = event.dataTransfer.files
    this.handleFiles(files)
  }

  handleFiles(files) {
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp']
    const maxSize = 5 * 1024 * 1024 // 5MB
    const validFiles = []

    Array.from(files).forEach(file => {
      if (!allowedTypes.includes(file.type)) {
        this.showError(`${file.name} is not a valid image format. Please use PNG, JPG, GIF, or WebP.`)
        return
      }

      if (file.size > maxSize) {
        this.showError(`${file.name} is too large. Please use images smaller than 5MB.`)
        return
      }

      validFiles.push(file)
    })

    if (validFiles.length > 0) {
      this.showPreviews(validFiles)
      this.updateFileInput(validFiles)
    }
  }

  showPreviews(files) {
    const previewContainer = this.previewTarget.querySelector('.grid')

    // Show preview area
    this.previewTarget.classList.remove('hidden')

    files.forEach(file => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const previewItem = this.createPreviewItem(file, e.target.result)
        previewContainer.appendChild(previewItem)
      }
      reader.readAsDataURL(file)
    })
  }

  createPreviewItem(file, src) {
    const div = document.createElement('div')
    div.className = 'relative group'

    div.innerHTML = `
      <img src="${src}" alt="${file.name}" class="w-full h-20 object-cover rounded-md border border-neutral-200">
      <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-10 rounded-md transition-opacity"></div>
      <button type="button"
              class="absolute top-1 right-1 p-1 bg-error-600 text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity hover:bg-error-700"
              data-action="click->image-upload#removePreview">
        <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
        </svg>
      </button>
      <div class="absolute bottom-1 left-1 right-1">
        <div class="bg-black bg-opacity-75 text-white text-xs px-2 py-1 rounded truncate">
          ${file.name}
        </div>
      </div>
    `

    return div
  }

  removePreview(event) {
    const previewItem = event.target.closest('.relative')
    previewItem.remove()

    // Hide preview area if no more previews
    const previewContainer = this.previewTarget.querySelector('.grid')
    if (previewContainer.children.length === 0) {
      this.previewTarget.classList.add('hidden')
    }

    // Update file input (this is tricky with file inputs, so we'll reset it)
    // In a real app, you'd want to track this more carefully
    this.inputTarget.value = ''
  }

  updateFileInput(files) {
    // Create a new DataTransfer object to update the file input
    const dt = new DataTransfer()
    files.forEach(file => dt.items.add(file))
    this.inputTarget.files = dt.files
  }

  showError(message) {
    // Create a temporary error message
    const errorDiv = document.createElement('div')
    errorDiv.className = 'mt-2 p-2 bg-error-50 border border-error-200 rounded-md text-sm text-error-700'
    errorDiv.textContent = message

    this.dropZoneTarget.appendChild(errorDiv)

    // Remove error after 5 seconds
    setTimeout(() => {
      if (errorDiv.parentNode) {
        errorDiv.remove()
      }
    }, 5000)
  }
}
