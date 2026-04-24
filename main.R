name: QuantBet AI Daily Run

on:
  schedule:
    # Se ejecuta todos los días a las 14:00 UTC (Aprox 8:00 AM CDMX)
    - cron: '0 14 * * *'
  workflow_dispatch: # Permite ejecutar el bot manualmente desde el celular

jobs:
  run-r-script:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout del código
        uses: actions/checkout@v4

      - name: Instalar R
        uses: r-lib/actions/setup-r@v2
        with:
          r-version: 'release'

      - name: Instalar librerías de R
        run: |
          install.packages(c("httr2", "jsonlite", "dplyr"))
        shell: Rscript {0}

      - name: Ejecutar Modelo y Agente Autónomo
        env:
          DEEPSEEK_API_KEY: ${{ secrets.DEEPSEEK_API_KEY }}
          TELEGRAM_TOKEN: ${{ secrets.TELEGRAM_TOKEN }}
          TELEGRAM_CHAT_ID: ${{ secrets.TELEGRAM_CHAT_ID }}
        run: Rscript main.R
