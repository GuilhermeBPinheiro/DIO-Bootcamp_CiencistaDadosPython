'''
PROJETO: Criando um Sistema Bancário com Python

Descrição: Neste projeto, você terá a oportunidade de criar um Sistema Bancário em Python. 
O objetivo é implementar três operações essenciais: depósito, saque e extrato. 
O sistema será desenvolvido para um banco que busca monetizar suas operações. 
Durante o desafio, você terá a chance de aplicar seus conhecimentos em programação Python 
e criar um sistema funcional que simule as operações bancárias. 
Prepare-se para aprimorar suas habilidades e demonstrar sua capacidade de desenvolver soluções práticas e eficientes.

Operação de Depósito: 
Deve ser possível depositar valores positivos para a minha conta bancária. 
A v1 do projeto trabalha apenas com 1 usuário, dessa forma não precisamos nos preocupar em identificar qual é o número da agência e conta bancária. 
Todos os depósitos devem ser armazenados em uma variável e exibidos na operação de extrato. 

Operação de Saque:
O sistema deve permitir realizar 3 saques diários com limites máximos de R$ 500,00 por saque. 
Caso o usuário não tenha saldo em conta, o sistema deve exibir uma mensagem informando que não será possível sacar o dinheiro por falta de saldo. 
Todos os saques devem ser armazenados em uma variável e exibidos na operação de extrato. 

Operação de Extrato:
Essa operação deve listar todos os depósitos e saques realizados na conta. 
No fim da listagem deve ser exibido o saldo atual na conta. Os valores devem ser exibidos utilizando o formato "RS xxx.xx".
Exemplo: 1500.45 = R$ 1500.45.
'''

# 0) Cadastramento

nome = input("Por favor digitar seu nome completo: ")
nome_completo = nome.title().strip()

print(nome_completo)

# 1) Criação do Menu

menu=f"""

=====BEM-VINDO AO BANCO PYTHON=====

O que gostaria de fazer Sr(a) {nome_completo}

[1] Depositar
[2] Sacar
[3] Extrato
[0] Sair

==> """

# 2) Criação das Variáveis

saldo = 0
LIMITE = 500
extrato = ""
numero_saques = 0
LIMITE_SAQUE = 3

# 3) Criação da Lógica

while True:

    opcao = input(menu)

    if opcao == "1":
        valor = float(input("Informe o valor do depósito: "))

        if valor > 0:
            saldo += valor
            extrato += f"Deposito: R${valor:.2f} \n"
        
        else:
            print("Operação falhou: O valor informado é inválido!")

    elif opcao == "2":
        valor = float(input("Informe o valor do saque: "))

        execedeu_saldo = valor > saldo
        execedeu_limite = valor > LIMITE
        execedeu_saques = numero_saques >= LIMITE_SAQUE

        if execedeu_saldo:
            print("Operação falhou: Você não tem saldo suficiente.")

        elif execedeu_limite:
            print("Operação falhou: O valor do saque excede o limite.")

        elif execedeu_saques:
            print("Operação falhou: Número máximo de saques excedido.")
        
        elif valor > 0:
            saldo -= valor
            extrato += f"Saque: R${valor:.2f} \n"
            numero_saques += 1
        
        else: 
            print("Operação falhou: O valor informado é inválido")

    elif opcao == "3":
        print("==========EXTRATO==========")
        print("Não foram realizadas movimentação." if not extrato else extrato)
        print(f"\nSaldo: R${saldo:.2f}")
        print("===========================")

    elif opcao == "0":
        break

    else:
        print("Operação inválida, por favor selecione novamente a operação desejada.")

'''
else: 
    print(f"""
          
    Obrigado pela preferência!
    Tenha um bom dia, Sr(a) {nome_completo}!

    Atenciosamente Banco Python.

          """)
'''

