function [dh, dv] = calc_distance(x,y)

x_pos = [(x<10) (x<11) (x<12)];
y_pos = [(y>-5) (y>-6) (y>-7)];

for i=1:3
    if(x_pos(i) == 1 && y_pos(i) == 0)
        dh = NaN;
        dv = NaN;
        return;
    end
end

sumX = sum(x_pos);
sumY = sum(y_pos);

switch sumX
    case 3
        dh = -5;
        dv = y+7;
    case 2
        dv = y+6;
        if(sumY == 3)
            dh = -5;
        else
            dh = 12-x;
        end
    case 1
        dv = y+5;
        if(sumY == 3)
            dh = -5;
        elseif(sumY == 2)
            dh = 12-x;
        else 
            dh = 11-x;
        end
    case 0 
        dv = y;
        if (sumY == 3)
            dh = -5;
        elseif(sumY == 2)
            dh = 12-x;
        elseif(sumY == 1)
            dh = 11-x;
        else
            dh = 10-x;
        end
end


dh = min(1, dh)
dv = min(1, dv)