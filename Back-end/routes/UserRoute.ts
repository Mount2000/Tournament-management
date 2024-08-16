import { Router, Request, Response, NextFunction} from 'express';
import {getUserInfor, getUserFromContract} from "../controllers/UserManagement";

const router = Router();

router.route('/register').post((req: Request, res: Response, next: NextFunction) => {
    console.log('POST /users route hit');
    next();
  },getUserFromContract);
router.route('/infor').get(getUserInfor);

export default router;