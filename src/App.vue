<template>
  <router-view/>
</template>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: "Arial";
    font-size: 14px;
}

body{
  width: 100vw;
  height: 100vh;
  background-image: url("assets/background.jpg");
  background-repeat: no-repeat;
  background-size: cover;
  overflow: hidden;
}

.input {
  width: 90%;
  padding: 5px;
  color: #fff;
  border: 0;
  background: none;
  border-bottom: 2px solid #fff;
  outline: 0;
  font-size: 16px;
  transition: all 0.5s ease-in-out;
}

.label {
  position: absolute;
  margin-left: 5%;
  bottom: 5px;
  left: 0;
  color: #fff;
  cursor: text;
  transition: all 0.5s ease-in-out;
}

.input:focus,
.input:valid {
  border-bottom: 2px solid #FF8C00;
}

.input:focus ~ label,
.input:valid ~ label {
  transform: translateY(-24px);
  font-size: 12px;
  color: #FF8C00;
  background: none;
}

button {
  padding: 10px;
  color: #fff;
  background: #FF8C00;
  border-radius: 5px;
  border: none;
  cursor: pointer;
  font-size: 14px;
}

button:hover {
  filter: brightness(85%);
  transition: 0.3s;
}

h1{
  font-size: 30px;
  margin: 30px 0;
  text-align: center;
  width: 100%;
}

a {
  color: #FF8C00;
  font-size: 12px;
}


</style>