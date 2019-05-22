function FAR1 = FAR(dstn, threshold, idxx, true)

FAR1 = zeros(threshold + 1, 1);   
th = 0: threshold;
ttl = length(th);
for i = 1: ttl
    for j = 1: size(idxx, 1)
        % choose distance as the threshold
        if dstn(j, 1) > th(i) && idxx(j, 1) ~= true(j)
            FAR1(i) = FAR1(i) + 1;
        end
    end
end

FAR1 = FAR1 ./ ttl;
end

