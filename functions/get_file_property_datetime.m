function creation_datetime = get_file_property_datetime(filepath,property)
    if ismember(property,{'CreationTime','CreationTimeUtc','LastAccessTime','LastAccessTimeUtc','LastWriteTime','LastWriteTimeUtc'})
        if contains(property, 'Utc')
            timezone='UTC';
        else
            timezone='Europe/Rome';
        end
    % Formato con millisecondi (fff)
    % Usiamo l'identificatore 'o' (ISO 8601) o specifichiamo i millisecondi
    array={filepath, property};
    ps_command = sprintf('powershell -command "(Get-Item ''%s'').%s.ToString(''yyyy-MM-dd HH:mm:ss.fff'')" ', array{:});    
    [status, cmdout] = system(ps_command);
    
    if status == 0
        % Creiamo il datetime specificando la TimeZone locale
        creation_datetime = datetime(strtrim(cmdout), ...
            'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS', ...
            'TimeZone', timezone);
    else
        % Fallback se PowerShell fallisce
        f_info = dir(filepath);
        creation_datetime = datetime(f_info.datenum, 'ConvertFrom', 'datenum', 'TimeZone', 'Europe/Rome');
    end
    creation_datetime.Format = 'yyyy-MM-dd HH:mm:ss.SSS';

    else
        return
    end
end