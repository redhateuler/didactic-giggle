function pos = bin(r, x, i, l)
%La function utilizza un procedimento ricorsivo per la ricerca
%dell'appartenenza di un elemento in un array unidimensionale che contiene
%gli estremi di vari intervalli continui sulla retta reale.
%N.B.: The array must be already sorted before perfoming binary search on
%it. Consider casting a sorting algorithm on it.
pos = floor((i + l)/2);
if r >= x(pos) && r <= x(pos+1) 
    return
else
    if r > x(pos+1)
        pos = bin(r, x, pos+1, l);
    else
        pos = bin(r, x, i, pos);
    end
end
end
