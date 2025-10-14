import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="folder-tree"
export default class extends Controller {
  static targets = ["folder", "children", "toggle"]

  connect() {
    // Initialize collapsed state from localStorage
    this.loadCollapsedState()

    // Listen for folder creation events
    this.boundHandleFolderCreated = this.handleFolderCreated.bind(this)
    document.addEventListener('folder:created', this.boundHandleFolderCreated)
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener('folder:created', this.boundHandleFolderCreated)
  }

  toggle(event) {
    event.preventDefault()
    const folderId = event.currentTarget.dataset.folderId
    const childrenElement = event.currentTarget.closest("[data-folder-tree-target='folder']")
      .querySelector("[data-folder-tree-target='children']")
    const toggleIcon = event.currentTarget.querySelector("svg")

    if (childrenElement) {
      const isCollapsed = childrenElement.classList.contains("hidden")

      if (isCollapsed) {
        // Expand
        childrenElement.classList.remove("hidden")
        this.rotateIcon(toggleIcon, true)
        this.saveCollapsedState(folderId, false)
      } else {
        // Collapse
        childrenElement.classList.add("hidden")
        this.rotateIcon(toggleIcon, false)
        this.saveCollapsedState(folderId, true)
      }
    }
  }

  rotateIcon(icon, expanded) {
    if (expanded) {
      icon.style.transform = "rotate(90deg)"
    } else {
      icon.style.transform = "rotate(0deg)"
    }
  }

  loadCollapsedState() {
    const state = this.getCollapsedState()

    this.folderTargets.forEach(folder => {
      const folderId = folder.dataset.folderId
      const childrenElement = folder.querySelector("[data-folder-tree-target='children']")
      const toggleButton = folder.querySelector("[data-folder-tree-target='toggle']")
      const toggleIcon = toggleButton?.querySelector("svg")

      if (state[folderId] && childrenElement) {
        childrenElement.classList.add("hidden")
        if (toggleIcon) {
          this.rotateIcon(toggleIcon, false)
        }
      } else if (childrenElement && toggleIcon) {
        this.rotateIcon(toggleIcon, true)
      }
    })
  }

  getCollapsedState() {
    const state = localStorage.getItem("folderTreeCollapsedState")
    return state ? JSON.parse(state) : {}
  }

  saveCollapsedState(folderId, isCollapsed) {
    const state = this.getCollapsedState()
    if (isCollapsed) {
      state[folderId] = true
    } else {
      delete state[folderId]
    }
    localStorage.setItem("folderTreeCollapsedState", JSON.stringify(state))
  }

  handleFolderCreated(event) {
    const { parentIds } = event.detail

    // Expand all parent folders to show the newly created folder
    parentIds.forEach(parentId => {
      this.expandFolder(parentId)
    })
  }

  expandFolder(folderId) {
    // Find the folder element
    const folderElement = this.folderTargets.find(folder =>
      folder.dataset.folderId === String(folderId)
    )

    if (!folderElement) return

    // Find the children container and toggle button
    const childrenElement = folderElement.querySelector("[data-folder-tree-target='children']")
    const toggleButton = folderElement.querySelector("[data-folder-tree-target='toggle']")
    const toggleIcon = toggleButton?.querySelector("svg")

    if (childrenElement && childrenElement.classList.contains("hidden")) {
      // Expand the folder
      childrenElement.classList.remove("hidden")
      if (toggleIcon) {
        this.rotateIcon(toggleIcon, true)
      }
      this.saveCollapsedState(folderId, false)
    }
  }
}
