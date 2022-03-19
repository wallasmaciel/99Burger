import { Request, Response } from 'express';
import { QueryResult, ResultBuilder } from 'pg';
import client from '../config/database'; 

class ProductController { 

    async listCardapio(request: Request, response: Response) {
        // Query body
        let sql = `SELECT 
                C.descricao as categoria, 
                P.* 
            FROM
                produto P
            INNER JOIN produto_categoria C ON 
                C.id_categoria = P.id_categoria
            ORDER BY C.ordem
            `;
        
        // Execute query
        client.query(sql, (err: Error, result: QueryResult) => {
                if(err)
                    return response.status(500).send(err);
                // 
                return response.status(200).json(result.rows);
            });
    }
}

export default ProductController; 