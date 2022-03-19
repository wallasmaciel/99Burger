import { ClientBase, QueryResult } from 'pg';
import format from 'pg-format';
import { query, Request, Response } from 'express';
import client from '../config/database';

class RequestController { 

    async listRequest(request: Request, response: Response) {
        // Query body
        let sql = `SELECT 
                P.id_pedido, 
                P.status, 
                TO_CHAR(P.dt_pedido, 'DD/MM/YYYY HH:MI:SS') as dt_pedido,
                P.vl_total, 
                COUNT(*) AS qtd_item
            FROM
                pedido P
            LEFT JOIN pedido_item I ON
                I.id_pedido = P.id_pedido
            GROUP BY 
                P.id_pedido, P.status, P.dt_pedido, P.vl_total`;
        
        // Execute query
        client.query(sql, (err: Error, result: QueryResult) => {
                if(err)
                    return response.status(500).send(err);
                // 
                return response.status(200).json(result.rows);
            });
    }

    async listItemsRequest(request: Request, response: Response) {

    }

    async createRequest(request: Request, response: Response) {
        // 
        const params = [
            request.body.id_usuario,
            request.body.vl_subtotal, 
            request.body.vl_entrega, 
            request.body.vl_total
        ];

        // Query body
        let sql = `insert into pedido(id_usuario, dt_pedido, vl_subtotal, vl_entrega, vl_total, status)
            values($1, NOW(), $2, $3, $4, 'A') RETURNING *`;
        
        // Execute query
        client.query('BEGIN', err => {
            if(err) 
                return response.status(500).send(err?.message);
            // 
            client.query(sql, params, (err: Error, result: QueryResult) => {
                if(err) { 
                    client.query('ROLLBACK', (err: Error) => {
                        return response.status(500).send(err?.message);
                    });
                }else {
                    if(result.rows.length > 0) { 
                        const id_pedido = result.rows[0].id_pedido;
                        const itens = request.body.itens;

                        let values = [];

                        for(var i = 0; i < itens.length; i++) 
                            values.push([
                                id_pedido, 
                                itens[i].id_produto, 
                                itens[i].qtd, 
                                itens[i].vl_unitario,
                                itens[i].vl_total
                            ]);

                        sql = format(`insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total)
                            values %L returning *`, values);

                        client.query(sql, (err: Error, result: QueryResult) => {
                            if(err) 
                                client.query('ROLLBACK', (err: Error) => {
                                    return response.status(500).send(err?.message || "rolback");
                                });
                            //
                            client.query('COMMIT', (err: Error) => {
                                if(err)
                                    return response.status(500).send(err?.message);
                                // 
                                return response.status(201).json({
                                    id_pedido
                                });
                            });
                        });
                    }else {
                        client.query('ROLLBACK', (err: Error) => {
                            return response.status(500).send('Pedido salvo não foi retornado. ROLLBACK aplicado.');
                        });
                    }
                }
            });
        });
    }

    async changeStatusRequest(request: Request, response: Response) {
        let sql = `update pedido set status = $1 where id_pedido = $2`;
        // 
        client.query(sql, [ request.body.status, request.params.id_pedido ], (err: Error, result: QueryResult) => {
            if(err)
                return response.status(500).send(err);
            // 
            return response.status(200).json({
                id_pedido: request.params.id_pedido
            });
        });
    }
}

export default RequestController; 