%% Funcion que hace una evaluacion del estado que se le de. 
function [costo] = funcionEvaluadora(G)
    global minNeededEdges mejorRespuestaCosto mejorRespuestaGrafo;
    [costoTotal, conectividad] = costoSteiner(G);
    
    % Guardamos el mejor resultado hasta el momento
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