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
        self.height = 1


class AVLTree:
    def __init__(self):
        self.root = None

    def height(self, node):
        if not node:
            return 0
        return node.height

    def balance(self, node):
        if not node:
            return 0
        return self.height(node.left) - self.height(node.right)

    def insert(self, root, value):
        if not root:
            return Node(value)
        elif value < root.value:
            root.left = self.insert(root.left, value)
        else:
            root.right = self.insert(root.right, value)

        root.height = 1 + max(self.height(root.left), self.height(root.right))
        balance = self.balance(root)

        # right rotation
        if balance > 1 and value < root.left.value:
            return self.right_rotate(root)

        # left rotation
        if balance < -1 and value > root.right.value:
            return self.left_rotate(root)

        # left-right rotation
        if balance > 1 and value > root.left.value:
            root.left = self.left_rotate(root.left)
            return self.right_rotate(root)

        # right-left rotation
        if balance < -1 and value < root.right.value:
            root.right = self.right_rotate(root.right)
            return self.left_rotate(root)

        return root
    
    def delete(self, root, value):
        if not root:
            return root

        if value < root.value:
            root.left = self.delete(root.left, value)
        elif value > root.value:
            root.right = self.delete(root.right, value)
        else:
            if not root.left:
                tmp = root.right
                root = None
                return tmp
            elif not root.right:
                tmp = root.left
                root = None
                return tmp

            tmp = self.min_value_node(root.right)
            root.value = tmp.value
            root.right = self.delete(root.right, tmp.value)

        if not root:
            return root

        root.height = 1 + max(self.height(root.left), self.height(root.right))
        balance = self.balance(root)

        # right rotation
        if balance > 1 and self.balance(root.left) >= 0:
            return self.right_rotate(root)

        # left rotation
        if balance < -1 and self.balance(root.right) <= 0:
            return self.left_rotate(root)

        # left-right rotation
        if balance > 1 and self.balance(root.left) < 0:
            root.left = self.left_rotate(root.left)
            return self.right_rotate(root)

        # right-left rotation
        if balance < -1 and self.balance(root.right) > 0:
            root.right = self.right_rotate(root.right)
            return self.left_rotate(root)

        return root
    
    def left_rotate(self, z):
        y = z.right
        subtree = y.left

        y.left = z
        z.right = subtree

        z.height = 1 + max(self.height(z.left), self.height(z.right))
        y.height = 1 + max(self.height(y.left), self.height(y.right))

        return y

    def right_rotate(self, z):
        y = z.left
        subtree = y.right

        y.right = z
        z.left = subtree

        z.height = 1 + max(self.height(z.left), self.height(z.right))
        y.height = 1 + max(self.height(y.left), self.height(y.right))

        return y

    def min_value_node(self, root):
        current = root
        while current.left:
            current = current.left
        return current

    def search(self, root, value):
        if not root or root.value == value:
            return root
        if root.value < value:
            return self.search(root.right, value)
        return self.search(root.left, value)

    def insert_value(self, value):
        self.root = self.insert(self.root, value)

    def delete_value(self, value):
        self.root = self.delete(self.root, value)

    def search_value(self, value):
        return self.search(self.root, value)
    

def in_order(self, node):
    if node:
        self.in_order(node.left)
        print(node.value)
        self.in_order(node.right)

def pre_order(self, node):
    if node:
        print(node.value)
        self.pre_order(node.left)
        self.pre_order(node.right)

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
    tree = AVLTree()

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
            value = int(input("Enter value to insert: "))
            tree.insert_value(value)

        elif option == 2:
            value = int(input("Enter value to remove: "))
            tree.delete_value(value)

        elif option == 3:
            value = int(input("Enter value to search: "))
            result = tree.search_value(value)
            if result:
                print("Value found:", value)
            else:
                print("Value not found")

        elif option == 4:
            print("Height:", tree.height(tree.root))

        elif option == 5:
            in_order(tree.root)

        elif option == 6:
            pre_order(tree.root)

        elif option == 7:
            print_tree(tree.root)

main()
