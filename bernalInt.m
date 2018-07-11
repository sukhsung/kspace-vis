numStack = 1:100;
stacking = '';
relin = [];
for n = numStack
    if rem(n,2) == 1
        stacking = [stacking,'A'];
    else
        stacking = [stacking,'B'];
    end
    relin = [relin,f2f1(stacking)];
end

figure
subplot(3,1,1)
plot(numStack,relin)
title('ABABAB...')

stacking = '';
relin = [];
for n = numStack
    if rem(n,3) == 1
        stacking = [stacking,'A'];
    elseif rem(n,3) == 2
        stacking = [stacking,'B'];
    else
        stacking = [stacking,'C'];
    end
    relin = [relin,f2f1(stacking)];
end

subplot(3,1,2)
plot(numStack,relin)
title('ABCABCABC...')

stacking = '';
numIt = 100000;
relin_it = zeros(numIt,numel(numStack));
for it = 1:numIt
	relin = [];
    for n = numStack
        rn = rand;
        if n == 1
            stacking = [stacking,'A'];
        else
            if strcmp(stacking(numel(stacking)),'A')
                if rn<1/2
                    stacking = [stacking,'B'];
                else
                    stacking = [stacking,'C'];
                end
            elseif strcmp(stacking(numel(stacking)),'B')
                if rn<1/2
                    stacking = [stacking,'A'];
                else
                    stacking = [stacking,'C'];
                end
            elseif strcmp(stacking(numel(stacking)),'C')
                if rn<1/2
                    stacking = [stacking,'A'];
                else
                    stacking = [stacking,'B'];
                end
            end



        end
        relin = [relin,f2f1(stacking)];
    end
    relin_it(it,:) = relin;
end
subplot(3,1,3)
plot(numStack,relin)
title(stacking)

plot(mean(relin_it,1))