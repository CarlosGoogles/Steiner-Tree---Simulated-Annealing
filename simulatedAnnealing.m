function [G] = simulatedAnnealing(G, maxiEdge)
    global maxEdgeSize minNeededEdges mejorRespuestaGrafo mejorRespuestaCosto;
    mejorRespuestaCosto = 10000000;
    maxEdgeSize = maxiEdge;
    minNeededEdges = 1000000;
    Gu = G;
    maxIntentos = 1500;
    maxIntentosAc = 150;
    c = 5;
    alpha = 0.95;
    
    funcionEvaluadora(Gu)
    
    %% Temperatura inicial
    beta = 1.3;
    [~, ac] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
    while ac < alpha
        c = beta * c;
        [~, ac, ~] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
    end
    
    %% Cadena de Markov
    totalAc = 0;
    imprimeRate = 0
    while c > 0.1
        [Gu, ~, totalTemp] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc);
        c = alpha * c;
        totalAc = totalAc + totalTemp;
        
        if imprimeRate == 40
            clf
            graficaSteiner('g',mejorRespuestaGrafo)
            [costoTotal,conectividad] = costoSteiner(Gu);
            title(sprintf('costoTotal=%f conectividad=%f',costoTotal,conectividad))
            imprimeRate = 0;
            pause(1);
        end
        imprimeRate = imprimeRate + 1;
    end
    %(
    disp (Gu)
    disp (maxEdgeSize)
    disp (minNeededEdges)
    %)
    G = mejorRespuestaGrafo;
end

function [costo] = funcionEvaluadora(G)
    global minNeededEdges mejorRespuestaCosto mejorRespuestaGrafo;
    [costoTotal, conectividad] = costoSteiner(G);
    
    if conectividad == 1
        if size(G) < minNeededEdges
            minNeededEdges = size(G);
        end
        if costoTotal < mejorRespuestaCosto
           mejorRespuestaCosto = costoTotal;
           mejorRespuestaGrafo = G;
        end
    end 
    
    costo = costoTotal / (conectividad ^ 20);
end


function [Gu, rateAc, totalAc] = cadenaMarkov(Gu, c, maxIntentos, maxIntentosAc)
    intentos = 0;
    intentosAc = 0;
    while intentos < maxIntentos && intentosAc < maxIntentosAc
        Gv = generaVecino1(Gu);

        fv = funcionEvaluadora(Gv);
        fu = funcionEvaluadora(Gu);

        if fv < fu
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

function [Gv] = generaVecino1(Gu)
    global maxEdgeSize minNeededEdges;
    
    possibleEdges = 1:maxEdgeSize;
    sizeG = size(Gu, 2);
    notInGu = setdiff(possibleEdges, Gu); % vector with edges not in G
    if sizeG == 0 % Agregar
        % Agrega edge
        Gu = [Gu datasample(notInGu, 1)];
    elseif rand < 0.5 % Agregar
        if sizeG < minNeededEdges - 1
            % Agrega edge
            Gu = [Gu datasample(notInGu, 1)];
        elseif rand < ((minNeededEdges - 1) / sizeG) .^ 1.3
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
        elseif rand < ((minNeededEdges - 1) / sizeG) .^ 1.5
            % Quita edge
            Gu = datasample(Gu, sizeG-1, 'Replace', false);
        else
            % Agrega edge
            Gu = [Gu datasample(notInGu, 1)];
        end
    end

    Gv = Gu;
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