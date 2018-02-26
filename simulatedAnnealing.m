%*****************************************************************
%*                                                               *
%*   Recocido: Una implemetación de recocido simulado en MATLAB  *
%*                                                               *
%*   Copyright (c) Derechos Reservados                           *
%*   Carlos Salvador Garza Garza                                 *
%*   Elías Arif Mera Ávila                                       *
%*   carlos.gza94@gmail.com                                      *
%*                                                               *
%*****************************************************************

%% Recocido Simulado
function [G] = simulatedAnnealing(G, maxiEdge)    
    % Inicializa variables globales
    global maxEdgeSize minNeededEdges mejorRespuestaGrafo mejorRespuestaCosto;
    mejorRespuestaCosto = 10000000;
    maxEdgeSize = maxiEdge;
    minNeededEdges = 1000000;
    
    graficaSteiner('g', G)
    
    % Valores iniciales
    Gu = G;
    maxIntentos = 1500;
    maxIntentosAc = 150;
    c = 5;
    alpha = 0.95;
    beta = 1.3;
        
    % Temperatura inicial
    [c] = temperaturaInicial(Gu, c, maxIntentos, maxIntentosAc, beta, alpha);
    fprintf('Temperatura inicial: %7.7f\n', c);

    % Cadena de Markov
    Gu = G;
    totalAc = 0;
    imprimeRate = 0;
    while c > 0.001
        [Gu, ~, totalTemp] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
        c = alpha * c;
        totalAc = totalAc + totalTemp;
        
        if imprimeRate == 50
            graficaSteiner('g', mejorRespuestaGrafo)
            fprintf('Temperatura actual: %7.7f\n', c);
            imprimeRate = 0;
        end
        imprimeRate = imprimeRate + 1;
    end
    G = mejorRespuestaGrafo;
end

%% Cadenas de MArkov
function [Gu, rateAc, totalAc] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc)
    intentos = 0;
    intentosAc = 0;
    while intentos < maxIntentos && intentosAc < maxIntentosAc
        Gv = generaVecino1(Gu);
        
        fv = funcionEvaluadora(Gv);
        fu = funcionEvaluadora(Gu);
        
        if fv <= fu
            Gu = Gv;
            intentosAc = intentosAc + 1;
        elseif rand < exp( - (fv - fu) / c)
            Gu = Gv;
            intentosAc = intentosAc + 1;
        end
        intentos = intentos + 1;
    end
    
    rateAc = intentosAc / intentos;
    totalAc = intentosAc;
end


function [Gv] = generaVecino2(Gu)
    global maxEdgeSize minNeededEdges;
    
    possibleEdges = 1:maxEdgeSize;
    sizeG = size(Gu, 2);
    notInGu = setdiff(possibleEdges, Gu); % vector with edges not in G
    
    if sizeG == 0 % Agregar
        % Agrega edge
        Gu = [Gu datasample(notInGu, 1)];
    elseif sizeG >= minNeededEdges % Quitar edge
        Gu = datasample(Gu, sizeG-1, 'Replace', false);
    else
        if rand < 0.5 % Agregar
            % Agrega edge
            Gu = [Gu datasample(notInGu, 1)];
        else
            % Quita edge
            Gu = datasample(Gu, sizeG-1, 'Replace', false);
        end
    end 

    Gv = Gu;
end

%% Temperatura inicial
function [c] = temperaturaInicial(Gu, c, maxIntentos, maxIntentosAc, beta, alpha)
    [~, ac] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
    while ac < alpha
        c = beta * c;
        [~, ac, ~] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
    end
end