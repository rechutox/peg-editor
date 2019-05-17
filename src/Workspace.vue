<template>
  <div class="Workspace">
    <Splitpanes watch-slots>
      <div class="Workspace__main" splitpanes-size="70">
        <CodeEditor v-model="grammar" @input="input"></CodeEditor>
        <div class="Workspace__main__error">{{generateError}}</div>
      </div>

      <div class="Workspace__tests-panel" splitpanes-size="30"></div>
    </Splitpanes>
  </div>
</template>

<script>
import pegjs from "pegjs";
import Splitpanes from "splitpanes";
import CodeEditor from "./CodeEditor";
import defaultGrammar from "./defaultGrammar.pegjs";
import defaultTests from "./defaultTests.json";
import TestsPanel from "./TestsPanel";

export default {
  components: { Splitpanes, TestsPanel, CodeEditor },

  data: () => ({
    tests: defaultTests,
    testNextID: 0,
    grammar: defaultGrammar,
    generateError: "",
    parser: null
  }),

  created() {
    this.generateParser();
  },

  methods: {
    addTest() {
      this.tests.push({
        id: this.testNextID++,
        value: ""
      });
    },
    removeTest(id) {
      this.tests = this.tests.filter(i => i.id != id);
    },
    updateTest(id, value) {
      this.tests = this.tests.map(t => {
        if (t.id === id) t.value = value;
        return t;
      });
      this.$emit("changed", this.serialize());
    },
    input(value) {
      this.grammar = value;
      this.generateParser();
      this.$emit("changed", this.serialize());
    },
    generateParser() {
      try {
        this.parser = pegjs.generate(this.grammar);
        this.generateError = "";
      } catch (err) {
        const location = err.location
          ? `[${err.location.start.line}:${err.location.start.column}] `
          : "";
        const msg = location + err;
        this.generateError = msg;
        this.parser = null;
      }
    },
    serialize() {
      return {
        grammar: this.grammar,
        tests: this.tests
      };
    }
  },

  computed: {
    parseMethod() {
      return this.parser ? this.parser.parse : null;
    }
  }
};
</script>

<style lang="scss">
@import "splitpanes/dist/splitpanes.css";
@import "./variables.scss";

.Workspace {
  flex: 1 1;
  display: flex;
  flex-direction: row;
}

.Workspace__main {
  flex: 1 0;
  display: flex;
  flex-direction: column;
  height: 100%;
}

.Workspace__main__code {
  @include code;
  flex: 1 1 0;
  font-family: monospace;
  background-color: $gray-0;
}

.Workspace__main__error {
  background-color: $error-background-color;
  color: $error-color;
  padding: 10px;

  &:empty {
    display: none;
  }
}

.Workspace__tests-panel {
  flex: 1 1;
  display: flex;
  flex-direction: column;
  border-left: 1px solid $gray-4;
  background-color: $gray-0;
  height: 100%;
}

.Workspace__tests-panel__tests {
  flex: 1 0 0;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  overflow-x: hidden;
}

.Workspace__tests-panel__actions {
  display: flex;
  flex-direction: row;
  justify-content: stretch;
  align-items: stretch;
  border-top: 1px solid $gray-4;
  justify-content: stretch;

  & > button {
    flex: 1 1;
  }
}

.splitpanes {
  flex: 1 1;

  &.splitpanes--vertical > .splitpanes__splitter {
    min-width: 4px;
    background: $gray-4;
  }

  &.splitpanes--horizontal > .splitpanes__splitter {
    min-height: 4px;
    background: $gray-4;
  }
}

.splitpanes__pane {
  height: 100%;
}
</style>
