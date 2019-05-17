<template>
  <div class="TestsPanel">
    <div class="TestsPanel__tests">
      <WorkspaceTest
        v-for="t in tests"
        :key="t.id"
        :test="t.test"
        :testMethod="testMethod"
        @close="() => removeTest(t.id)"
        @input="test => updateTest(t.id, test)"
      />
    </div>

    <div class="TestsPanel__actions">
      <button @click="addTest">Add Test</button>
    </div>
  </div>
</template>

<script>
import Chance from "chance";
import WorkspaceTest from "./WorkspaceTest";

export default {
  components: { WorkspaceTest },

  props: ["tests", "testMethod"],

  model: {
    prop: "tests",
    event: "change"
  },

  created() {
    this.chance = new Chance();
  },

  methods: {
    addTest() {
      this.notifyChanges([...this.tests, { id: this.chance.guid(), test: "" }]);
    },
    removeTest(id) {
      this.notifyChanges(this.tests.filter(i => i.id !== id));
    },
    updateTest(id, test) {
      const tests = this.tests.map(t => {
        if (id === t.id) return { id, test };
        return t;
      });
      this.notifyChanges(tests);
    },
    notifyChanges(v) {
      this.$emit("change", v);
    }
  }
};
</script>

<style lang="scss">
@import "./variables.scss";

.TestsPanel {
  flex: 1 1;
  display: flex;
  flex-direction: column;
  border-left: 1px solid $gray-4;
  background-color: $gray-0;
  height: 100%;
}

.TestsPanel__tests {
  flex: 1 0 0;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  overflow-x: hidden;
}

.TestsPanel__actions {
  display: flex;
  flex-direction: row;
  justify-content: stretch;
  align-items: stretch;
  border-top: 1px solid $gray-4;
  justify-content: stretch;

  & > button {
    flex: 1 1;
    background-color: $gray-2;
    color: $white-0;
    border: 0;
    padding: 8px 15px;

    &:focus {
      background-color: $gray-3;
      color: $white-1;
    }

    &:hover {
      background-color: $gray-4;
      color: $white-2;
    }

    &:active {
      background-color: $gray-1;
      color: $white-0;
    }
  }
}
</style>
