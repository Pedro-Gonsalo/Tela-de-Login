<template>
  <div class="container-login">
    <div class="container-conteudo">
      <form id="form-login">
        <div v-if="login">
          <h1>Login</h1>
  
          <div class="div-input">
            <input class="input" v-model="email" type="text" id="email" required />
            <label class="label" for="email">Email</label>
          </div>
  
          <div class="div-input">
            <input class="input" v-model="password" type="password" id="password" required />
            <label class="label" for="password">Senha</label>
          </div>
  
          <div class="div-button">
            <button id="btn-login" @click="Login()">Login</button>
          </div>
        </div>
        <div v-else>
          <Cadastro />
        </div>
      </form>

      <div id="div-cadastro">
        <div v-if="!login">
          <h1>Já tem uma conta?</h1>
          <p>Faça login com sua conta para acessar nossos serviços </p>
          <div class="div-button">
            <button class="btn-criar-conta" @click="CriarConta()">Login</button>
          </div>
        </div>
        <div v-else>
          <h1>Ainda não tem uma conta?</h1>
          <p>Crie uma conta para acessar nossos serviços </p>
          <div class="div-button">
            <button class="btn-criar-conta" @click="CriarConta()">Criar Conta</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div v-if="false" style="margin-left: 10px">
    <UpdateDelete @VoltaLogin="VoltaLogin()" @AtualizaPropDoLogin="AtualizaPropDoLogin()" :infosLogin="infosLogin" />
  </div>
</template>

<script>
import UpdateDelete from "../components/UpdateDelete.vue";

import axios from "axios";

import Cadastro from "./Cadastro"

export default {
  name: "Login",

  components: {
    Cadastro,
    UpdateDelete,
  },

  data() {
    return {
      email: "",
      password: "",
      login: true,
      infosLogin: "",
    };
  },

  watch: {
    // login() {
    //   this.Login();
    // }
  },

  methods: {
    Login() {
      const config = {
        method: "POST",
        url: "http://localhost:9000/users/login",
        data: {
          email: this.email,
          password: this.password,
        },
      };

      axios()
        .then((res) => {
          this.infosLogin = res.data;

          if ((res.data.message = "acesso liberado")) {
            alert(res.data.message);

            // this.login = true;
          }
        })
        .catch((error) => {
          console.error(error);
          alert(error.response.data);
        });
    },

    CriarConta(){
      this.login = !this.login;
    },

    AtualizaPropDoLogin(dados) {
      console.log(dados);
    },

    VoltaLogin() {
      this.login = true;
    },
  },
};
</script>

<style scoped>
.container-login{
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.container-conteudo{
  display: flex;
  justify-content: center;
  width: 50%;
  height: 60%;
}

#form-login, #form-login > div:nth-child(1){
  width: 50%;
  background: #fff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

#form-login > div:nth-child(1){
  width: 100% !important;
}

#div-cadastro, #div-cadastro > div:nth-child(1){
  width: 50%;
  background: #5453a0;
  color: #fff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  animation-duration: 1s;
}

#div-cadastro > div:nth-child(1){
  width: 100% !important;
}

.div-input {
  width: 100%;
  display: flex;
  justify-content: center;
  background: none;
  position: relative;
  margin-top: 20px;
}

.div-button {
  width: 50%;
  background: none;
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

.btn-criar-conta{
  border: 1px solid #fff;
}

button {
  width: 90%;
}

p {
  margin-top: 10px;
  text-align: center;
  font-size: 12px;
}
</style>