
function [Gv] = generaVecino1(Gu)
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