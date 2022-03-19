import { Router, Request, Response } from "express";
import ProductController from "../controllers/productController";
// 
export default (router: Router) => {
    const productController = new ProductController();

    // Create routes the 'Products'
    router.get('/produtos/cardapio', productController.listCardapio);
};