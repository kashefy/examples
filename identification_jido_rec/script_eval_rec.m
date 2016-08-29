idModels = setDefaultIdModels();
idModels = idModels(1:2);

data_dir = '/home/kashefy/twoears/twoears-database-internal';
flist = ...
    {fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/alarm.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/baby.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/baby_dog_fire.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/baby_piano.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/dog.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/baby_dog_fire_moving.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/female_fire_alarm.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/female_speaker3.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/female_speaker4.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/fire.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/male_female.mat'),...
    fullfile(data_dir, 'sound_databases/adream_1605/rec/raw/baby_dog_fire_piano.mat')}; % piano_baby -> baby_dog_fire_piano
for ii = 3:3%numel(flist)
    fpath_mixture_mat = flist{ii};
    [idLabels{ii}, perf{ii}] = identify_rec(idModels, data_dir, fpath_mixture_mat);
    close all
end