import { Router, Request, Response } from "express";
import RequestController from "../controllers/requestController";
// 
export default (router: Router) => {
    const requestController = new RequestController();

    // Create routes the 'Requests'
    router.get('/pedidos', requestController.listRequest);
    router.get('/pedidos/itens', requestController.listItemsRequest);
    router.post('/pedidos', requestController.createRequest);
    router.put('/pedidos/status/:id_pedido', requestController.changeStatusRequest);
};