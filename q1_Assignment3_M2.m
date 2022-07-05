%%Taking the input
clc;
clear all;
%p=input('Enter text to be encoded- ');
p=fileread('engish text assignment 3.txt');
disp('Input String- ');
disp(p);
Input_String=p;
len=length(p);
disp(['Length of input string is- ',num2str(len)]);

res1=[];
for k=1:len
    if(p(k)==' ')ascii='11111';
    else
        ascii=dec2bin(double(char(p(k)))-97,5);
    end
    res1=[res1 ascii];
end
result=[];
for k=1:length(res1)
    result=[result ((res1(k))-'0')];
end

%disp('Encoded Message=');
%disp(result);
%%
%Encoding
Cl = length(res1); %Code Length Given length of bitstream
x=result;
idxes=1;
%(9,5) Linear Block Code
n=9;
k=5;
p=n-k;
id=eye(k);
lbcode=[];
for itrs=1:Cl/5
    indv=[];
    for l=1:5
        indv(end+1)=x(idxes);
        idxes=idxes+1;
    end
    temp=[ones(1,k-1) zeros(k-length(ones(1,k-1)))];
    parity=[temp;];
    %parity bit calculation
    %for example (6,3)
    %p1 = d1 xor d2
    %p2 = d2 xor d3
    %p3 = d3 xor d1
    for i=1:n-k-1
        temp1=temp(k);
        for j=k:-1:2
            temp(j)=temp(j-1);
        end
        temp(1)=temp1;
        parity=[parity;temp];
    end
    parity=parity';
    generator=[parity id];
    data=indv;
    tcode=[];
    tcode=[tcode;mod(data(1,:)*generator,2)];
    lbc=[];
    lbc=lbcode;
    lbcode=[lbc tcode];
end
%lbcode;
[r c]=size(lbcode);
%%
%Passing the encoded data through Binary Symmetric Channel
ndata = bsc(lbcode,0.25);

%%
%Decoding
idxes=1;
cmp=1;
match=0;
decoded=[];
res1="";
Final="";
for l=1:c/9
    indv=[];
    for l2=1:9
        indv(end+1)=ndata(idxes);
        idxes=idxes+1;
    end
    rcode=indv;
    validcode=rcode;
    decoded=[decoded validcode((n-k+1):n)];
    
    xyz=validcode((n-k+1):n);
    String_encoded="";
    for l3=1:5
        String_encoded=String_encoded+string(xyz(l3));
    end
    if(String_encoded=='11111')
        res1=' ';
    else
        res1=char(bin2dec(String_encoded)+97);
    end
    if length(Input_String)>=cmp && Input_String(cmp)==res1
        match=match+1;
    end
    cmp=cmp+1;
    Final=Final+res1;
end

disp([newline,'String after Decoding-'])
disp(Final);
disp([newline,'Numbers of characters matched with the input string- ',num2str(match)]);
%disp(match);
%%
%Error Calculation
[numerrs, pcterrs] = biterr(result,decoded); % Number and percentage of errors
disp(['Total number of error bits - ',num2str(numerrs)]);
%disp(numerrs);
disp(['Percentage of error bits - ',num2str(pcterrs*100)]);
%disp(pcterrs*100);