
<template>
  <div class="App">
    <header class="App__header">
      <div class="hbox">
        <img class="App__header__logo" src="icon.svg" alt="logo" height="130px">
        <div class="App__header__title">PEG EDITOR</div>
      </div>
      <div class="App__header__tabs">
        <template v-for="(ws, key) in workspaces">
          <div
            class="App__header__tabs__tab"
            :key="key"
            :class="{active: (active === key)}"
            @click="() => setActive(key)"
          >
            <span>{{key}}</span>
            <button @click.stop="() => closeTab(key)">x</button>
          </div>
        </template>
        <button class="App__header__tabs__tab newButtonTab" @click="newWorkspace">+</button>
      </div>
    </header>

    <main class="App__main" v-if="isWorkSpaceActive">
      <div class="App__main__left">
        <CodeEditor v-model="grammar" @input="generateParser"></CodeEditor>
        <div class="App__grammar-error">{{generateError}}</div>
      </div>

      <div class="App__main__right">
        <TestsPanel v-model="tests" :testMethod="testMethod"></TestsPanel>
      </div>
    </main>
  </div>
</template>

<script>
import pegjs from "pegjs";
import CodeEditor from "./CodeEditor";
import TestsPanel from "./TestsPanel";
import defaultGrammar from "./defaultGrammar.pegjs";
import defaultTests from "./defaultTests.json";

export default {
  name: "App",

  components: { CodeEditor, TestsPanel },

  data: function() {
    return {
      active: "",
      workspaces: {},
      parser: null,
      generateError: ""
    };
  },

  computed: {
    isWorkSpaceActive() {
      return this.active in this.workspaces;
    },
    grammar: {
      get() {
        if (this.active in this.workspaces)
          return this.workspaces[this.active].grammar;
        return "";
      },
      set(value) {
        const ws = this.workspaces[this.active];
        this.$set(this.workspaces, this.active, { ...ws, grammar: value });
        this.saveSession();
      }
    },
    tests: {
      get() {
        if (this.active in this.workspaces)
          return this.workspaces[this.active].tests;
        return [];
      },
      set(value) {
        const ws = this.workspaces[this.active];
        this.$set(this.workspaces, this.active, { ...ws, tests: value });
        this.saveSession();
      }
    },
    testMethod() {
      return this.parser && this.parser.parse;
    }
  },

  created() {
    this.loadSession();
  },

  methods: {
    setActive(key) {
      this.active = key;
    },

    newWorkspace() {
      const i = Object.keys(this.workspaces).length;
      const key = `grammar-${i}`;
      this.$set(this.workspaces, key, {
        grammar: defaultGrammar,
        tests: defaultTests
      });
      this.active = key;
      this.generateParser();
    },

    closeTab(key) {
      this.$delete(this.workspaces, key);
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

    saveSession() {
      localStorage.setItem("WORKSPACES", JSON.stringify(this.workspaces));
      localStorage.setItem("ACTIVE_TAB", this.active);
    },

    loadSession() {
      const data = localStorage.getItem("WORKSPACES");
      this.workspaces = data != null ? JSON.parse(data) : {};
      this.active = localStorage.getItem("ACTIVE_TAB");
    }
  },

  watch: {
    workspaces(newV, oldV) {
      this.saveSession();
    },
    active(newV, oldV) {
      this.saveSession();
    }
  }
};
</script>

<style lang="scss">
@import "./variables.scss";
@import "splitpanes/dist/splitpanes.css";

html {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
    Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
  font-size: 1.1rem;
}

body {
  margin: 0;
}

.hbox {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.App {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  background-color: $gray-0;
  color: $gray-10;
}

.App__header {
  display: flex;
  flex-direction: column;
  background-color: $gray-2;
  color: $white-0;
  border-bottom: 3px solid $gray-5;
}

.App__header__logo {
  height: 30px;
  margin: 0 10px;
  padding: 10px 0;
}

.App__header__title {
  margin: 4px 0;
  text-shadow: 0px 0px 1px black;
}

.App__header__tabs {
  display: flex;
  flex-direction: rows;
  align-items: flex-end;
  padding: 0 10px;
}

.App__header__tabs__tab {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  background-color: $gray-3;
  border: 1px solid transparent;
  color: $white-0;
  border-bottom: 0;
  border-radius: 3px 3px 0 0;
  padding: 5px 8px 5px 15px;
  line-height: 1;
  font-size: 0.8em;

  &:hover {
    background-color: $gray-4;
    color: $white-1;
  }

  &.active {
    background-color: $gray-5;
    color: $white-2;
    // border-color: $gray-1;
  }

  & + & {
    margin-left: 2px;
  }

  button {
    display: block;
    margin: 0;
    border-radius: 50%;
    border: 0;
    font-size: 1em;
    line-height: 14px;
    width: 14px;
    height: 14px;
    font-family: monospace;
    margin-left: 10px;
    text-align: center;
    padding: 0;
    background-color: transparent;
    color: $white-0;

    &:hover {
      background-color: $gray-3;
      color: $white-1;
    }
  }

  &.newButtonTab {
    padding: 5px 15px;
  }
}

.App__main {
  flex: 1 1;
  display: flex;
  flex-direction: row;
}

.App__main__left {
  flex: 1 1;
  display: flex;
  flex-direction: column;
}

.App__main__right {
  flex: 1 1;
  display: flex;
  flex-direction: column;
}

.App__grammar-error {
  background-color: $error-background-color;
  color: $error-color;
  padding: 10px;

  &:empty {
    display: none;
  }
}
</style>
