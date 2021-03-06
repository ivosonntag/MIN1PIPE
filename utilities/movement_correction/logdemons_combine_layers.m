function [xffn, ldfn, idfn] = logdemons_combine_layers(xfcomb, ldcomb, idcomb)
% combine motion field and affine transforms of each hierarchical layers
%   Jinghao Lu, 01/02/2018

    %%% loop through all levels of graph %%%
    nn = length(idcomb) - 1;
    if nn >= 0 %%% there is cluster combination %%%
        
        xffn = xfcomb{1};
        ldfn = ldcomb{1};
        idfn = idcomb{1};

        for i = 1: nn
            %%%% update transform matrix %%%%
            idold = idfn;
            idcur = idcomb{i + 1};
            xfcur = xfcomb{i + 1};
            ldcur = ldcomb{i + 1};
            idxfcur = find(~cellfun(@isempty, xfcur));
            for j = 1: length(idxfcur)
                idtc = idxfcur(j);
                idto = idold{idtc};
                for k = 1: length(idto)
                    xffn{idto(k)} = [xffn{idto(k)}, xfcur{idtc}];
                    ldfn{idto(k)} = [ldfn{idto(k)}, ldcur{idtc}];
                end
            end
            
            %%%% update identity within each cluster %%%%
            temp = cell(1, length(idcur));
            for j = 1: length(idcur)
                idtc = idcur{j};
                temp2 = [];
                for k = 1: length(idtc)
                    temp2 = [temp2; idfn{idtc(k)}];
                end
                temp{j} = temp2;
            end
            idfn = temp;
        end
    else %%% no cluster combination %%%
        xffn = {};
        ldfn = {};
        idfn = {};
    end
end