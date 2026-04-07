"""
        8           L = smaller value
    L /   \ R       R = greater value
    4       10
           /
          9
"""

class Node:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None


class BinaryTree:
    def __init__(self):
        self.root = None

    def insert(self, data):
        new_node = Node(data)

        if self.root is None:
            self.root = new_node
            return

        current = self.root
        while True:
            if data < current.value:
                if current.left is None:
                    current.left = new_node
                    return
                current = current.left
            else:
                if current.right is None:
                    current.right = new_node
                    return
                current = current.right

    def remove(self, value):
        parent = None
        current = self.root

        while current and current.value != value:
            parent = current
            if value < current.value:
                current = current.left
            else:
                current = current.right

        if not current:
            print("Element not found")
            return

        # case 1: 2 children -> replace with the rightmost minimum
        if current.left and current.right:
            successor_parent = current
            successor = current.right

            while successor.left:
                successor_parent = successor
                successor = successor.left

            current.value = successor.value
            parent = successor_parent
            current = successor

        # Case 2: 0 or 1 child
        child = current.left or current.right

        if parent is None:
            self.root = child
        elif parent.left == current:
            parent.left = child
        else:
            parent.right = child

        return True

    def search(self, value):
        current = self.root

        while current:
            if value == current.value:
                print("Value found:", value)
                return True

            if value < current.value:
                current = current.left
            else:
                current = current.right

        print("Value not found")

    def height(self, node):
        if node is None:
            return 0

        left_height = self.height(node.left)
        right_height = self.height(node.right)

        return 1 + max(left_height, right_height)

def pre_order(self, node):
    if node is not None:
        print(node.value)
        self.pre_order(node.left)
        self.pre_order(node.right)

def in_order(self, node):
    if node is not None:
        self.in_order(node.left)
        print(node.value)
        self.in_order(node.right)

def print_tree(root):
    if not root:
        return

    def height(node):
        if not node:
            return 0
        return 1 + max(height(node.left), height(node.right))

    h = height(root)
    width = 2 ** h
    lines = []

    def ensure_line(index):
        while len(lines) <= index:
            lines.append([" "] * (width * 2))

    def fill(node, level, pos, gap):
        if node is None:
            return

        ensure_line(level)

        val = str(node.value)
        for i, ch in enumerate(val):
            lines[level][pos + i] = ch

        if node.left:
            ensure_line(level + 1)
            lines[level + 1][pos - gap // 2] = "/"
            fill(node.left, level + 2, pos - gap, gap // 2)

        if node.right:
            ensure_line(level + 1)
            lines[level + 1][pos + gap // 2] = "\\"
            fill(node.right, level + 2, pos + gap, gap // 2)

    fill(root, 0, width, width // 2)

    for line in lines:
        print("".join(line).rstrip())

def main():
    option = -1
    tree = BinaryTree()

    while option != 0:
        print("1 - insert element")
        print("2 - remove element")
        print("3 - search element")
        print("4 - tree height")
        print("5 - show in-order")
        print("6 - show pre-order")
        print("7 - show tree")
        print("0 - exit")

        option = int(input("option: "))

        if option == 1:
            data = int(input("Enter value to insert: "))
            tree.insert(data)

        elif option == 2:
            data = int(input("Enter value to remove: "))
            tree.remove(data)

        elif option == 3:
            data = int(input("Enter value to search: "))
            tree.search(data)

        elif option == 4:
            print("Height:", tree.height(tree.root))

        elif option == 5:
            in_order(tree.root)

        elif option == 6:
            pre_order(tree.root)

        elif option == 7:
            print_tree(tree.root)


main()
