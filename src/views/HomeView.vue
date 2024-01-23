<script setup>
import { onMounted, ref } from 'vue';
import TheWelcome from '../components/TheWelcome.vue'

const todoList = ref(null)

const initMethod = async () => {

  const response = await fetch('https://jsonplaceholder.typicode.com/todos');
  todoList.value = await response.json();

}

onMounted(async () => {
  await initMethod()
})
</script>

<template>
  <main>
    <TheWelcome />
  </main>
</template>
