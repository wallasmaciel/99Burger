import { Client } from 'pg';

const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'cardapio',
    password: 'postgres',
    port: 5432
});

client.connect((err: Error) => {
    if(err) 
        console.log('Erro ao conectar com o banco: ', err.message); 
});

export default client; 