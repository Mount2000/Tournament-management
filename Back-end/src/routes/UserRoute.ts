import { Router, Request, Response, NextFunction} from 'express';
import {setUserInfor, getInforFromContract} from "../controllers/UserManagement";

const router = Router();

router.route('/register').post((req: Request, res: Response, next: NextFunction) => {
    console.log('POST /users route hit');
    next();
  },getInforFromContract);
router.route('/infor').post(setUserInfor);

export default router;