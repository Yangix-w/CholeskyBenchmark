% Metodi del Calcolo Scientifico - Progetto 1
% Hicham Benbouzid 894680
% Le Yang Shi 894536
% Elena Zen 895355

clear; clc; close all;

% Elenco delle matrici
matrici_names = {%'Flan_1565.mat', ...
                 %'StocF-1465.mat', ...
                 'cfd2.mat', ...
                 'cfd1.mat', ...
                 'G3_circuit.mat', ...
                 'parabolic_fem.mat', ...
                 'apache2.mat', ...
                 'shallow_water1.mat', ...
                 'ex15.mat'};

num_matrici = length(matrici_names);

% Inizializzazione degli array per salvare i risultati
N_vals = zeros(num_matrici, 1);
tempi = zeros(num_matrici, 1);
errori = zeros(num_matrici, 1);
memorie = zeros(num_matrici, 1);

fprintf('Inizio decomposizione di Cholesky per tutte le matrici...\n');
fprintf('--------------------------------------------------\n');

for i = 1:num_matrici
    nome_file = fullfile('matrices', matrici_names{i});
    fprintf("Matrice: %-15s | ", strrep(matrici_names{i}, '.mat', ''));

    % Controlla se il file esiste
    if ~isfile(nome_file)
        warning('File %s non trovato. Salto la matrice.', nome_file);
        continue;
    end
    
    % Caricamento della matrice
    data = load(nome_file);
    if isfield(data, 'Problem')
        A = data.Problem.A;
    else
        campi = fieldnames(data);
        A = data.(campi{1}); 
    end

    N = size(A, 1);
    
    % --- SETUP MONITORAGGIO MEMORIA ---
    % Ottieni il Process ID (PID) di questa sessione di MATLAB
    matlab_pid = feature('getpid');
    
    % Definisci i percorsi per i file di scambio
    log_file = fullfile(pwd, 'mem_log.txt');
    flag_file = fullfile(pwd, 'stop_monitor.txt');
    
    % Assicurati che i file della sessione precedente siano eliminati
    if isfile(log_file), delete(log_file); end
    if isfile(flag_file), delete(flag_file); end

    % Lancia lo script in background in base al Sistema Operativo
    if ispc
        % Windows: Usa Start /B per lanciare PowerShell in background senza aprire nuove finestre
        cmd = sprintf('start /B powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File monitor_memory.ps1 -PIDToMonitor %d -LogFile "%s" -FlagFile "%s"', matlab_pid, log_file, flag_file);
        system(cmd);
    else
        % Linux: Esegue lo script bash in background usando la e commerciale (&)
        cmd = sprintf('./monitor_memory.sh %d "%s" "%s" &', matlab_pid, log_file, flag_file);
        system(cmd);
    end

    % Breve pausa per assicurarsi che lo script in background sia partito
    %pause(0.5);

    % Aspetta che il file di log venga creato e che contenga dei dati (massimo 15 sec)
    timeout = 15;
    t_wait = tic;
    log_pronto = false;
    
    while toc(t_wait) < timeout
        if isfile(log_file)
            % Se il file esiste, controlla che non sia vuoto (bytes > 0)
            info_file = dir(log_file);
            if info_file.bytes > 0
                log_pronto = true;
                break; % Usciamo dal ciclo: PowerShell ha iniziato a scrivere!
            end
        end
        pause(0.1); % Controlla ogni decimo di secondo
    end
    
    if ~log_pronto
        warning('Timeout: lo script esterno è troppo lento o non si è avviato.');
    end

    % --- ESECUZIONE DELLA RISOLUZIONE E MISURAZIONE TEMPO ---
    tic;
    errori(i) = solve(A, N);
    tempi(i) = toc;

    % --- FINE MONITORAGGIO MEMORIA ---
    % Crea il file "flag" per dire allo script in background di fermarsi
    fid = fopen(flag_file, 'w');
    fclose(fid);
    
    % Breve pausa per dare tempo allo script di accorgersi del flag e chiudersi
    pause(0.5);
    
    % --- CALCOLO INCREMENTO RAM ---
    if isfile(log_file)
        mem_data = readmatrix(log_file); % Legge l'array dei campionamenti in KB
        if ~isempty(mem_data)
            mem_start = mem_data(1);      % Memoria all'istante iniziale
            mem_peak = max(mem_data);     % Picco di memoria raggiunto
            % Incremento in Megabyte (MB)
            %memorie(i) = (mem_peak - mem_start) / 1024; 
            memorie(i) = mem_peak / 1024;
        else
            memorie(i) = 0;
            warning('Il file di log della memoria è vuoto per %s.', matrici_names{i});
        end
    else
        memorie(i) = 0;
        warning('Impossibile trovare il file di log della memoria per %s.', matrici_names{i});
    end

    N_vals(i) = N; 
    fprintf("N: %-8d | ", N_vals(i));
    
    % Stampa dei risultati intermedi
    fprintf('Tempo: %8.4f s | Errore: %8.2e | Incremento Memoria: %8.4f MB\n', ...
            tempi(i), errori(i), memorie(i));
            
    % Pulizia per liberare la RAM prima del ciclo successivo
    clear A data;
    
    % Rimuove i file temporanei
    if isfile(log_file), delete(log_file); end
    if isfile(flag_file), delete(flag_file); end
end

fprintf('--------------------------------------------------\n');
fprintf('Analisi completata. Generazione dei grafici...\n');

% Ordinamento dei dati in base alla dimensione N per avere un grafico leggibile (linea continua da N piccolo a N grande)
[N_vals_sorted, idx] = sort(N_vals);
tempi_sorted = tempi(idx);
errori_sorted = errori(idx);
memorie_sorted = memorie(idx);

% Esclusione eventuali file saltati perché non trovati (N = 0)
valid_idx = N_vals_sorted > 0;
N_vals_sorted = N_vals_sorted(valid_idx);
tempi_sorted = tempi_sorted(valid_idx);
errori_sorted = errori_sorted(valid_idx);
memorie_sorted = memorie_sorted(valid_idx);

% --- CREAZIONE DEI GRAFICI ---
figure('Name', 'Prestazioni MATLAB: Cholesky su Matrici Sparse', 'Position', [100, 100, 1200, 400]);

% Grafico 1: Tempo
subplot(1, 3, 1);
loglog(N_vals_sorted, tempi_sorted, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('Tempo di Risoluzione');
xlabel('Dimensione matrice (N)');
ylabel('Tempo (secondi)');
grid on;

% Grafico 2: Errore Relativo
subplot(1, 3, 2);
loglog(N_vals_sorted, errori_sorted, '-s', 'LineWidth', 2, 'MarkerFaceColor', 'r', 'Color', 'r');
title('Errore Relativo');
xlabel('Dimensione matrice (N)');
ylabel('Errore relativo');
grid on;

% Grafico 3: Memoria
subplot(1, 3, 3);
loglog(N_vals_sorted, memorie_sorted, '-^', 'LineWidth', 2, 'MarkerFaceColor', 'g', 'Color', 'g');
title('Incremento di Memoria RAM');
xlabel('Dimensione matrice (N)');
ylabel('Memoria (MB)');
grid on;

% --- SALVATAGGIO DATI IN CSV ---
nomi_sorted = matrici_names(idx); % Riordina usando gli indici del sort
nomi_sorted = strrep(nomi_sorted(valid_idx)', '.mat', ''); % Filtra i validi e traspone in colonna

% Creazione della tabella riassuntiva
risultati_tabella = table(nomi_sorted, N_vals_sorted, tempi_sorted, errori_sorted, memorie_sorted, ...
    'VariableNames', {'Matrice', 'Dimensione (N)', 'Tempo (s)', 'Errore relativo', 'Memoria (MB)'});

% Scrittura su file
if ispc
    nome_file_csv = 'risultati_matlab_windows.csv';
else
    nome_file_csv = 'risultati_matlab_linux.csv';
end

% ottieni la cartella genitore della current folder
parentFolder = fileparts(pwd);

folderName = 'results';

if ~isfolder(fullfile(parentFolder, folderName))
    mkdir(parentFolder, folderName);
end

% costruisci il percorso alla sottocartella results nella cartella genitore
folder = fullfile(parentFolder, folderName);

writetable(risultati_tabella, fullfile(folder, nome_file_csv));

fprintf('\nI risultati sono stati salvati con successo nel file: %s\n', nome_file_csv);