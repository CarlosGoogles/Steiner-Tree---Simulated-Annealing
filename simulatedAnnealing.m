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
    costo = costoTotal / conectividad ^ 3;
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




end