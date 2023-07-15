valorHamburguer = float(input())
quantidadeHamburguer = int(input())
valorBebida = float(input())
quantidadeBebida = int(input())
valorPago = float(input())

'''
//TODO: Calcular o preço final do pedido (total dos hambúrgueres + total das bebidas).
//TODO: Calcular o troco do pedido, considerando o preço final e o valor pago pelo usuário.
//TODO: Imprimir a saída no formato especificado neste desafio.
'''

valorFinalPedido = (valorHamburguer * quantidadeHamburguer) + (valorBebida * quantidadeBebida)
valorTroco = valorPago - valorFinalPedido

print(f"O preço final do pedido é R${valorFinalPedido:.2f}. Seu troco é R${valorTroco:.2f}.")
