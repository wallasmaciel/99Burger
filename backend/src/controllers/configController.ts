import { Request, Response } from 'express';
import { QueryResult, ResultBuilder } from 'pg';
import client from '../config/database';

class ConfigController { 

    async listConfig(request: Request, response: Response) {
        let sql = `SELECT * FROM config`;
        // 
        client.query(sql, (err: Error, result: QueryResult) => {
            if(err)
                return response.status(500).send(err);
            // 
            return response.status(200).json(result.rows);
        });
    } 
}

export default ConfigController; 