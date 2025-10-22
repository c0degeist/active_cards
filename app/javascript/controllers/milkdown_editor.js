import { Controller } from "@hotwired/stimulus"
import { Crepe } from "@milkdown/crepe"
import "@milkdown/crepe/theme/common/style.css"

// available themes: frame, classic, nord, frame-dark, classic-dark, nord-dark
import "@milkdown/crepe/theme/frame-dark.css"

export default class extends Controller {
  static values = {
    defaultValue: String, // optional: if you want to set a default value
    readOnly: Boolean
  }

  static targets = ['textField']

  connect() {
    const initialMarkdown = this.defaultValueValue || this.textFieldTarget.value
    this.textFieldTarget.style.display = "none"

    this.crepe = new Crepe({
      features: {
        [Crepe.Feature.BlockEdit]: false,
        [Crepe.Feature.Toolbar]: false,
      },
      root: this.element,
      defaultValue: initialMarkdown
      // optional: weitere Optionen
    })

    this.crepe.create().then(() => {
      console.log("Milkdown editor created")
    })

    this.crepe.setReadonly(this.readOnlyValue)

    this.crepe.on(listener => {
      listener.markdownUpdated(newValue => {
        this.textFieldTarget.value = this.crepe.getMarkdown()
      })
    })
  }

  disconnect() {
    if (this.crepe) {
      this.crepe.destroy()
    }
  }
}
