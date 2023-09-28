#import "template.typ": *

#show: project.with(
  title: "Atividade 2 - Org. Arg. 1",
  authors: (
	"Profa. Dra. Cíntia Borges Margi (cintia@usp.br)",
	"Guilherme S. Salustiano (salustiano@usp.br)",
  ),
)
#show link: underline

// TODO: Gostaria de usar o Qemu para simular o código do fatorial mas precisa de um bom tutorial de como usar.

= Parte 1 - Instruções e chamadas de funções
Na primeira parte dessa atividade explorar as instruções geradas por algumas funções pelo compilador, 
observando chamadas de funções e como isso se relaciona com a pilha.

== Contexto
Os computadores entendem e executam um conjunto bem restrito de instruções, 
com a evolução da computação buscou-se criar maneiras mais simples e expressivas de se criar código, 
e assim surgem as primeiras linguagens de programação de alto nivel que são compiladas para as instruções que o processador entende.

== Analisando o disassembly de funções
Vamos usar o #link("https://godbolt.org/")[godbolt.org], um compilador online que suporta diferentes arquiteturas.
Ao abrir o site você encontra dois principais painéis conforme a @godbolt. 
Na esquerda você encontra um editor de texto, no menu superior selecione a linguagem "C".
Na direita você pode observar as instruções em assembly que foram gerado pelo código da esquerda, 
no menu superior escolha o compilador "RISC-V (64-bits) gcc 13.2.0", 
também temos a opção de passar flags para o compilador na caixa de texto do canto superior direito que iremos usar mais adiante.

#figure(
  image("godbolt.png", width: 82%),
  caption: [
	Visão geral do godbolt.org
  ],
) <godbolt>

=== Soma simples
Escreva o seguinte código no editor. O campo de flags no canto superior direito deve estar vazio.
```c
int sum(int a, int b) {
  return a + b;
}
```

_Quais operações você consegue identificar?_

_Consegue visualizar alguma melhoria possível?_


=== Soma simples otimizado
Agora vamos adicionar a flag `-O1` no compilador com o mesmo código do exemplo anterior, por padrão o compilador não otimiza o código (`-O0`).

Ligar uma flag de otimização faz com que o compilador tente melhorar o desempenho e/ou o tamanho do código em detrimento do tempo de compilação e possivelmente da capacidade de depurar o programa.

Você pode ler mais sobre as flags e otimizações do gcc #link("https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html")[aqui].

_O que mudou?_

_Porque por padrão o compilador não otimiza o código?_

=== Fatorial recursivo sem otimização
Agora substitua o código do editor pelo código abaixo e também apague as flags de comṕilação.

```c
int factorial(int n) {
  if (n == 0) {
    return 1;
  } 
  return n * factorial(n - 1);
}
```

_Quais as novas operações que você consegue identificar?_

_Consegue visualizar alguma melhoria possível?_

=== Fatorial recursivo com `-O1`
Agora vamos adicionar a flag `-O1` no compilador com o mesmo código do exemplo anterior.

_O que mudou?_

_Porque ele continua a usar a stack?_

_Consegue visualizar alguma melhoria possível?_

=== Fatorial recursivo com `-O2`
Agora vamos adicionar a flag `-O2` no compilador com o mesmo código do exemplo anterior.

_O que mudou?_

= Parte 2 - Benchmark de linguagens e flags de compilação
Nessa parte vamos executar o mesmo código da atividade 1, o conjunto de mandelbrot, em diferentes linguagens e comparar seu desempenho.

== Requisitos
Primeiramente baixe o #link("https://github.com/guissalustiano/oac1-trabalho2")[os códigos].

Nessa parte iremos usar novamente o perf, gcc e make. Caso você ainda não tenha 
instalado siga as instruções disponivel na #link("https://raw.githubusercontent.com/guissalustiano/oac1-trabalho1/main/doc/statement.pdf")[atividade 1]

Além disso vamos precisar do pypy e do java, se você ainda não tiver eles instalados no seu sistema você pode instalar com o comando abaixo:
```bash
$ sudo apt install pypy3 openjdk-17-jdk
```

Um container docker também está disponível para uso, basta usar o script `run_by_docker.sh`.

== Executando o código
Abra um terminal na pasta `src/` do código baixado e execute os comandos para cada linguagem.

// demorou 2m9s
=== C sem otimizações
```bash
$ # Compila o código
$  gcc -o mandelbrot_00 -std=c11 -O0 mandelbrot.c -lm

$ # Roda o programa e salva o resultado em um arquivo
$ perf stat -x ';' -r 10 -e cycles,instructions,duration_time ./mandelbrot_00 -2.5 1.5 -2.0 2.0 4096 2>&1 | tee c_O0.csv
```

// demorou 59s
=== C com otimização
```bash
$ # Compila o código
$ gcc -o mandelbrot_02 -std=c11 -O2 mandelbrot.c -lm

$ # Roda o programa e salva o resultado em um arquivo
$ perf stat -x ';' -r 10 -e cycles,instructions,duration_time ./mandelbrot_02 -2.5 1.5 -2.0 2.0 4096 2>&1 | tee c_O2.csv
```

// demorou 3m39
=== Java
```bash
$ # Compila o código
$ javac mandelbrot.java

$ # Roda o programa e salva o resultado em um arquivo
$ perf stat -x ';' -r 10 -e cycles,instructions,duration_time java Mandelbrot -2.5 1.5 -2.0 2.0 4096 2>&1 | tee java.csv
```

// demorou 3m16s
=== PyPy
```bash
$ # Roda o programa e salva o resultado em um arquivo
$ perf stat -x ';' -r 10 -e cycles,instructions,duration_time pypy3 mandelbrot.py -2.5 1.5 -2.0 2.0 4096 2>&1 | tee pypy.csv
```

// demorou 27m41s
=== CPython
```bash
$ # Roda o programa e salva o resultado em um arquivo
$ perf stat -x ';' -r 10 -e cycles,instructions,duration_time python3 mandelbrot.py -2.5 1.5 -2.0 2.0 4096 2>&1 | tee python.csv
```

== Analisando os resultados
Para facilitar a comparação dos resultados vamos usar o script 
`src/plot.py` que gera um gráfico com os resultados disponíveis na pasta `plots/`.

```bash
$ python plot.py
```
_Qual a classificação de desempenho de cada linguagem?_

_Como o desempenho de cada linguagem se relaciona ao modo de execução (compilada, interpretada, JIT) dela?_

= Entrega final
Ao final, gere um zip `atv2.zip` com os arquivos.
```bash
atv2.zip
├── c_O0.csv
├── c_O2.csv
├── java.csv
├── pypy.csv
├── python.csv
```

// #bibliography("references.bib")
