
%  USER INTERFACE & INPUT VALIDATION

start :-
    write('--- SMART IRRIGATION SYSTEM ---'), nl,
    write('Please enter sensor data below (ends with a period).'), nl,
    
    % --- MOISTURE (Recursive Loop) ---
    get_valid_input('Soil Moisture (0-100%): ', 0, 100, CleanM),
    
    % --- TEMPERATURE (Recursive Loop) ---
    get_valid_input('Temperature (Celsius -10 to 60): ', -10, 60, Temp),
    
    % --- HUMIDITY (Recursive Loop) ---
    get_valid_input('Humidity (0-100%): ', 0, 100, CleanH),
    
    nl, write('--- ANALYSIS ---'), nl,
    get_irrigation(CleanM, Temp, CleanH),
    nl, write('--- END REPORT ---'), nl.

% --- RECURSIVE INPUT HELPERS ---

% Success Case (Valid Input)
get_valid_input(Prompt, Min, Max, Input) :-
    write(Prompt), read(Input),
    number(Input), 
    Input >= Min, 
    Input =< Max, 
    !. % Stop here if valid

% Failure Case (Invalid Input -> Retry)
get_valid_input(Prompt, Min, Max, Result) :-
    nl, write('ERROR: Invalid input!'), nl,
    write('Please enter a number between '), write(Min), write(' and '), write(Max), write('.'), nl,
    nl,
    get_valid_input(Prompt, Min, Max, Result). % Recursively call itself

% FUZZIFICATION (Converting Numbers to Words)

category_moisture(M, dry)   :- M =< 40.
category_moisture(M, moist) :- M >= 35, M =< 75.
category_moisture(M, wet)   :- M >= 70.

category_temp(T, cool) :- T =< 20.
category_temp(T, warm) :- T >= 15, T =< 35.
category_temp(T, hot)  :- T >= 30.

category_humidity(H, low)    :- H =< 40.
category_humidity(H, medium) :- H >= 35, H =< 75.
category_humidity(H, high)   :- H >= 70.

% RULE BASE (Knowledge Base)

% --- HIGH PRIORITY RULES ---
rule(dry, hot, low, high, 'Critical: Soil is dry and evaporation rate is high.') :- !.
rule(dry, hot, medium, high, 'High Alert: Hot conditions require heavy irrigation.') :- !.
rule(wet, _, _, low, 'Optimization: Soil is already saturated.') :- !.
rule(_, _, high, low, 'Optimization: High humidity prevents effective evaporation.') :- !.

% --- MEDIUM PRIORITY RULES ---
rule(moist, warm, _, medium, 'Standard: Conditions are balanced.') :- !.
rule(dry, cool, _, medium, 'Compensation: Dry soil requires water, but cool temp reduces urgency.') :- !.
rule(moist, cool, low, medium, 'Maintenance: Low humidity may dry out moist soil.') :- !.

% --- DEFAULT / CATCH-ALL RULE ---
rule(_, _, _, low, 'Default: No extreme conditions detected. Conserving water.').

% INFERENCE ENGINE 

get_irrigation(M, T, H) :-
    % Fuzzify Inputs
    category_moisture(M, M_Cat),
    category_temp(T, T_Cat),
    category_humidity(H, H_Cat),
    
    % Trace output
    format('Fuzzified State: Moisture=~w, Temp=~w, Humidity=~w~n', [M_Cat, T_Cat, H_Cat]),
    
    % Match Rule
    rule(M_Cat, T_Cat, H_Cat, Decision, Explanation),
    
    % Output Result
    nl,
    write('RECOMMENDED IRRIGATION: '), write(Decision), nl,
    write('REASON: '), write(Explanation), nl,
    !.