function crpclean
%CRPCLEAN   Removes CRP Toolbox.
%    CRPCLEAN removes all files of CRP Toolbox from
%    the filesystem and its entry from the Matlab
%    startup file.
%    
%    This installation script was generated by using 
%    the MAKEINSTALL tool. For further information
%    visit http://matlab.pucicu.de

% Copyright (c) 2002-2006 by AMRON
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% Generation date: 29-Apr-2008 15:53:11
% $Date: 2008/02/25 12:32:53 $
% $Revision: 3.17 $

error(nargchk(0,0,nargin));

try
  warning('off')
  disp('----------------------------')
  disp('    REMOVING CRP Toolbox    ')
  disp('----------------------------')
  currentpath=pwd;
  oldtoolboxpath = fileparts(which(mfilename));

  disp(['  CRP Toolbox found in ', oldtoolboxpath,''])
  i = input('> Delete CRP Toolbox? Y/N [Y]: ','s');
  if isempty(i), i = 'Y'; end

  if strcmpi('Y',i)
%%%%%%% check for entries in startup
  
        p=path; i1=0; i = '';
  
        while findstr(upper('crptool'),upper(p)) > i1
           i1=findstr(upper('crptool'),upper(p));
           if ~isempty(i1)
               i1=i1(end);
               if isunix, i2=findstr(':',p); else, i2=findstr(';',p); end
               i3=i2(i2>i1);                 % last index pathname
               if ~isempty(i3), i3=i3(1)-1; else, i3=length(p); end
               i4=i2(i2<i1);                 % first index pathname
               if ~isempty(i4), i4=i4(end)+1; else, i4=1; end
               rmtoolboxpath=p(i4:i3);
%%%%%%% removing entry in startup-file
               rmpath(rmtoolboxpath)
               if i4>1, p(i4-1:i3)=''; else, p(i4:i3)=''; end
               startup_exist = exist('startup','file');
               if startup_exist
                    startupfile=which('startup');
                    startuppath=startupfile(1:findstr('startup.m',startupfile)-1);
                    instpaths=textread(startupfile,'%[^\n]');
                    k=1;
                    while k <= length(instpaths)
                        if ~isempty(findstr(rmtoolboxpath,instpaths{k}))
                            disp(['  Removing startup entry ', instpaths{k}])
                            instpaths(k)=[];
                        end
                        k=k+1;
                    end
                    fid=fopen(startupfile,'w');
                    for i2=1:length(instpaths), 
                        fprintf(fid,'%s\n', char(instpaths(i2,:))); 
                    end
                    fclose(fid);
               end
           end
           p = path; i1 = 0;
       end
%%%%%%% removing old paths
        if exist(oldtoolboxpath,'dir') == 7
           disp(['  Removing files in ',oldtoolboxpath,''])
           cd(oldtoolboxpath)
           dirnames='';filenames='';
           temp='.:';
           while ~isempty(temp)
               [temp1 temp]=strtok(temp,':');
               if ~isempty(temp1)
                   dirnames=[dirnames; {temp1}];
                   x2=dir(temp1);
                   for i=1:length(x2)
                       if ~x2(i).isdir, filenames=[filenames; {[temp1,'/', x2(i).name]}]; end
         	             if x2(i).isdir & ~strcmp(x2(i).name,'.') & ~strcmp(x2(i).name,'..'), temp=[temp,temp1,filesep,x2(i).name,':']; end
                   end
               end
           end
           dirnames = strrep(dirnames,['.',filesep],'');
           dirnames(strcmpi('.',dirnames)) = [];
           l = zeros(length(dirnames),1); for i=1:length(dirnames),l(i)=length(dirnames{i}); end
           [i i4]=sort(l); i4 = i4(:);
           dirnames=dirnames(flipud(i4));
           for i=1:length(dirnames)
              delete([dirnames{i}, filesep,'*'])
              if exist('rmdir') == 5 & exist(dirnames{i}) == 7, rmdir(dirnames{i},'s'), else, delete(dirnames{i}), end
              disp(['  Removing files in ',char(dirnames{i}),''])
           end
           if exist(currentpath), cd(currentpath), else, cd .., end
           if strcmpi(currentpath,oldtoolboxpath), cd .., end
           if exist('rmdir') == 5 & exist(oldtoolboxpath) == 7, rmdir(oldtoolboxpath,'s'), else, delete(oldtoolboxpath), end
           disp(['  Removing folder ',oldtoolboxpath,''])
        end
       disp(['  CRP Toolbox now removed.'])
  else
       disp(['  Nothing happened. Keep smiling.'])
  end
  tx=version; tx=strtok(tx,'.'); if str2double(tx)>=6 & exist('rehash','builtin'), rehash, end
  warning on
  if exist(currentpath,'dir') ~= 7, cd(fileparts(currentpath)), else, cd(currentpath), end
  
%%%%%%% error handling

catch
  x=lasterr;y=lastwarn;
  if ~strcmpi(lasterr,'Interrupt')
    if fid>-1, 
      try, z=ferror(fid); catch, z='No error in the installation I/O process.'; end
    else
      z='File not found.'; 
    end
    fid=fopen('deinstall.log','w');
    fprintf(fid,'%s\n','This script is under development and your assistance is');
    fprintf(fid,'%s\n','urgently welcome. Please inform the distributor of the');
    fprintf(fid,'%s\n','toolbox, where the error occured and send us the following');
    fprintf(fid,'%s\n','error report and the informations about the toolbox (distributor,');
    fprintf(fid,'%s\n','name etc.). Provide a brief description of what you were');
    fprintf(fid,'%s\n','doing when this problem occurred.');
    fprintf(fid,'%s\n','E-mail or FAX this information to us at:');
    fprintf(fid,'%s\n','    E-mail:  marwan@agnld.uni-potsdam.de');
    fprintf(fid,'%s\n','       Fax:  ++49 +331 977 1142');
    fprintf(fid,'%s\n\n\n','Thank you for your assistance.');
    fprintf(fid,'%s\n',repmat('-',50,1));
    fprintf(fid,'%s\n',datestr(now,0));
    fprintf(fid,'%s\n',['Matlab ',char(version),' on ',computer]);
    fprintf(fid,'%s\n',repmat('-',50,1));
    fprintf(fid,'%s\n','CRP Toolbox');
    fprintf(fid,'%s\n',x);
    fprintf(fid,'%s\n',y);
    fprintf(fid,'%s\n',z);
    fclose(fid);
    disp('----------------------------');
    disp('       ERROR OCCURED ');
    disp('   during deinstallation');
    disp('----------------------------');
    disp(x);
    disp(z);
    disp('----------------------------');
    disp('   This script is under development and your assistance is ')
    disp('   urgently welcome. Please inform the distributor of the')
    disp('   toolbox, where the error occured and send us the error')
    disp('   report and the informations about the toolbox (distributor,')
    disp('   name etc.). For your convenience, this information has been')
    disp('   recorded in: ')
    disp(['   ',fullfile(pwd,'deinstall.log')]), disp(' ')
    disp('   Provide a brief description of what you were doing when ')
    disp('   this problem occurred.'), disp(' ')
    disp('   E-mail or FAX this information to us at:')
    disp('       E-mail:  marwan@agnld.uni-potsdam.de')
    disp('          Fax:  ++49 +331 977 1142'), disp(' ')
    disp('   Thank you for your assistance.')
  end
  warning('on')
  if exist(currentpath,'dir') == 7, cd(fileparts(currentpath)), else, cd(currentpath), end
end

