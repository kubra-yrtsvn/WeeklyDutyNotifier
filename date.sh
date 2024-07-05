#!/bin/bash

BOT_TOKEN="7207999152:AAGiJRGHJDx6lbzuOQMK9Og6FLPeeUAcVPk"
CHAT_ID="5969240980"


#Dosya adını belirtelim
file="deneme.txt"

#Güncel tarihi alalım
current_date=$(date +%Y-%m-%d)


#Güncel tarihi ekrana yazdıralım(kontrol)
echo "Güncel tarih: $current_date"

#Telegramdan mesaj gönderme fonksiyonu
send_telegram_message(){
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$message"
}    


#Dosya var mı yok mu
if [[ ! -f "$file" ]]; then
  echo "Dosya bulunamadı: $file"
  exit 1
fi 

found_match=0
while IFS= read -r line
do
 
  #Dosyadaki tarih ve isimleri ayıralım.
  date_part=$(echo "$line" | awk '{print $1}') 
  name_part=$(echo "$line" | awk '{$1=""; print $0}')

  
  if [[ "$date_part" == "$current_date" ]]; then
    echo "Haftanın görevlisi: $line"
    send_telegram_message "Haftanın görevlisi:$name_part"
    found_match=1
  fi
done < "$file" 

 

if [[ $found_match -eq 0 ]]; then
  send_telegram_message "Eşleşen görevli bulunamadı: $current_date"
fi 
