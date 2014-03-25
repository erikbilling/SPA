function d = eDist(w,p)

  dyx = w-repmat(p',size(w,1),1);
  d = sqrt(dyx(:,1).^2+dyx(:,2).^2);

end

