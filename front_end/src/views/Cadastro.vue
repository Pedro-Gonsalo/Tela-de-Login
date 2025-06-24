<template>
  <div class="div-cadastro">
    <h1>Cadastro</h1>

    <div class="div-first-name">
      <input v-model="first_name" class="input" type="text" id="first-name" required />
      <label class="label" for="first-name">Nome</label>
    </div>

    <div class="div-last-name">
      <input v-model="last_name" class="input" type="text" id="last-name" required />
      <label class="label" for="last-name">Sobrenome</label>
    </div>

    <div class="div-email">
      <input v-model="email" class="input" type="text" id="email" required />
      <label class="label" for="email">Email</label>
    </div>

    <div class="div-password">
      <input v-model="password" class="input" type="password" id="password" required />
      <label class="label" for="password">Senha</label>
    </div>

    <div class="div-confirm-password">
      <input v-model="confirmar_password" class="input" type="password" id="confirm-password" required />
      <label class="label" for="confirm-password">Confirmar senha</label>
    </div>

    <div class="div-termos-licenca">
      <input type="checkbox" id="termos-lecenca" value="termos" required />
      <label for="termos-lecenca">
        Li e aceito os <a href="">Termos de Licença</a>
      </label>
    </div>

    <div class="div-button">
      <button id="btn-cadastrar" @click="Cadastro()">Cadastrar</button>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Cadastro",

  components: {
  },

  data() {
    return {
      first_name: "",
      last_name: "",
      email: "",
      password: "",
      confirmar_password: "",
    };
  },

  methods: {
    Cadastro() {
      let senha = document.querySelector("#password").value;
      let confirmar_senha = document.querySelector("#confirm-password").value;
      let checkbox = document.querySelector("#termos-lecenca");

      if (senha != confirmar_senha) {
        alert("Senhas diferentes");
      }
      else if (checkbox.checked == false) {
        alert("Por favor, aceite os termos de licença");
      }
      else {
        const config = {
          method: "POST",
          url: "http://localhost:9000/users/cadastro",
          data: {
            first_name: this.first_name,
            last_name: this.last_name,
            email: this.email,
            password: this.password,
          },
        };

        axios(config)
          .then((res) => {
            console.log(res);

            this.first_name = "";
            this.last_name = "";
            this.email = "";
            this.password = "";
            this.confirmar_password = "";

            alert(res.data);
          })
          .catch((error) => {
            console.error(error);

            alert(error.response.data);
          });
      }
    },
  },
};
</script>

<style scoped>
.div-cadastro {
  position: relative;
  height: 100%;
  width: 100%;
  display: column;
  justify-content: center;
  align-items: center;
  color: #000;
  border-radius: 10px;
}

.div-cadastro div {
  width: 100%;
  display: flex;
  justify-content: center;
  position: relative;
  margin-bottom: 30px;
}

.div-termos-licenca {
  justify-content: flex-start !important;
}

.div-termos-licenca input {
  margin-left: 5%;
  margin-right: 5px;
}

.div-termos-licenca label {
  font-size: 12px;
}

button {
  width: 50%;
}
</style>
