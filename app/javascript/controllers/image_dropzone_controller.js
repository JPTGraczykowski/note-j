import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropzone", "fileInput", "previewContainer", "hiddenInput"]
  static values = { existingImages: Array }

  connect() {
    this.selectedFiles = []
    this.displayExistingImages()
  }

  dragover(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("border-primary-500", "bg-primary-50")
  }

  dragleave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-primary-500", "bg-primary-50")
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-primary-500", "bg-primary-50")

    const files = Array.from(event.dataTransfer.files).filter(file =>
      file.type.startsWith('image/')
    )

    if (files.length > 0) {
      this.addFiles(files)
    }
  }

  fileInputChange(event) {
    const files = Array.from(event.target.files)
    this.addFiles(files)
  }

  addFiles(files) {
    // Add new files to the selected files array
    this.selectedFiles = [...this.selectedFiles, ...files]
    this.updateFileInput()
    this.updatePreview()
  }

  updateFileInput() {
    // Create a new FileList with all selected files
    const dataTransfer = new DataTransfer()
    this.selectedFiles.forEach(file => {
      dataTransfer.items.add(file)
    })
    this.fileInputTarget.files = dataTransfer.files
  }

  updatePreview() {
    // Clear current preview
    this.previewContainerTarget.innerHTML = ""

    // Show existing images first
    this.displayExistingImages()

    // Show newly selected images
    this.selectedFiles.forEach((file, index) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        this.createImagePreview(e.target.result, file.name, () => {
          this.removeFile(index)
        }, false)
      }
      reader.readAsDataURL(file)
    })
  }

  displayExistingImages() {
    this.existingImagesValue.forEach((imageData, index) => {
      this.createImagePreview(imageData.url, imageData.name, () => {
        this.removeExistingImage(imageData.id)
      }, true)
    })
  }

  createImagePreview(src, filename, onRemove, isExisting = false) {
    const previewDiv = document.createElement("div")
    previewDiv.className = "relative group"

    previewDiv.innerHTML = `
      <div class="w-24 h-24 bg-neutral-100 rounded-lg overflow-hidden border border-neutral-200">
        <img src="${src}" alt="${filename}" class="w-full h-full object-cover">
      </div>
      <button type="button"
              class="absolute -top-2 -right-2 w-6 h-6 bg-red-500 text-white rounded-full flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition-opacity hover:bg-red-600"
              title="Remove image">
        ×
      </button>
      <p class="text-xs text-neutral-600 mt-1 truncate max-w-24" title="${filename}">${filename}</p>
    `

    const removeButton = previewDiv.querySelector("button")
    removeButton.addEventListener("click", onRemove)

    this.previewContainerTarget.appendChild(previewDiv)
  }

  removeFile(index) {
    this.selectedFiles.splice(index, 1)
    this.updateFileInput()
    this.updatePreview()
  }

  removeExistingImage(imageId) {
    // Create a hidden input to mark this image for removal
    const hiddenInput = document.createElement("input")
    hiddenInput.type = "hidden"
    hiddenInput.name = "note[remove_images][]"
    hiddenInput.value = imageId
    this.element.appendChild(hiddenInput)

    // Remove from existing images array by ID
    this.existingImagesValue = this.existingImagesValue.filter(img => img.id !== imageId)
    this.updatePreview()
  }

  openFileDialog() {
    this.fileInputTarget.click()
  }
}
