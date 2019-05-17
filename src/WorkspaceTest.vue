<template>
  <div class="WorkspaceTest" :class="{error: hasError, success: hasSuccess}">
    <div class="wrapper">
      <div class="main">
        <textarea class="code" spellcheck="false" :value="test" @input="input"></textarea>
        <div class="actions">
          <button class="close" @click="close">X</button>
          <button class="move">::</button>
        </div>
      </div>
      <div class="error">{{error}}</div>
      <div class="result">{{result}}</div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["test", "testMethod"],

  data: function() {
    return {
      error: "",
      result: ""
    };
  },

  created() {
    this.doTest();
  },

  methods: {
    close() {
      this.$emit("close");
    },

    input(e) {
      this.doTest();
      this.$emit("input", e.target.value);
    },

    doTest() {
      if (this.testMethod == null) {
        this.result = "";
        this.error = "";
        return;
      }
      try {
        const result = this.testMethod(this.test);
        this.result = JSON.stringify(result, null, 2);
        this.error = "";
      } catch (error) {
        const location =
          error.location &&
          `[${error.location.start.line}:${error.location.start.column}] `;
        this.error = location + error;
        this.result = "";
      }
    }
  },

  computed: {
    hasError() {
      return this.error !== "";
    },
    hasSuccess() {
      return this.result !== "";
    }
  },

  watch: {
    test() {
      this.doTest();
    },
    testMethod(newVal, oldVal) {
      this.doTest();
    }
  }
};
</script>

<style lang="scss">
@import "./variables.scss";

.WorkspaceTest {
  background-color: $gray-1;
  border-bottom: 1px solid $gray-4;

  & > .wrapper {
    display: flex;
    flex-direction: column;
    border-left: 10px solid gray;

    & > .main {
      display: flex;
      flex-direction: row;
      padding: 5px 0;

      & > .code {
        flex: 1 1;
        font-family: monospace;
        white-space: pre-wrap;
        word-break: break-word;
        background-color: $gray-0;
        color: $gray-10;
        border: 0;
        margin: 0 5px;
        padding: 5px;
      }

      & > .actions {
        display: flex;
        flex-direction: column;
        flex-wrap: nowrap;

        & > button {
          @include tool-button;
        }
      }
    }

    & > .error {
      padding: 5px;
      background-color: $error-background-color;

      &:empty {
        display: none;
      }
    }

    & > .result {
      padding: 5px;
      font-family: monospace;

      &:empty {
        display: none;
      }
    }
  }

  &.error {
    & .wrapper {
      color: $error-color;
      border-left-color: $error-background-color;
    }
  }

  &.success {
    & .wrapper {
      color: $success-color;
      border-left-color: $success-color;
    }
  }
}
</style>
