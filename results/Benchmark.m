% Generazione dei grafici comparativi da file CSV
clear; clc; close all;

% --- FORZA SFONDO BIANCO GLOBALE (Finestre e interno grafici) ---
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');

% --- 1. DEFINIZIONE LETTURA CSV ---
file_mw = 'risultati_matlab_windows.csv';
file_ml = 'risultati_matlab_linux.csv';
file_pw = 'risultati_python_windows.csv';
file_pl = 'risultati_python_linux.csv';

% Controllo esistenza file
if ~isfile(file_mw) || ~isfile(file_ml) || ~isfile(file_pw) || ~isfile(file_pl)
    error('Assicurati di avere tutti e 4 i file CSV nella cartella results!');
end

% Lettura tabelle
tab_mw = readtable(file_mw);
tab_ml = readtable(file_ml);
tab_pw = readtable(file_pw);
tab_pl = readtable(file_pl);

% --- 2. ESTRAZIONE DATI ---
% MATLAB Windows
N_mw   = tab_mw.Dimensione_N_;
t_mw   = tab_mw.Tempo_s_;
err_mw = tab_mw.ErroreRelativo;
mem_mw = tab_mw.Memoria_MB_;
% MATLAB Linux
N_ml   = tab_ml.Dimensione_N_;
t_ml   = tab_ml.Tempo_s_;
err_ml = tab_ml.ErroreRelativo;
mem_ml = tab_ml.Memoria_MB_;
% Python Windows
N_pw   = tab_pw.Dimensione_N_;
t_pw   = tab_pw.Tempo_s_;
err_pw = tab_pw.ErroreRelativo;
mem_pw = tab_pw.Memoria_MB_;
% Python Linux
N_pl   = tab_pl.Dimensione_N_;
t_pl   = tab_pl.Tempo_s_;
err_pl = tab_pl.ErroreRelativo;
mem_pl = tab_pl.Memoria_MB_;

% --- 3. STILI GRAFICI E DIMENSIONI ---
st_mw = '-sb'; % MATLAB Windows: Linea blu, quadrati
st_ml = '-og'; % MATLAB Linux: Linea verde, cerchi
st_pw = '-sr'; % Python Windows: Linea rossa, quadrati
st_pl = '-om'; % Python Linux: Linea gialla, cerchi

dim_figura = [100, 100, 800, 600]; % Finestra larga singola

% =========================================================================
%% SCENARIO 1: MATLAB - Windows
% =========================================================================
figure('Name', 'MATLAB Windows - Tempo', 'Position', dim_figura);
semilogy(N_mw, t_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('MATLAB (Windows): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Tempo (secondi)'); grid on;
exportgraphics(gcf, 'matlab_windows_tempo.png', 'Resolution', 300);

figure('Name', 'MATLAB Windows - Errore', 'Position', dim_figura);
semilogy(N_mw, err_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('MATLAB (Windows): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Errore relativo'); grid on;
exportgraphics(gcf, 'matlab_windows_errore.png', 'Resolution', 300);

figure('Name', 'MATLAB Windows - Memoria', 'Position', dim_figura);
semilogy(N_mw, mem_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('MATLAB (Windows): Incremento di Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Memoria (MB)'); grid on;
exportgraphics(gcf, 'matlab_windows_memoria.png', 'Resolution', 300);

% =========================================================================
%% SCENARIO 2: PYTHON - Windows
% =========================================================================
figure('Name', 'Python Windows - Tempo', 'Position', dim_figura);
semilogy(N_pw, t_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Python (Windows): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Tempo (secondi)'); grid on;
exportgraphics(gcf, 'python_windows_tempo.png', 'Resolution', 300);

figure('Name', 'Python Windows - Errore', 'Position', dim_figura);
semilogy(N_pw, err_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Python (Windows): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Errore relativo'); grid on;
exportgraphics(gcf, 'python_windows_errore.png', 'Resolution', 300);

figure('Name', 'Python Windows - Memoria', 'Position', dim_figura);
semilogy(N_pw, mem_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Python (Windows): Incremento di Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Memoria (MB)'); grid on;
exportgraphics(gcf, 'python_windows_memoria.png', 'Resolution', 300);

% =========================================================================
%% SCENARIO 3: MATLAB - Linux
% =========================================================================
figure('Name', 'MATLAB Linux - Tempo', 'Position', dim_figura);
semilogy(N_ml, t_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g');
title('MATLAB (Linux): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Tempo (secondi)'); grid on;
exportgraphics(gcf, 'matlab_linux_tempo.png', 'Resolution', 300);

figure('Name', 'MATLAB Linux - Errore', 'Position', dim_figura);
semilogy(N_ml, err_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g');
title('MATLAB (Linux): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Errore relativo'); grid on;
exportgraphics(gcf, 'matlab_linux_errore.png', 'Resolution', 300);

figure('Name', 'MATLAB Linux - Memoria', 'Position', dim_figura);
semilogy(N_ml, mem_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g');
title('MATLAB (Linux): Incremento di Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Memoria (MB)'); grid on;
exportgraphics(gcf, 'matlab_linux_memoria.png', 'Resolution', 300);

% =========================================================================
%% SCENARIO 4: PYTHON - Linux
% =========================================================================
figure('Name', 'Python Linux - Tempo', 'Position', dim_figura);
semilogy(N_pl, t_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Python (Linux): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Tempo (secondi)'); grid on;
exportgraphics(gcf, 'python_linux_tempo.png', 'Resolution', 300);

figure('Name', 'Python Linux - Errore', 'Position', dim_figura);
semilogy(N_pl, err_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Python (Linux): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Errore relativo'); grid on;
exportgraphics(gcf, 'python_linux_errore.png', 'Resolution', 300);

figure('Name', 'Python Linux - Memoria', 'Position', dim_figura);
semilogy(N_pl, mem_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Python (Linux): Incremento di Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione matrice (N)'); ylabel('Memoria (MB)'); grid on;
exportgraphics(gcf, 'python_linux_memoria.png', 'Resolution', 300);

% =========================================================================
%% SCENARIO 5: MATLAB - Windows vs Linux
% =========================================================================
figure('Name', 'MATLAB Win vs Lin - Tempo', 'Position', dim_figura);
semilogy(N_mw, t_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
semilogy(N_ml, t_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g');
title('MATLAB (Windows vs Linux): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_matlab_win_lin_tempo.png', 'Resolution', 300);

figure('Name', 'MATLAB Win vs Lin - Errore', 'Position', dim_figura);
semilogy(N_mw, err_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
semilogy(N_ml, err_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g');
title('MATLAB (Windows vs Linux): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('Windows', 'Linux', 'Location', 'best');
exportgraphics(gcf, 'confronto_matlab_win_lin_errore.png', 'Resolution', 300);

figure('Name', 'MATLAB Win vs Lin - Memoria', 'Position', dim_figura);
semilogy(N_mw, mem_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
semilogy(N_ml, mem_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g');
title('MATLAB (Windows vs Linux): Incremento Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_matlab_win_lin_memoria.png', 'Resolution', 300);

% =========================================================================
%% SCENARIO 6: PYTHON - Windows vs Linux
% =========================================================================
figure('Name', 'Python Win vs Lin - Tempo', 'Position', dim_figura);
semilogy(N_pw, t_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
semilogy(N_pl, t_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Python (Windows vs Linux): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_python_win_lin_tempo.png', 'Resolution', 300);

figure('Name', 'Python Win vs Lin - Errore', 'Position', dim_figura);
semilogy(N_pw, err_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
semilogy(N_pl, err_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Python (Windows vs Linux): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('Windows', 'Linux', 'Location', 'best');
exportgraphics(gcf, 'confronto_python_win_lin_errore.png', 'Resolution', 300);

figure('Name', 'Python Win vs Lin - Memoria', 'Position', dim_figura);
semilogy(N_pw, mem_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
semilogy(N_pl, mem_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Python (Windows vs Linux): Incremento Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_python_win_lin_memoria.png', 'Resolution', 300);

% =========================================================================
%% SCENARIO 7: LINUX - MATLAB vs Python
% =========================================================================
figure('Name', 'Linux MATLAB vs Python - Tempo', 'Position', dim_figura);
semilogy(N_ml, t_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g'); hold on;
semilogy(N_pl, t_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Ambiente Linux (MATLAB vs Python): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_linux_mat_py_tempo.png', 'Resolution', 300);

figure('Name', 'Linux MATLAB vs Python - Errore', 'Position', dim_figura);
semilogy(N_ml, err_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g'); hold on;
semilogy(N_pl, err_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Ambiente Linux (MATLAB vs Python): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('MATLAB', 'Python', 'Location', 'best');
exportgraphics(gcf, 'confronto_linux_mat_py_errore.png', 'Resolution', 300);

figure('Name', 'Linux MATLAB vs Python - Memoria', 'Position', dim_figura);
semilogy(N_ml, mem_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'g'); hold on;
semilogy(N_pl, mem_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'm');
title('Ambiente Linux (MATLAB vs Python): Incremento Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_linux_mat_py_memoria.png', 'Resolution', 300);

% =========================================================================
%% SCENARIO 8: WINDOWS - MATLAB vs Python
% =========================================================================
figure('Name', 'Windows MATLAB vs Python - Tempo', 'Position', dim_figura);
semilogy(N_mw, t_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
semilogy(N_pw, t_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Ambiente Windows (MATLAB vs Python): Tempo di Risoluzione', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_windows_mat_py_tempo.png', 'Resolution', 300);

figure('Name', 'Windows MATLAB vs Python - Errore', 'Position', dim_figura);
semilogy(N_mw, err_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
semilogy(N_pw, err_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Ambiente Windows (MATLAB vs Python): Errore Relativo', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('MATLAB', 'Python', 'Location', 'best');
exportgraphics(gcf, 'confronto_windows_mat_py_errore.png', 'Resolution', 300);

figure('Name', 'Windows MATLAB vs Python - Memoria', 'Position', dim_figura);
semilogy(N_mw, mem_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
semilogy(N_pw, mem_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Ambiente Windows (MATLAB vs Python): Incremento Memoria RAM', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');
exportgraphics(gcf, 'confronto_windows_mat_py_memoria.png', 'Resolution', 300);