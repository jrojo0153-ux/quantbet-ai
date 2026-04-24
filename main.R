library(httr2)
library(jsonlite)
library(dplyr)

# 1. Variables de Entorno 
deepseek_key <- Sys.getenv("DEEPSEEK_API_KEY")
telegram_token <- Sys.getenv("TELEGRAM_TOKEN")
chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")

# Variables simuladas para la prueba:
partido <- "América vs Cruz Azul"
probabilidad_local <- 0.55
cuota_ofrecida <- 2.10
edge_calculado <- (probabilidad_local * cuota_ofrecida) - 1

# 3. Agente Autónomo (DeepSeek API)
prompt_text <- paste(
  "Actúa como un analista cuantitativo de fútbol. Redacta una alerta de apuesta breve y directa para Telegram.",
  "Partido:", partido,
  "| Probabilidad Modelo:", probabilidad_local,
  "| Cuota:", cuota_ofrecida,
  "| Ventaja (Edge):", edge_calculado
)

req_deepseek <- request("https://api.deepseek.com/chat/completions") %>%
  req_headers(
    "Authorization" = paste("Bearer", deepseek_key),
    "Content-Type" = "application/json"
  ) %>%
  req_body_json(list(
    model = "deepseek-chat",
    messages = list(list(role = "user", content = prompt_text))
  ))

res_deepseek <- req_perform(req_deepseek)
mensaje_final <- resp_body_json(res_deepseek)$choices[[1]]$message$content

# 4. Envío a Telegram
req_telegram <- request(paste0("https://api.telegram.org/bot", telegram_token, "/sendMessage")) %>%
  req_body_json(list(
    chat_id = chat_id,
    text = mensaje_final,
    parse_mode = "Markdown"
  ))

req_perform(req_telegram)
print("Ejecución completada con éxito.")
