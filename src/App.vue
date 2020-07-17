<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Hind+Siliguri&display=swap');
#app {
  font-family: 'Hind Siliguri', sans-serif;
  /* font-family: Avenir, Helvetica, Arial, sans-serif; */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}

input {
  font-family: 'Hind Siliguri', sans-serif;
}

button:hover {
  cursor: pointer;
  text-decoration: underline;
}
  button {
      padding: 1%;
      margin: 0.5%;
      color: #001c39;
      background-color: white;
      border: 4px solid #001c39;
      text-transform: uppercase;
  }

button {
  font-family: 'Hind Siliguri', sans-serif;
}

h2 {
  font-family: 'Montserrat', sans-serif;
}

h3 {
  font-family: 'Montserrat', sans-serif;
}

h1 {
  font-family: 'Montserrat', sans-serif;
}
</style>
