function dv = vertical_distance(x, y)
    dv = 0;
    if (x <= 10)
        dv = -y;
    elseif (x <= 11)
        dv = 5 - y;
    elseif (x <= 12)
        dv = 6 - y;
    elseif (x <= 15)
        dv = 7 - y;
    end

    if (dv > 1)
        dv = 1;
    end
end