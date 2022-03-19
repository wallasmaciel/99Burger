import { Router } from 'express';
import RouterProduct from './product';
import RouterRequest from './request';
import RouterConfig  from './configs';
// Instance router of express 
const router = Router();
// -----------------------------------
// Routers creating
RouterProduct(router);
RouterRequest(router);
RouterConfig(router);
// -----------------------------------
export default router;