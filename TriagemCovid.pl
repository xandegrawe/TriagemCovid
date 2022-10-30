:- dynamic formulario/3.

formulario :- carrega('./formulario.bd'),
    format('~n*** Formulario de Triagem ***~n~n'),
    repeat,
    nome(Paciente),
    temperatura(Paciente),
    freqCardiaca(Paciente),
    freqResp(Paciente),
    preSisto(Paciente),
    satur(Paciente),
    dispineia(Paciente),
    idade(Paciente),
    comorbidade(Paciente),
    responde(Paciente),
    salva(formulario,'./formulario.bd').

carrega(Arquivo) :-
    exists_file(Arquivo),
    consult(Arquivo)
    ;
    true.

%===== Sequencia de Perguntas ======= %
nome(Paciente) :-
    format('~nQual o nome do paciente? '),
    gets(Paciente).

temperatura(Paciente) :-
    format('~nQual a temperatura? '),
    gets(Temp),
    asserta(formulario(Paciente,temperatura,Temp)).

freqCardiaca(Paciente) :-
    format('~nQual a frequ�ncia card�aca? '),
    gets(FreCard),
    asserta(formulario(Paciente,freqCardiaca,FreCard)).

freqResp(Paciente) :-
    format('~nQual a frequ�ncia respirat�ria? '),
    gets(FreResp),
    asserta(formulario(Paciente,freqResp,FreResp)).

preSisto(Paciente) :-
    format('~nQual o press�o arterial sist�lica? '),
    gets(PreSis),
    asserta(formulario(Paciente,preSisto,PreSis)).

satur(Paciente) :-
    format('~nQual a satura��o do oxig�nio? (Sa02) : '),
    gets(SaO2),
    asserta(formulario(Paciente,satur,SaO2)).

dispineia(Paciente) :-
    format('~nTem dispn�ia? (sim ou n�o) : '),
    gets(Dispn),
    asserta(formulario(Paciente,dispineia,Dispn)).

idade(Paciente) :-
    format('~nQual a Idade? '),
    gets(Idade),
    asserta(formulario(Paciente,idade,Idade)).

comorbidade(Paciente) :-
    format('~nPossui comorbidades? '),
    format('~nSe sim digite a quantidade, se n�o digite 0 : '),
    gets(Como),
    asserta(formulario(Paciente,comorbidade,Como)).

salva(P,A) :-
    tell(A),
    listing(P),
    told.

gets(String) :-
    read_line_to_codes(user_input,Char),
    name(String,Char).

responde(Paciente) :-
    condicao(Paciente, Char),
    !,
    format('A condi��o de ~w � ~w.~n',[Paciente,Char]).


%----------- Regras de Condi��es -----------

%======Gravissimo======
condicao(Pct, gravissimo) :-
    formulario(Pct,freqResp,Valor), Valor > 30;
    formulario(Pct,preSisto,Valor), Valor < 90;
    formulario(Pct,satur,Valor), Valor < 95;
    formulario(Pct,dispineia,Valor), Valor = "sim".

%========Grave========
condicao(Pct, grave) :-
    formulario(Pct,temperatura,Valor), Valor > 39;
    formulario(Pct,preSisto,Valor), Valor >= 90, Valor =< 100;
    formulario(Pct,idade,Valor), Valor >= 80;
    formulario(Pct,comorbidade,Valor), Valor >= 2.

%=====M�dio======
condicao(Pct, medio) :-
    formulario(Pct,temperatura,Valor), (Valor < 35; (Valor > 37, Valor =< 39));
    formulario(Pct,freqCardiaca,Valor), Valor >= 100;
    formulario(Pct,freqResp,Valor), Valor >= 19, Valor =< 30;
    formulario(Pct,idade,Valor), Valor >= 60, Valor =< 79;
    formulario(Pct,comorbidade,Valor), Valor = 1.


%=======Leve========
condicao(Pct, leve) :-
    formulario(Pct,temperatura,Valor), Valor >= 35, Valor =< 37;
    formulario(Pct,freqCardiaca,Valor), Valor < 100;
    formulario(Pct,freqResp,Valor), Valor =< 18;
    formulario(Pct,preSisto,Valor), Valor > 100;
    formulario(Pct,satur,Valor), Valor >= 95;
    formulario(Pct,dispineia,Valor), Valor = "n�o";
    formulario(Pct,idade,Valor), Valor < 60;
    formulario(Pct,comorbidade,Valor), Valor = 0.
