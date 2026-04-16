clc;
clearvars;
close all

%SALAR AHMADI PEIGHAMBARI -------s303178------%

%--------------------  EXERCISE 1  --------------------------------%

                     % Parameters


A = 7;          % Amplitude
T = 3;          % Duration
Tmax = 10;      % Total time
fs = 1000/T;    % Sampling frequency
dt = 1/fs;      % Time step
t = 0:dt:Tmax;  % Time 


%---------------------------------------------------------------%
           % Generate the rectangular pulse


s = A * (t < T);


%---------------------------------------------------------------%
           %  analytical pulse energy


Energy_analytical = A^2 * T;


%---------------------------------------------------------------%
          %  pulse energy on the time axis


Energy_time = sum(s.^2) * dt;


%---------------------------------------------------------------%
                  % Plot the pulse
                  
figure;
plot(t, s);
title(['Rectangular Pulse: A = ' num2str(A) ', T = ' num2str(T) ...
    ', E_{analytical} = ' num2str(Energy_analytical) ...
    ', E_{time} = ' num2str(Energy_time)]);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;  


%---------------------------------------------------------------%
                       %  FFT
FFT_ = fft(s);
Shift = fftshift(FFT_) * dt;
f = (-fs/2:fs/length(s):fs/2-fs/length(s));  


%---------------------------------------------------------------%
           %  energy on the frequency axis


Energy_freq = sum(abs(Shift).^2) * (fs/length(Shift));


%---------------------------------------------------------------%
                  % Plot FFT magnitude

figure;
plot(f, abs(Shift));
title(['FFT Magnitude: A = ' num2str(A) ', T = ' num2str(T) ...
    ', E_{frequency} = ' num2str(Energy_freq)]);
xlabel('Frequency (Hz)');
ylabel('|S(f)|');

xlim([-20, 20]);

%---------------------------------------------------------------%
% Compute energy percentage in each lobe (0 to 10 Hz)

energy_percentage_0_to_10 = zeros(1, 11); % Preallocate for energy percentages
for k = 0:10
    lobe_indices = find(abs(f) <= k);
    energy_in_lobe = sum(abs(Shift(lobe_indices)).^2);
    energy_percentage_0_to_10(k+1) = (energy_in_lobe / Energy_freq) * 100; % Calculate percentage
end

% Normalize to have a maximum of 100
max_energy = max(energy_percentage_0_to_10);
energy_percentage_0_to_10 = (energy_percentage_0_to_10 / max_energy) * 100;

% Plot the energy percentage in each lobe (0 to 10 Hz)
figure;
plot(0:10, energy_percentage_0_to_10, '-o');
title(['Energy Percentage (0 to 10 Hz): A = ', num2str(A), ', T = ', num2str(T)]);
xlabel('Frequency (Hz)');
ylabel('Energy percentage');
grid on;
ylim([90, 100]); 

%---------------------------------------------------------------%
      % Compute energy percentage in each lobe (10 to 100 Hz)


energy_percentage_10_to_100 = zeros(1, 91); 
for k = 10:100
    lobe_indices = find(abs(f) <= k);
    energy_in_lobe = sum(abs(Shift(lobe_indices)).^2);
    energy_percentage_10_to_100(k-9) = (energy_in_lobe / Energy_freq) * 10; % Calculate percentage
end


%---------------------------------------------------------------%
     % Plot the energy percentage in each lobe (10 to 100)

figure;
plot(10:100, energy_percentage_10_to_100, '-o');
title(['Energy Percentage (10 to 100 ): A = ', num2str(A), ', T = ', num2str(T)]);
xlabel('Number of Lobes');
ylabel('Energy percentage');
grid on;