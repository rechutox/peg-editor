<template>
  <div class="CodeEditor">
    <textarea ref="textarea"></textarea>
  </div>
</template>

<script>
import CodeMirror from "codemirror";
import "codemirror/mode/pegjs/pegjs";

export default {
  props: {
    value: {
      type: String,
      default: "hola"
    }
  },

  model: {
    prop: "value",
    event: "input"
  },

  mounted() {
    this.editor = CodeMirror.fromTextArea(this.$refs.textarea, {
      mode: "pegjs",
      theme: "monokai",
      lineNumbers: true,
      inputStyle: "contenteditable",
      autoFocus: true
    });

    this.editor.on("change", editor => this.input(editor.getValue()));

    this.editor.setValue(this.value);
  },

  methods: {
    input(text) {
      this.$emit("input", text);
    }
  },

  watch: {
    value(newValue) {
      // Only set editor text if prop is changed outside input()
      if (this.editor.getValue() != newValue) this.editor.setValue(newValue);
    }
  }
};
</script>

<style lang="scss">
@import "codemirror/lib/codemirror.css";
@import "codemirror/theme/monokai.css";

.CodeEditor {
  flex: 1 1;

  & > .CodeMirror {
    height: 100%;
  }
}
</style>
