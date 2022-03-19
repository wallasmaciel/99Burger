import express, { NextFunction, Request, Response } from 'express';
import cors from 'cors';
import router from './routes/routes';
import client from './config/database';

// Instanciar express
const app = express();
// Middleware JSON
app.use(express.json());
// Middleware Cors - Habilitar que outras aplicações requesitem meu servidor
app.use(cors());

// Rotas da api 
app.use(router);

// Middleware que trata erros na requisição 
app.use((err: Error, request: Request, response: Response, next: NextFunction) => {
    if(err instanceof Error) 
        return response.status(400).json({
            error: err.message
        });
    // 
    return response.status(500).json({
        status: 'error',
        message: 'Internal Server error'
    });
});

// Abrir servidor 
app.listen(3000, () => {
    console.log('Servidor no ar na porta 3000');
});