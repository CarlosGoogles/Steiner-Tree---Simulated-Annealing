%% Funcion de vencidad
% Da preferencia a estados mas cercanos a la respuesta mas correcta,
%   buscando a la izquierda de la grafica teorica
function [Gv] = generaVecino2(Gu)
    global maxEdgeSize minNeededEdges;
    
    possibleEdges = 1:maxEdgeSize;
    sizeG = size(Gu, 2);
    notInGu = setdiff(possibleEdges, Gu); % vector with edges not in G
    
    if sizeG == 0 % Agregar
        % Agrega edge
        Gu = [Gu datasample(notInGu, 1)];
    elseif sizeG == maxEdgeSize % Quitar
        % Quita edge
        Gu = datasample(Gu, sizeG-1, 'Replace', false);
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