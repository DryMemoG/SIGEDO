import 'dotenv/config';
import express from 'express';
import './services/scheduler';
const PORT = process.env.PORT || 3000;
const app = express();
app.get('/', (_req, res) => {
    res.send('¡Hola desde tu backend con TypeScript y Node.js!');
});

app.listen(PORT, () => {
    console.log(`El proceso ${process.env.SERVICE_NAME} está corriendo en http://${process.env.DOMAIN}:${PORT}`);
});
