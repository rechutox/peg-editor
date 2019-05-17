<template>
  <div class="Tabs">
    <div class="buttons"></div>
    <div class="blocks"></div>
  </div>
</template>

<script>
export default {
  props: ["start", "tabs"],
  data: () => ({
    current: this.start
  })
};
</script>

<style lang="scss">
.Tabs {
  flex: 1 1;
  display: flex;
  flex-direction: column;

  .buttons {
    display: flex;
    flex-direction: row;
  }

  .blocks {
    flex: 1 1;
  }
}
</style>
