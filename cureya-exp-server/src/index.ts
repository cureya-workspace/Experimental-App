import  express, { Request, Response, Express} from 'express'
import dotenv from 'dotenv';
import baseRouter from './routers/base.router';

dotenv.config();

// Initialize
const app: Express = express();

// Middlewares
app.use(express.json());


// Router
app.use(baseRouter);

app.get('/', (req: Request, res: Response) => {
  console.log("first")
  res.send({"hi":"hello"});
});

app.listen(process.env.PORT, () => {
  console.log(`[server]: Server is running at http://localhost:${process.env.PORT}`);
});