<template>
  <router-view />
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: "Arial";
  font-size: 14px;
}

body {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: #d3d3d3;
}

.input {
  width: 90%;
  padding: 5px;
  color: #000;
  border: 0;
  background: none;
  border-bottom: 2px solid #000;
  outline: 0;
  font-size: 16px;
  transition: all 0.5s ease-in-out;
}

.label {
  position: absolute;
  margin-left: 5%;
  bottom: 5px;
  left: 0;
  color: #000;
  cursor: text;
  transition: all 0.5s ease-in-out;
}

.input:focus,
.input:valid {
  border-bottom: 2px solid #5453a0;
}

.input:focus~label,
.input:valid~label {
  transform: translateY(-24px);
  font-size: 12px;
  color: #5453a0;
  background: none;
}

button {
  padding: 10px;
  color: #fff;
  background: #5453a0;
  border-radius: 40px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  padding: 20px;
}

button:hover {
  filter: brightness(85%);
  transition: 0.3s;
}

h1 {
  font-size: 30px;
  margin-bottom: 20px;
  text-align: center;
  width: 100%;
}

a {
  color: #5453a0;
  font-size: 12px;
}
</style>