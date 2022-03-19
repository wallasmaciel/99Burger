import { Router, Request, Response } from "express";
import ConfigController from "../controllers/configController";
// 
export default (router: Router) => {
    const configController = new ConfigController();

    // Create routes the 'Configs'
    router.get('/configs', configController.listConfig);
};