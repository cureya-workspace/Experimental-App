import  express, { Request, Response, Express, Application} from 'express'
import dotenv from 'dotenv';

dotenv.config();

// Initialize
const app: Express = express();
const PORT: any = process.env.PORT;

// Middlewares
app.use(express.json());


app.get('/', (req: Request, res: Response) => {
  console.log("first")
  res.send({"hi":"hello"});
});

app.listen(PORT, () => {
  console.log(`[server]: Server is running at http://localhost:${PORT}`);
});