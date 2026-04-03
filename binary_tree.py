"""
        8           L = menor valor
    L /   \ R       R = maior valor
    4       10
           /
          9
"""
class Node:
    def __init__(self, valor):
        self.valor = valor
        self.esquerda = None
        self.direita = None

class Arvore:
    def __init__(self):
        self.raiz = None

    def inserir(self, dado):
        novo = Node(dado)

        if self.raiz == None:
            self.raiz = novo
            return
        atual = self.raiz
        while True:
            if dado < atual.valor:
                if atual.esquerda is None:
                    atual.esquerda = novo
                    return
                atual = atual.esquerda
            else:
                if atual.direita is None:
                    atual.direita = novo
                    return
                atual = atual.direita

    def remover(self, valor):
        pai = None
        atual = self.raiz
        while atual and atual.valor != valor:
            pai = atual
            if valor < atual.valor:
                atual = atual.esquerda
            else:
                atual = atual.direita
        if not atual:
            print("elemento não encontrado")
            return

        # caso 1: 2 filhos -> substituir pelo minimo da direita
        if atual.esquerda and atual.direita:
            pai_sucessor = atual
            sucessor = atual.direita
            while sucessor.esquerda:
                pai_sucessor = sucessor
                sucessor = sucessor.esquerda
            atual.valor = sucessor.valor
            pai = pai_sucessor
            atual = sucessor

        # caso 2: 0 ou 1 filho
        filho = atual.esquerda or atual.direita
        if pai is None:
            self.raiz = filho
        elif pai.esquerda == atual:
            pai.esquerda = filho
        else:
            pai.direita = filho
        return True

    def buscar(self, valor):
        atual = self.raiz
        while atual:
            if valor == atual.valor:
                print("valor encontrado: ", valor)
                return True
            if valor < atual.valor:
                atual = atual.esquerda
            else:
                atual = atual.direita
        print("valor não encontrado")

    def altura(self, no):
        if no is None:
            return 0
        altura_esquerda = self.altura(no.esquerda)
        altura_direita = self.altura(no.direita)
        return 1 + max(altura_esquerda, altura_direita)

    def pre_ordem(self, no):
        if no is not None:
            print(no.valor)
            self.pre_ordem(no.esquerda)
            self.pre_ordem(no.direita)

    def em_ordem(self, no):
        if no is not None:
            self.em_ordem(no.esquerda)
            print(no.valor)
            self.em_ordem(no.direita)

def main():
    opcao = -1
    arv = Arvore()

    while opcao != 0:
        print("1 - inserir elemento")
        print("2 - excluir elemento")
        print("3 - buscar elemento")
        print("4 - altura arvore")
        print("5 - mostrar em ordem")
        print("6 - mostrar em pre ordem")
        print("0 - sair")
        opcao = int(input("opção: "))

        if opcao == 1:
            dado = int(input("digite o valor pra inserir: "))
            arv.inserir(dado)
        elif opcao == 2:
            dado = int(input("digite o valor pra remover: "))
            arv.remover(dado)
        elif opcao == 3:
            dado = int(input("digite o valor pra buscar: "))
            arv.buscar(dado)
        elif opcao == 4:
            print("altura:", arv.altura(arv.raiz))
        elif opcao == 5:
            arv.em_ordem(arv.raiz)
        elif opcao == 6:
            arv.pre_ordem(arv.raiz)

main()
