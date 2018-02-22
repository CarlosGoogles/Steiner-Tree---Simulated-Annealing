global maxEdgeSize  minNeededEdges

function [G] = simulatedAnnealing(G)
    Gu = G;
    maxIntentos = 100;
    maxIntentosAc = 20;
    c = 5;
    alpha = 0.98;
    
    %% Temperatura inicial
    beta = 1.5;
    [~, ac] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
    while ac < 0.98
        c = beta * c;
        [~, ac, ~] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
    end
    
    %% Cadena de Markov
    totalAc = 0;
    while totalAc < 300 && c > 0.1
        [Gu, ~, totalTemp] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
        c = alpha * c;
        totalAc = totalAc + totalTemp;
    end
end


function [costo] = funcionEvaluadora(G)
    [costoTotal,conectividad] = costoSteiner(G);
    costo = costoTotal / conectividad ^ 10;
end


function [Gu, rateAc, totalAc] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc)
    while intentos < maxIntentos && intentosAc < maxIntentosAc
        Gv = generaVecino(Gu);

        fv = funcionEvaluadora(Gv);
        fu = funcionEvaluadora(Gu);

        if fv < fu
            Gu = Gv;
            intentosAc += 1;
        elseif rand < exp( - (fv - fu) / c)
            Gu = Gv;
            intentosAc += 1;
        end
        intentos += 1;
    end
    
    rateAc = intentosAc / intentos;
    totalAc = intentosAc;
end

function [Gv] = generaVecino(Gu)
    possibleEdges = 1:58;
    sizeG = size(Gu, 2);
    notInGu = setdiff(possibleEdges, Gu); % vector with edges not in G
    if rand < 0.5 % Agregar
        if sizeG < minNeededEdges - 1
            % Agrega edge
            Gu = [Gu datasample(notInGu, 1)];
        elseif rand < ((minNeededEdges - 1) / sizeG) ^ 1.3
            % Agrega edge
            Gu = [Gu datasample(notInGu, 1)];
        else
            % Quita edge
            Gu = datasample(Gu, sizeG-1, 'Replace', false);
        end
    else % Quitar edge
        if sizeG > minNeededEdges - 1
            % Quitar edge
            Gu = datasample(Gu, sizeG-1, 'Replace', false);
        elseif rand < ((minNeededEdges - 1) / sizeG) ^ 1.3
            % Quita edge
            Gu = datasample(Gu, sizeG-1, 'Replace', false);
        else
            % Agrega edge
            Gu = [Gu datasample(notInGu, 1)];
        end
    end

    Gv = Gu;
end