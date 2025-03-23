function D=read_brainstorm_tutorial_data(key)
%D=read_brainstorm_tutorial_data(key) - read Brainstorm tutorial MEG data for WW paper figures
%
%  D: struct with all useful data
%
%  key: which dataset to read

basedir='../brainstorm/brainstorm data/';

switch key
    case 'MEG_sample_introduction_run1'
        % read header & data
        fname='sample_introduction/data/S01_AEF_20131218_01_600Hz.ds';
        h=ft_read_header([basedir,fname]);
        sr=h.Fs;
        x=ft_read_data([basedir,fname]); % channels X time X chunks
        x=permute(x,[2 1 3]);
        x=nt_unfold(x); % concatenate chunks to get continuous data

        % pick out various channels
        refchannels=4+(1:26);
        megchannels=30+(1:274);
        udio=x(:,1); % finger taps
        uppt=x(:,2); % stimulus triggers: 1=standard, 2=deviant
        uadc=x(:,316); % audio
        ref=x(:,refchannels);
        meg=x(:,megchannels);
        clear x;

        ref=nt_demean(ref); 
        meg=nt_demean(meg);

        if 1
            nremove=3;
            meg=nt_zapline(meg,60/sr,nremove);
        end

        % find triggers, extract epochs
        tstandard=find(uppt(1:end-1)<0.9 & uppt(2:end)>0.9 & uppt(2:end)<1.9);
        tdeviant=find(uppt(1:end-1)<0.9 & uppt(2:end)>1.9);
        tbutton=find(udio(1:end-1)<20 & udio(2:end)>20);
        disp([numel(tstandard), numel(tdeviant), numel(tbutton)]);

        % auditory stimulus
        pre=round(0.2*sr);;
        post=round(0.4*sr);
        s=[]; d=[];
        for iTrial=1:numel(tstandard)
            s(:,:,iTrial)=meg(tstandard(iTrial)+(-pre:post),:);
        end
        for iTrial=1:numel(tdeviant)
            d(:,:,iTrial)=meg(tdeviant(iTrial)+(-pre:post),:);
        end

        % button press
        pre=round(1*sr);
        post=round(0*sr);
        b=[];
        for iTrial=1:numel(tbutton)
            b(:,:,iTrial)=meg(tbutton(iTrial)+(-pre:post),:);
        end
        s=nt_demean2(s); % standard
        d=nt_demean2(d); % deviant 
        b=nt_demean2(b); % button

        t=linspace(-0.2, 0.4, size(s,1));
        t2=linspace(-1, 0, size(b,1));

        D.h=h;
        D.sr=sr;
        D.pre=pre;
        D.post=post;
        D.b=b;
        D.s=s;
        D.d=d;
        D.meg=meg;
        D.tauditory=t;
        D.tbutton=t2;

    case 'MEG_sample_introduction_run2'
        % read header & data
        fname='sample_introduction/data/S01_AEF_20131218_02_600Hz.ds';
        h=ft_read_header([basedir,fname]);
        sr=h.Fs;
        x=ft_read_data([basedir,fname]); % channels X time X chunks
        x=permute(x,[2 1 3]);
        x=nt_unfold(x); % concatenate chunks to get continuous data

        % pick out various channels
        refchannels=4+(1:26);
        megchannels=30+(1:274);
        udio=x(:,1); % finger taps
        uppt=x(:,2); % stimulus triggers: 1=standard, 2=deviant
        uadc=x(:,316); % audio
        ref=x(:,refchannels);
        meg=x(:,megchannels);
        clear x;

        ref=nt_demean(ref); 
        meg=nt_demean(meg);

        if 1
            nremove=3;
            meg=nt_zapline(meg,60/sr,nremove);
        end

        % find triggers, extract epochs
        tstandard=find(uppt(1:end-1)<0.9 & uppt(2:end)>0.9 & uppt(2:end)<1.9);
        tdeviant=find(uppt(1:end-1)<0.9 & uppt(2:end)>1.9);
        tbutton=find(udio(1:end-1)<20 & udio(2:end)>20);
        disp([numel(tstandard), numel(tdeviant), numel(tbutton)]);

        % auditory stimulus
        pre=round(0.2*sr);;
        post=round(0.4*sr);
        s=[]; d=[];
        for iTrial=1:numel(tstandard)
            s(:,:,iTrial)=meg(tstandard(iTrial)+(-pre:post),:);
        end
        for iTrial=1:numel(tdeviant)
            d(:,:,iTrial)=meg(tdeviant(iTrial)+(-pre:post),:);
        end

        % button press
        pre=round(1*sr);
        post=round(0*sr);
        b=[];
        for iTrial=1:numel(tbutton)
            b(:,:,iTrial)=meg(tbutton(iTrial)+(-pre:post),:);
        end
        s=nt_demean2(s); % standard
        d=nt_demean2(d); % deviant 
        b=nt_demean2(b); % button

        t=linspace(-0.2, 0.4, size(s,1));
        t2=linspace(-1, 0, size(b,1));

        D.h=h;
        D.sr=sr;
        D.pre=pre;
        D.post=post;
        D.b=b;
        D.s=s;
        D.d=d;
        D.meg=meg;
        D.tauditory=t;
        D.tbutton=t2;
end % switch
