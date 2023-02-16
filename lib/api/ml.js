const axios = require("axios");

const options = {
  method: 'GET',
  url: 'https://real-time-lens-data.p.rapidapi.com/search',
  params: {url: 'https://i.imgur.com/HBrB8p0.png', language: 'en'},
  headers: {
    'X-RapidAPI-Key': '29abe7873dmsh6f664e42735ae72p1458fdjsn2c4ecbbb27fb',
    'X-RapidAPI-Host': 'real-time-lens-data.p.rapidapi.com'
  }
};

axios.request(options).then(function (response) {
	console.log(response.data);
}).catch(function (error) {
	console.error(error);
});