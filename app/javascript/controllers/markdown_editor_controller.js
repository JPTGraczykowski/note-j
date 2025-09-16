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

  updatePreview() {
    const content = this.textareaTarget.value

    if (!content.trim()) {
      this.previewTarget.innerHTML = '<p class="text-neutral-500 italic">Start writing to see preview...</p>'
      return
    }

    // Convert markdown to HTML (basic implementation)
    const html = this.markdownToHtml(content)
    this.previewTarget.innerHTML = html
  }

  markdownToHtml(markdown) {
    let html = markdown

    // Headers
    html = html.replace(/^### (.*$)/gim, '<h3 class="text-lg font-semibold text-neutral-900 mt-4 mb-2">$1</h3>')
    html = html.replace(/^## (.*$)/gim, '<h2 class="text-xl font-semibold text-neutral-900 mt-6 mb-3">$1</h2>')
    html = html.replace(/^# (.*$)/gim, '<h1 class="text-2xl font-bold text-neutral-900 mt-8 mb-4">$1</h1>')

    // Bold and Italic
    html = html.replace(/\*\*\*(.*?)\*\*\*/g, '<strong><em>$1</em></strong>')
    html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    html = html.replace(/\*(.*?)\*/g, '<em>$1</em>')
    html = html.replace(/\_\_\_(.*?)\_\_\_/g, '<strong><em>$1</em></strong>')
    html = html.replace(/\_\_(.*?)\_\_/g, '<strong>$1</strong>')
    html = html.replace(/\_(.*?)\_/g, '<em>$1</em>')

    // Code
    html = html.replace(/```([\s\S]*?)```/g, '<pre class="bg-neutral-100 rounded-md p-3 my-3 overflow-x-auto"><code class="text-sm font-mono">$1</code></pre>')
    html = html.replace(/`(.*?)`/g, '<code class="bg-neutral-100 px-1 py-0.5 rounded text-sm font-mono">$1</code>')

    // Links
    html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" class="text-primary-600 hover:text-primary-800 underline">$1</a>')

    // Lists
    html = html.replace(/^\* (.*$)/gim, '<li class="ml-4">$1</li>')
    html = html.replace(/^- (.*$)/gim, '<li class="ml-4">$1</li>')
    html = html.replace(/^\+ (.*$)/gim, '<li class="ml-4">$1</li>')

    // Wrap consecutive list items in ul
    html = html.replace(/(<li.*<\/li>[\s]*)+/g, function(match) {
      return '<ul class="list-disc list-inside space-y-1 my-3">' + match + '</ul>'
    })

    // Line breaks
    html = html.replace(/\n\n/g, '</p><p class="mb-3">')
    html = html.replace(/\n/g, '<br>')

    // Wrap in paragraphs if not already wrapped
    if (!html.startsWith('<')) {
      html = '<p class="mb-3">' + html + '</p>'
    }

    return html
  }
}
