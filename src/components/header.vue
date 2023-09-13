<template>
    <div class="header">
        <img src="../assets/logo.png" :width="80" :height="80" alt="Logo">

        <ul>
            <li @click="$router.push('/')">Login</li>
            <li @click="$router.push('/cadastro')">Cadastro</li>
        </ul>

    </div>
</template>

<script>

export default{
    name: "headerComponente"
}
</script>

<style scoped>
.header{
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    height: 12vh;
}

img{
    margin-left: 20px;
    color: #fff;
}

ul{
    width: 20%;
    display: flex;
    justify-content: space-around;
    margin-right: 6%;
}

li{
    list-style: none;
    color: #fff;
    font-size: 18px;
    cursor: pointer;
}

li:hover{
    color: #FF8C00;
    transition: .3s;
}


</style>