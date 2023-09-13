<template>
    <div style="width: 100vw; height: 100vh; display: flex; justify-content: center; align-items: center;">
        <div class="container">
          <div class="inputs">
            <div class="div-first-name">
              <input
                v-model="infosLogin.first_name"
                class="input"
                type="text"
                id="first-name"
                required
              />
              <label class="label" for="first-name">Nome</label>
            </div>
      
            <div class="div-last-name">
              <input
                v-model="infosLogin.last_name"
                class="input"
                type="text"
                id="last-name"
                required
              />
              <label class="label" for="last-name">Sobrenome</label>
            </div>
      
            <div class="div-email">
              <input v-model="infosLogin.email" class="input" type="text" id="email" required />
              <label class="label" for="email">Email</label>
            </div>
      
            <div class="div-password">
              <input
                v-model="infosLogin.password"
                class="input"
                type="password"
                id="password"
                required
              />
              <label class="label" for="password">Senha</label>
            </div>
          </div>
          <div class="buttons">
              <button @click="$emit('VoltaLogin')" class="button">Voltar</button>
              <button @click="AtualizarDados()">Atualizar Dados</button>
              <button @click="DeletarUser()">Excluir</button>
          </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
  name: "UpdateDelete",

  props: {
    infosLogin: Object,
  },

  emits: ["VoltaLogin", "AtualizaPropDoLogin"],

  data(){
    return{
        first_name: "",
        last_name: "",
        email: "",
        password: "",
        // infosUser: this.infosLogin,

        // Infos do login
        emailLogin: this.infosLogin.email,
        passwordLogin: this.infosLogin.password,
    }
  },

  // mounted() {
  //   document.addEventListener("keydown", function (event) {
  //     if (event.key === "Escape") {
  //       document.querySelector(".button").click();
  //     }
  //   });
  // },

  methods:{
    AtualizarDados(){
      const config = {
        method: "PUT",
        url: "http://localhost:9000/users/atualizar",
        data: {
          emailWhere: this.emailLogin, // vai no WHERE da query
          passwordWhere: this.passwordLogin, // vai no WHERE da query
          first_name: this.infosLogin.first_name,
          last_name: this.infosLogin.last_name,
          email: this.infosLogin.email,
          password: this.infosLogin.password,
        },
      };

      axios(config)
        .then((res) => {
          console.log(res);

          const AtualizaProps =  {
            fisrt_name:  res.data.first_name,
            last_name: res.data.last_name,
            email: res.data.email,
            password: res.data.password,
          }

          this.emailLogin = res.data.email;
          this.passwordLogin = res.data.password;

          this.$emit("AtualizaPropDoLogin", AtualizaProps);
          this.$emit('VoltaLogin');
        })
        .catch((error) => {
          alert("Ocorreu um erro ao atualizar o usuário, por favor tente novamente mais tarde");
          console.error(error);
        });
    },

    DeletarUser(){
      const config = {
        method: "POST",
        url: "http://localhost:9000/users/deletar",
        data: {
          email: this.infosLogin.email,
          password: this.infosLogin.password,
        },
      };

      axios(config)
        .then((res) => {
          if(res.status == 200){
            this.$emit("VoltaLogin");
          }
        })
        .catch((error) => {
          alert("Ocorreu um erro ao deletar o usuário, por favor tente novamente mais tarde");
          console.error(error);
        });
    }
  },
};
</script>

<style scoped>
.container {
  position: relative;
  height: 25%;
  width: 80%;
  background: rgba(80, 80, 80, 0.7);
  display: column;
  justify-content: center;
  color: #fff;
  border-radius: 10px;
  margin-bottom: 80px;
}

.container div {
  width: 100%;
  display: flex;
  justify-content: center;
  background: none;
  margin-top: 20px;
  position: relative;
}

input{
    border-bottom: 2px solid #fff;
}

label{
    color: #fff;
}

button{
    width: 150px;
    margin: 20px 20px 0 20px;
}
</style>