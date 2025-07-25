import cron from 'node-cron';
import { fetchClimateData } from './climate_consumer';

cron.schedule('*/5 * * * *', () => {
    console.log('Ejecutando tarea programada para obtener datos climáticos cada 5 minutos');
    fetchClimateData();
});
