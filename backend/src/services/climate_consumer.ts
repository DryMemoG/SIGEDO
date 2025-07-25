import axios from 'axios';
import { getConnection } from '../config/db-mysql';
import dotenv from 'dotenv';

dotenv.config();
const url = process.env.OPENWEATHER_API;
const latitude = process.env.LATITUDE;
const longitude = process.env.LONGITUDE;
const apiKey = process.env.OPENWEATHER_API_KEY;
const units = process.env.UNITS;

function convertDate(dt: number) {
    const date = new Date(dt * 1000);
    const dateISO = date.toISOString();
    return dateISO;
}

export const fetchClimateData = async () => {
    try {
        console.log(url+"lat="+latitude+"&lon="+longitude+"&exclude=minutely,hourly,daily&appid="+apiKey+"&units="+units)
        const response = await axios.get(url+"lat="+latitude+"&lon="+longitude+"&exclude=minutely,hourly,daily&appid="+apiKey+"&units="+units);
        const datos = response.data;
        console.log("Datos del clima obtenidos:", datos);
        console.log("Fecha de obtención:", convertDate(datos.current.dt));
        console.log("Clima actual:", datos.current.weather);
        const insData = {
            datetime: convertDate(datos.current.dt),
            temp : datos.current.temp,
            hum : datos.current.humidity,
            sensacion : datos.current.feels_like,
            presion : datos.current.pressure,
            UVI : datos.current.uvi,
            wind_speed : datos.current.wind_speed,
            wind_direction : datos.current.wind_deg,
            wheather_id : datos.current.weather[0].id,
            nubosidad : datos.current.clouds,
            punto_rocio : datos.current.dew_point,
        }
        console.log("Datos a insertar:", insData);
    }
    catch (error) {
        console.error('Error al obtener los datos climáticos:', error);
    }
}