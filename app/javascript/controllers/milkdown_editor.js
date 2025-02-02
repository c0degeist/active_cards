import { Controller } from "@hotwired/stimulus"
import { Crepe } from "@milkdown/crepe"
import "@milkdown/crepe/theme/common/style.css"

// available themes: frame, classic, nord, frame-dark, classic-dark, nord-dark
import "@milkdown/crepe/theme/frame-dark.css"

export default class extends Controller {
  static values = {
    defaultValue: String // optional: if you want to set a default value
  }

  connect() {
    // Den anfänglichen Wert aus dem <textarea> lesen
    // Falls kein Data-Value gesetzt ist, nehmen wir einfach den Inhalt des Textareas
    // NOTE: Vmtl wollen wir den Inhalt der TextArea priorisieren.
    const initialMarkdown = this.defaultValueValue || this.element.value

    this.element.style.display = "none"
    this.editorContainer = document.createElement("div")
    this.element.insertAdjacentElement("afterend", this.editorContainer)

    this.crepe = new Crepe({
      features: {
        [Crepe.Feature.BlockEdit]: false,
        [Crepe.Feature.Toolbar]: false,
      },
      root: this.editorContainer,
      defaultValue: initialMarkdown
      // optional: weitere Optionen
    })

    this.crepe.create().then(() => {
      console.log("Milkdown editor created")
    })

    this.crepe.on(listener => {
      listener.markdownUpdated(newValue => {
        this.element.value = this.crepe.getMarkdown()
      })
    })
  }

  disconnect() {
    if (this.crepe) {
      this.crepe.destroy()
    }
  }
}
