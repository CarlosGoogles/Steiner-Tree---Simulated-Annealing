%% Árboles rectilíneos de Steiner
%
% Este script muestra el uso de las funciones inicializaSteiner,
% graficaSteiner, y costoSteiner.
%
% Manuel Valenzuela
% 29 octubre 2014

clc;
%% Datos
% Coordenadas de los datos originales
% C = [0 6;0.5 0;2 5;4 8;2 3;1 6;2 9;4 0;4 15];
C = [2 2; 11 7; 0 1; 3 0; 5 2; 11 1; 7 9; 6 2; 6 1; 1 8];

% Inicializa Steiner obtiene los datos de todos los nodos y aristas
%   posibles.
[xC, yC, P, ind, A, T] = inicializaSteiner(C);

% Grafo que se desea graficar
% G = [];
G = [1:size(T, 1)];

% Se inicializan datos de gráfica
graficaSteiner('i', xC, yC, P, ind ,A, T);

% Se inicializan datos para calcular el costo
costoSteiner(A, P, ind);

clf;

params.cadIntAcep = 100;
params.cadInt = 1000;
params.maxCad = 10;
params.frecImp = 50;
params.x0 = G;
params.FcnObj = @funcionEvaluadora; % Ver en simulatedAnnealing.m
params.FcnVec = @generaVecino1;     % Ver en simulatedAnnealing.m
params.Imp = @graficaSteiner;       % Ver en simulatedAnnealing.m
params.variarC = 0;
params.alfa = 0.95;
params.beta = 1.3;
params.minRazAcep = 0.95;
params.min = 1;
params.maxSize = size(T, 1);
params.curvaDeMejora = 1;

totalCorridas = 100;
propio = 0;

if propio == 1 % Implementacion de Carlos y Elias
    [G] = simulatedAnnealing(params.x0, params.maxSize);
    graficaSteiner('s', G);
else % Implementacion del profesor Valenzuela
    plotRecocido(params, totalCorridas);
end

