function [ini fin] = rango_util(thsps,ask_t)

if nargin == 1
    ask_t = 1;
end

[fils N p] = size(thsps);
PASO = 15;
desvios = zeros(N-PASO+1,1);
dvIdx = 1;
% Desvios locales
for k = 1:N-PASO+1
    d = std(thsps(:,k:min(k+PASO-1,N),:),0,2);
    d = mean(d,3);
    desvios(dvIdx) = mean(d);
    dvIdx = dvIdx + 1;
end

save ResulDesvios desvios

% Threshold
if ask_t
    figure, plot(desvios)
    t = input('Ingrese el valor de umbral:');
else
    t = (max(desvios)+3*min(desvios))/4;
end
st = desvios < t;



% Búsqueda de inicio y fin del valle más largo
ini = 0;
fin = 0;

% Si el umbral se pone en 0 entonces devuelve ambos valores en 0
if t
    
    in = 0;
    fi = 0;
    flag_Contando = 0;
    for k = 1:N-PASO+1
        if st(k)==1
            fi = k;
            if flag_Contando == 0
                in = k;
                flag_Contando = 1;
            end
        else
            if flag_Contando == 1
                flag_Contando = 0;
                if (fi-in) > (fin-ini)
                    fin = fi;
                    ini = in;
                end
            end
        end
    end
    if flag_Contando == 1
        flag_Contando = 0;
        if (fi-in) > (fin-ini)
            fin = fi;
            ini = in;
        end
    end
    if fin == N-PASO+1
        fin = N;
    else
        fin = fin + floor(PASO/3);
    end
    if ini ~= 1
        ini = ini + floor(PASO/3);
    end
    
end