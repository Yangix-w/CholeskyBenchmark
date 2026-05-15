#!/bin/bash
# monitor_memory.sh
PID=$1
LOGFILE=$2
FLAGFILE=$3

# Pulisce il log precedente
> "$LOGFILE"

# Continua a registrare finché non viene creato il file "FLAGFILE" da MATLAB
while [ ! -f "$FLAGFILE" ]; do
    # Estrae la memoria RSS in KB per il PID e la salva nel log
    ps -p $PID -o rss= >> "$LOGFILE"
    sleep 0.005 # Campiona ogni 5ms
done

# Lancia chmod +x monitor_memory.sh da terminale prima di avviare MATLAB