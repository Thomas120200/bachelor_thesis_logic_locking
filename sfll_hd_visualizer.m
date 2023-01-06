% enter the number of key bits / input bits (must be the same)
bitsize = 3;

% enter the hamming distance used, in the thesis referred to as 'h'
HD = 1;

% enter secret key used in decimal
secret_dec = 6;

% conversion of the key to binary
secret_bin = dec2bin(secret_dec,bitsize);

% define all possible input values in decimal and binary
IN_dec = [0:1:(2^bitsize)-1]';
IN_bin = dec2bin(IN_dec,bitsize);

% define all possible input key in decimal and binary
KEY_dec = [0:1:(2^bitsize)-1];
KEY_bin = dec2bin(KEY_dec,bitsize)';

% f(i,j) indicates wether the output for input i and key j is corrupted (1) or
% not (0)
f = zeros(2^bitsize, 2^bitsize);

% first set all lines of protected input patterns to 1
for i=1:1:2^bitsize
    if sum(abs(KEY_bin(:,i)-secret_bin')) == HD
        f(i,:)=1; % set entire line to 1
    end
end

for i=1:1:2^bitsize
    for j = 1:1:2^bitsize
        if sum(abs(KEY_bin(:,j)-KEY_bin(:,i))) == HD
            if f(j,i) == 0
                f(j,i) = 1; % if input pattern is not protected the RU will introduce an additional error
            else
                f(j,i)=0; % if input pattern is protected the RU will correct the error
            end
        end
    end
end

% plot a visuliazation of f
imagesc(f);
xlabel("key value");
ylabel("input pattern");

% calculate some metrics
num_protected = sum(f(1,:)==1)

num_erroneous_outputs = sum(f(:)==1)

expectancy_value_output_err = num_erroneous_outputs /(2^2^bitsize)

% check if output is corrupted or not for specific input-key pair
input = '01111011';
key = '000101101';
output_corrupted = f(bin2dec(input)+1,bin2dec(key)+1)
