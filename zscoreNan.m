function zArray=zscoreNan(array)
arrayMean=mean(array(isnan(array)==0));
arraySD=std(array(isnan(array)==0));
zArray=(array-arrayMean)/arraySD;
end  