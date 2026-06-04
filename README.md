# Analisi Comparativa del Metodo di Cholesky per Matrici Sparse
### Membri: Hicham Benbouzid, Le Yang Shi, Elena Zen

Questo progetto nasce dall'esigenza aziendale di valutare l'efficienza di diverse soluzioni software per la risoluzione di sistemi lineari di grandi dimensioni, caratterizzati da matrici sparse, simmetriche e definite positive. L'obiettivo principale è confrontare le prestazioni di **MATLAB** con una **libreria open source** a scelta su due diversi sistemi operativi: **Windows** e **Linux**.

# Obiettivi del Progetto
Il lavoro si focalizza sullo studio del metodo di **Cholesky** applicato a matrici sparse provenienti dalla *SuiteSparse Matrix Collection*. Il confronto deve evidenziare:

- **Tempo di calcolo**: Velocità nella risoluzione del sistema $Ax=b$.
- **Accuratezza**: Calcolo dell'errore relativo rispetto alla soluzione esatta $x_e = [1, 1, \dots, 1]^T$.
- **Occupazione di memoria**: Incremento della memoria utilizzata durante la fase di risoluzione.
- **Usabilità**: Facilità d'uso e qualità della documentazione delle librerie utilizzate.

L'errore relativo è calcolato tramite la norma euclidea: 

$$\text{errore relativo} = \frac{||x-x_e||_{2}}{||x_e||_{2}}$$

## Matrici usate

Le matrici utilizzate per i test derivano da problemi reali (ingegneria, fluidodinamica, grafi) e sono reperibili su *Sparse SuiteSparse*:
- `Flan 1565`
- `StocF-1465`
- `cfd2`
- `cfd1`
- `G3 circuit`
- `parabolic fem`
- `apache2`
- `shallow water1`
- `ex15`

Le matrici sono scaricabili attraverso i script all'interno delle cartelle `matlab` e `python`.

Download matrici Windows:
```powershell
powershell -ExecutionPolicy Bypass -File .\script.ps1

.\script.ps1
```
Download matrici Linux: 
```bash
bash script.sh
```
## Concetti chiavi
- **Fill-in**: L'implementazione deve prevedere una permutazione preliminare di righe e colonne per minimizzare la generazione di nuovi elementi non nulli durante la fattorizzazione.
- **Algoritmi Specifici**: A differenza di MATLAB, le librerie open source richiedono spesso l'esplicita selezione di algoritmi per matrici simmetriche e definite positive per evitare prestazioni degradate. 

# Ambiente di test
I test sono stati eseguiti sulla stessa macchina fisica per garantire l'imparzialità dei dati.

Softeware usati: 
- **MATLAB**
- **Python** con la libreria [Scikit-Sparse](https://github.com/scikit-sparse/scikit-sparse) (`CHOLMOD`)
- OS: **Windows** e **Linux**

## Avvio profiler MATLAB su Linux

```bash
chmod +x monitor_memory.sh
```
Comando da lanciare da terminale prima di avviare MATLAB su Linux, in modo da dare i permessi al profiler per misurare la memoria.

## Installazione e attivazione della libreria `Scikit-Sparse` per Python
### Setup con Conda (Windows + Linux)

**Perché Conda?** Fornisce scikit-sparse precompilato con tutte le librerie C++ necessarie (CHOLMOD/SuiteSparse), evitando compilazioni complesse.

Installa Miniconda da: https://docs.conda.io/en/latest/miniconda.html

**Windows:**
```powershell

# Inizializza conda
conda init powershell

# Chiudi e riapri il terminale

# Crea ambiente dalla cartella python/
conda env create -f environment.yml

# Attiva ambiente
conda activate mcs-sparse

# Avvio script
python cholesky.py
```

**Linux:**
```bash

# Crea ambiente dalla cartella python/
conda env create -f environment.yml

# Inizializza conda
conda init

# Chiudi e riapri il terminale

# Attiva ambiente
conda activate mcs-sparse

# Avvio script
python cholesky.py
```

## Librerie Python utilizzate

### 1. **SciPy** (scipy.sparse + scipy.io)
- **Documentazione**: https://docs.scipy.org/doc/scipy/
- **Caratteristiche**:
  - Lettura/scrittura matrici sparse formato Matrix Market (`.mtx`)
  - Supporto multipli formati sparse: CSC, CSR, COO, LIL, DOK
  - Operazioni algebriche ottimizzate per matrici sparse
  - Parte dell'ecosistema scientifico Python (NumPy/SciPy stack)
- **Manutenzione**: Progetto maturo con rilasci regolari, comunità attiva

### 2. **scikit-sparse** (sksparse.cholmod)
- **Wrapper Python per CHOLMOD** (parte di SuiteSparse di Tim Davis)
- **Documentazione**: https://scikit-sparse.readthedocs.io/
- **Caratteristiche**:
  - Decomposizione di Cholesky ottimizzata per matrici sparse molto grandi
  - Riordinamento automatico per minimizzare fill-in (AMD, COLAMD, METIS)
  - Analisi simbolica + fattorizzazione numerica separate
  - Supporto supernodi per efficienza cache
  - Gestisce matrici con milioni di elementi
- **Performance**: CHOLMOD è lo standard de-facto per Cholesky sparse
- **Manutenzione**: SuiteSparse attivamente sviluppato (v7.x), wrapper scikit-sparse stabile

### 3. **NumPy**
- **Documentazione**: https://numpy.org/doc/
- **Uso nel progetto**: Vettori densi, calcolo norme, operazioni algebriche
- **Manutenzione**: Progetto fondamentale dell'ecosistema Python, rilasci frequenti

### 4. **memory_profiler**
- **Documentazione**: https://pypi.org/project/memory-profiler/
- **Uso**: Profilazione e monitoraggio dell'uso di memoria tramite la funzione `memory_usage` di memory_profiler
- **Caratteristiche**: Semplice da usare, fornisce grafici e report dettagliati sull'uso della memoria
- **Manutenzione**: Progetto attivamente mantenuto, ampiamente usato nella comunità scientifica

## Formati di memorizzazione matrici sparse
Le matrici sparse vengono memorizzate solo con gli elementi **non-zero**, riducendo drasticamente l'occupazione di memoria.

### Formato CSC (Compressed Sparse Column) - Usato in questo progetto

**Struttura dati:**
- `data[]`: valori degli elementi non-zero (array di float64)
- `indices[]`: indici di riga per ogni elemento (array di int32/int64)
- `indptr[]`: puntatori alle colonne (array di int32/int64, lunghezza n+1)

**Esempio:**
```
Matrice 4x4 con 6 elementi non-zero:
 2  0  0  3
 0  5  0  0
 0  1  4  0
 6  0  0  7

CSC:
data    = [2, 6, 5, 1, 4, 3, 7]
indices = [0, 3, 1, 2, 2, 0, 3]
indptr  = [0, 2, 4, 5, 7]
        col 0→  col 1→  col 2→  col 3→
```

**Occupazione memoria:** 
- Per matrice n×n con nnz elementi non-zero:
- Memoria ≈ `8·nnz + 4·nnz + 4·(n+1)` bytes
- Esempio: matrice 10000×10000 con 100000 elementi → ~1.6 MB (vs ~800 MB se densa)

