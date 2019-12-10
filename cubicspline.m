function spval = cubicspline(xdata, ydata, zval)
%Author: Antonio Sorrentino Last mod.: 12/10/2019
%Purpose: cubicspline solves a tridiagonal system in order to obtain the
%natural cubic spline of a set of points in the plane.
%Input: 
%xdata: the x-coordinates of points in the plane;
%ydata: the y-coordinates of points in the plane;
%zval: the points on the x-axis that are going to be used to evaluate our
%cubic spline interpolation.
%Output:
%spval: the y-coordinates of zval points (their evaluation for our spline).
%
    %inizitializing vector h, which stores the distances between the points
    %of xdata
    h = zeros(1, length(xdata) -1);
    for k = 1: length(xdata)-1
        h(k) = xdata(k+1)-xdata(k);
    end
    
    %building the tridiagonal matrix A
    A = zeros(length(xdata));
    for i = 1:length(xdata)
       for j = 1: length(xdata)
           if i == j
               if i == 1 || i == length(xdata)
                   A(i, j) = 1;
               else
                   A(i, j) = 2*(h(j-1)+h(j));
                   A(i, j-1) = h(j-1);
                   A(i, j+1) = h(j);
               end
           else
               if j ~= i+1 && j~= i-1
                   A(i, j) = 0;
               end
           end
       end
    end
    
    %building the vector of known coefficients used to solve the linear
    %system;
    b = zeros(1, length(xdata));
    for i = 1: length(xdata)
        if i == 1 || i == length(xdata)
            b(i) = 0;
        else
            b(i) = (3/h(i))*(ydata(i+1)-ydata(i))-(3/h(i-1))*(ydata(i)-ydata(i-1));
        end
    end
    
    %transposing b and solving the linear system, storing results in vector
    %c
    b = b';
    c = A\b;
    
    %initilizing vectors a, b_n, d that will be used along with c to
    %compute spval
    a = zeros(1, length(xdata)-1);
    for i = 1: length(xdata)-1
        a(i) = ydata(i);
    end
    
    b_n = zeros(1, length(xdata)-1);
    for i = 1: length(xdata)-1
        b_n(i) = (ydata(i+1)-ydata(i))/h(i) - (h(i)/3)*(c(i+1)+2*c(i));
    end
    
    d = zeros(1, length(xdata)-1);
    for i = 1: length(xdata)-1
        d(i) = (c(i+1)-c(i))/(3*h(i));
    end
    
    %computing spval
    spval = zeros(1, length(zval));
    for k = 1 : length(zval)
        p = bin(zval(k), xdata, 1, length(xdata));
        %bin is the recursive binary search implemented in another file
        spval(k) = d(p);
        for j = 1: 3
            if j == 1
                spval(k) = spval(k)*(zval(k)-xdata(p)) + c(p);
            else
                if j == 2
                    spval(k) = spval(k)*(zval(k)-xdata(p)) + b_n(p);
                else
                    spval(k) = spval(k)*(zval(k)-xdata(p)) + a(p);
                end
            end
        end
    end
end
