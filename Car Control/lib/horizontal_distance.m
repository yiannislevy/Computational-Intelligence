function dh = horizontal_distance(x, y)
    dh = 0;
    if (x <= 10)
        if (y >= -5)
            dh = 10 - x;
        elseif (y >= -6)
            dh = 11 - x;
        elseif (y >= -7)
            dh = 12 - x;
        else
            dh = 16 - x;
        end
    elseif (x <= 11)
        if (y >= -6)
            dh = 11 - x;
        elseif (y >= -7)
            dh = 12 - x;
        else
            dh = 16 - x;
        end
    elseif (x <= 12)
        if (y >= -7)
            dh = 12 - x;
        else
            dh = 16 - x;
        end
    elseif (x <= 15)
        dh = 16 - x;
    end

    if (dh > 1)
        dh = 1;
    end
end