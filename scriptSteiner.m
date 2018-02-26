%% �rboles rectil�neos de Steiner
%
% Este script muestra el uso de las funciones inicializaSteiner,
% graficaSteiner, y costoSteiner.
%
% Manuel Valenzuela
% 29 octubre 2014

clc;
%% Datos
% Coordenadas de los datos originales
C = [0 6;0.5 0;2 5;4 8;2 3;1 6;2 9;4 0;4 15];
% C = [2 2; 11 7; 0 1; 3 0; 5 2; 11 1; 7 9; 6 2; 6 1; 1 8];

% Inicializa Steiner obtiene los datos de todos los nodos y aristas
%   posibles.
[xC, yC, P, ind, A, T] = inicializaSteiner(C);

% Grafo que se desea graficar
% G = [];
G = [1:size(T, 1)];

% Se inicializan datos de gr�fica
graficaSteiner('i', xC, yC, P, ind ,A, T);

% Se inicializan datos para calcular el costo
costoSteiner(A, P, ind);

clf;

params.cadIntAcep = 20;
params.cadInt = 200;
params.maxCad = 10;
params.frecImp = 5000;
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


totalCorridas = 10;
propio = 0;

if propio == 1 % Implementacion de Carlos y Elias
    [G] = simulatedAnnealing(params.x0, params.maxSize);
    graficaSteiner('s', G);
else % Implementacion del profesor Valenzuela
    graf = [];
    corridas = 1;
    minCorridas = 1000000000;
    
    while corridas <= totalCorridas
        fprintf('Corrida #%d:\n', corridas);
        [r] = recocido(params);
        graf = [graf; r];
        corridas = corridas + 1;
        if minCorridas > size(r.intentos, 1)
            minCorridas = size(r.intentos, 1);
        end
    end
    
    corridas = 1;
    
    curva.prom = [];
    curva.desv = [];
    for i= 1:minCorridas
        prom = 0;
        desv = 0;
        for j= 1:totalCorridas
            prom = prom + graf(j).f(i);
        end
        prom = prom / totalCorridas;
        
        for j= 1:totalCorridas
            desv = desv + (prom - graf(j).f(i)) ^ 2;
        end
        desv = sqrt(desv / (totalCorridas - 1)) ;
        curva.prom = [curva.prom; prom];
        curva.desv = [curva.desv; desv];
    end 
    
    figure
    PLOT = [curva.prom'; (curva.prom + curva.desv)'; (curva.prom - curva.desv)']';
    plot(PLOT, 'b');
end

