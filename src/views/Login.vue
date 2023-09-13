<template>
  <div v-if="login == false" class="container-login">
    <headerComponente />

    <div
      style="
        width: 100vw;
        height: 90vh;
        display: flex;
        justify-content: center;
        align-items: center;
      "
    >
      <div class="div-login">
        <h1>Login</h1>

        <div class="div-email">
          <input
            class="input"
            v-model="email"
            type="text"
            id="email"
            required
          />
          <label class="label" for="email">Email</label>
        </div>

        <div class="div-password">
          <input
            class="input"
            v-model="password"
            type="password"
            id="password"
            required
          />
          <label class="label" for="password">Senha</label>
        </div>

        <div class="div-button">
          <button id="btn-login" @click="Login()">Login</button>
        </div>

        <p>Ainda não tem uma conta? <a href="./cadastro">Criar conta</a></p>
      </div>
    </div>
  </div>

  <div v-else style="margin-left: 10px">
    <UpdateDelete
      @VoltaLogin="VoltaLogin()"
      @AtualizaPropDoLogin="AtualizaPropDoLogin()"
      :infosLogin="infosLogin"
    />
  </div>
</template>

<script>
import headerComponente from "../components/header.vue";
import UpdateDelete from "../components/UpdateDelete.vue";

import axios from "axios";

export default {
  name: "Login",

  components: {
    headerComponente,
    UpdateDelete,
  },

  data() {
    return {
      email: "",
      password: "",
      nome: "exemplo",
      sobrenome: "teste",
      login: false,
      infosLogin: "",
    };
  },

  // mounted() {
  //   document.addEventListener("keypress", function (event) {
  //     if (event.key === "Enter") {
  //       document.querySelector("#btn-login").click();
  //     }
  //   });
  // },

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

      axios(config)
        .then((res) => {
          this.infosLogin = res.data;

          if ((res.data.message = "acesso liberado")) {
            this.login = true;
          }
        })
        .catch((error) => {
          console.error(error);
          alert(error.response.data);
        });
    },

    AtualizaPropDoLogin(dados){
      console.log(dados);
    },

    VoltaLogin() {
      this.login = false;
    },
  },
};
</script>

<style scoped>
.container-login {
  height: 90vh;
  width: 100vw;
}

.div-login {
  position: relative;
  height: 70%;
  width: 30%;
  background: rgba(80, 80, 80, 0.7);
  display: column;
  justify-content: center;
  color: #fff;
  border-radius: 10px;
  margin-bottom: 100px;
}

.div-img,
.div-email,
.div-password {
  width: 100%;
  display: flex;
  justify-content: center;
  background: none;
}

.div-email{
  position: relative;
  margin-top: 10px;
}

.div-password {
  position: relative;
  margin-top: 20px;
}

.div-button {
  width: 100%;
  background: none;
  margin-top: 20px;
  margin-left: 5%;
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