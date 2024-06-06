
# Telegraf, InfluxDB, Grafana (TIG) Stack for Data Ingestion from Efergy Devices

Gain the ability to analyse and monitor Efergy data by deploying the TIG stack using [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

Built on [Huntabyte's TIG Stack Tutorial](https://github.com/huntabyte/tig-stack).




## ⚡️ Getting Started

Clone the project

```bash
git clone https://github.com/lfischler/tig-stack.git
```

Navigate to the project directory

```bash
cd tig-stack
```

Change the environment variables define in `.env` that are used to setup and deploy the stack
```bash
├── telegraf/
├── .env         <---
├── docker-compose.yml
├── entrypoint.sh
└── ...
```

Customize the `telegraf.conf` file which will be mounted to the container as a persistent volume

```bash
├── telegraf/
│   ├── telegraf.conf <---
├── .env
├── docker-compose.yml
├── entrypoint.sh
└── ...
```

Start the services
```bash
docker-compose up -d
```
## Docker Images Used (Official & Verified)

[**Telegraf**](https://hub.docker.com/_/telegraf) / `1.30.3`

[**InfluxDB**](https://hub.docker.com/_/influxdb) / `2.7`

[**Grafana-OSS**](https://hub.docker.com/r/grafana/grafana-oss) / `11.0.0`



## Contributing

Contributions are always welcome!

## Acknowledgements

Thanks to Huntabyte's original tutorial and code.

