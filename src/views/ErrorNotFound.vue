<template>
    <div class="erroe-page q-pa-md flex flex-center">
      <div>
        <div class="h1">
          404
        </div>
  
        <div class="h2">
          Страница не найдена
        </div>
  
        <RouterLink to="/">Home</RouterLink>
      </div>
    </div>
  </template>
  
  <script setup>
  </script>
  
  <style>
  .erroe-page {
    color: black;
    font-size: 48px;
    text-align: center;
  }
  .fullscreen {
    width: 100%;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .text-center {
    text-align: center;
  }
  
  .flex {
    display: flex;
  }
  
  .flex-center {
    align-items: center;
    justify-content: center;
  }
  
  .q-pa-md {
    padding: 1rem;
  }
  
  .q-mt-lg {
    margin-top: 2rem;
  }
  </style>
  