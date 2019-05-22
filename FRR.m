function FRR1 = FRR(dstn, threshold, idxx, true)

FRR1 = zeros(threshold + 1, 1);  
th = 0: threshold;
for i = 1: length(th)
    for j = 1: size(idxx, 1)
        % choose distance as the threshold
        if dstn(j, 1) <= th(i) && idxx(j, 1) == true(j)
            FRR1(i) = FRR1(i) + 1;
        end
    end
end

FRR1 = FRR1 ./ size(idxx, 1);
end

