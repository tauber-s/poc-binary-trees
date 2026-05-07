const std = @import("std");

const Node = struct {
    value: i32,
    left: ?*Node,
    right: ?*Node,
    height: i32,
};

const AVLTree = struct {
    allocator: std.mem.Allocator,
    root: ?*Node,

    pub fn init(allocator: std.mem.Allocator) AVLTree {
        return .{
            .allocator = allocator,
            .root = null,
        };
    }

    // =========================
    // HEIGHT / BALANCE
    // =========================
    fn height(node: ?*Node) i32 {
        if (node == null) return 0;
        return node.?.height;
    }

    fn balance(node: ?*Node) i32 {
        if (node == null) return 0;
        return height(node.?.left) - height(node.?.right);
    }

    // =========================
    // NODE CREATION
    // =========================
    fn createNode(self: *AVLTree, value: i32) !*Node {
        const node = try self.allocator.create(Node);

        node.* = .{
            .value = value,
            .left = null,
            .right = null,
            .height = 1,
        };

        return node;
    }

    // =========================
    // ROTATIONS
    // =========================
    fn leftRotate(z: *Node) *Node {
        var y = z.right.?;
        const subtree = y.left;

        y.left = z;
        z.right = subtree;

        z.height = 1 + @max(height(z.left), height(z.right));
        y.height = 1 + @max(height(y.left), height(y.right));

        return y;
    }

    fn rightRotate(z: *Node) *Node {
        var y = z.left.?;
        const subtree = y.right;

        y.right = z;
        z.left = subtree;

        z.height = 1 + @max(height(z.left), height(z.right));
        y.height = 1 + @max(height(y.left), height(y.right));

        return y;
    }

    // =========================
    // INSERT
    // =========================
    fn insert(self: *AVLTree, root: ?*Node, value: i32) !?*Node {
        if (root == null) {
            return try self.createNode(value);
        }

        var node = root.?;

        if (value < node.value) {
            node.left = try self.insert(node.left, value);
        } else if (value > node.value) {
            node.right = try self.insert(node.right, value);
        } else {
            return node;
        }

        node.height = 1 + @max(height(node.left), height(node.right));

        const bal = balance(node);

        // LEFT LEFT
        if (bal > 1 and value < node.left.?.value) {
            return rightRotate(node);
        }

        // RIGHT RIGHT
        if (bal < -1 and value > node.right.?.value) {
            return leftRotate(node);
        }

        // LEFT RIGHT
        if (bal > 1 and value > node.left.?.value) {
            node.left = leftRotate(node.left.?);
            return rightRotate(node);
        }

        // RIGHT LEFT
        if (bal < -1 and value < node.right.?.value) {
            node.right = rightRotate(node.right.?);
            return leftRotate(node);
        }

        return node;
    }

    pub fn insertValue(self: *AVLTree, value: i32) !void {
        self.root = try self.insert(self.root, value);
    }

    // =========================
    // MIN VALUE NODE
    // =========================
    fn minValueNode(node: *Node) *Node {
        var current = node;

        while (current.left != null) {
            current = current.left.?;
        }

        return current;
    }

    // =========================
    // DELETE
    // =========================
    fn delete(self: *AVLTree, root: ?*Node, value: i32) ?*Node {
        if (root == null) {
            return null;
        }

        var node = root.?;

        // SEARCH NODE
        if (value < node.value) {
            node.left = self.delete(node.left, value);
        } else if (value > node.value) {
            node.right = self.delete(node.right, value);
        } else {

            // NODE WITH 0 OR 1 CHILD
            if (node.left == null or node.right == null) {
                const temp =
                    if (node.left != null)
                        node.left
                    else
                        node.right;

                self.allocator.destroy(node);

                return temp;
            }

            // NODE WITH 2 CHILDREN
            const temp = minValueNode(node.right.?);

            node.value = temp.value;

            node.right = self.delete(node.right, temp.value);
        }

        // TREE HAD ONLY ONE NODE
        if (root == null) {
            return null;
        }

        // UPDATE HEIGHT
        node.height = 1 + @max(height(node.left), height(node.right));

        const bal = balance(node);

        // LEFT LEFT
        if (bal > 1 and balance(node.left) >= 0) {
            return rightRotate(node);
        }

        // LEFT RIGHT
        if (bal > 1 and balance(node.left) < 0) {
            node.left = leftRotate(node.left.?);
            return rightRotate(node);
        }

        // RIGHT RIGHT
        if (bal < -1 and balance(node.right) <= 0) {
            return leftRotate(node);
        }

        // RIGHT LEFT
        if (bal < -1 and balance(node.right) > 0) {
            node.right = rightRotate(node.right.?);
            return leftRotate(node);
        }

        return node;
    }

    pub fn deleteValue(self: *AVLTree, value: i32) void {
        self.root = self.delete(self.root, value);
    }

    // =========================
    // SEARCH
    // =========================
    fn search(root: ?*Node, value: i32) ?*Node {
        if (root == null) return null;

        if (root.?.value == value) {
            return root;
        }

        if (value < root.?.value) {
            return search(root.?.left, value);
        }

        return search(root.?.right, value);
    }

    pub fn searchValue(self: *AVLTree, value: i32) ?*Node {
        return search(self.root, value);
    }

    // =========================
    // TRAVERSALS
    // =========================
    pub fn inOrder(node: ?*Node) void {
        if (node == null) return;

        inOrder(node.?.left);
        std.debug.print("{d} ", .{node.?.value});
        inOrder(node.?.right);
    }

    pub fn preOrder(node: ?*Node) void {
        if (node == null) return;

        std.debug.print("{d} ", .{node.?.value});
        preOrder(node.?.left);
        preOrder(node.?.right);
    }

    // =========================
    // FREE MEMORY
    // =========================
    pub fn deinit(self: *AVLTree, node: ?*Node) void {
        if (node == null) return;

        self.deinit(node.?.left);
        self.deinit(node.?.right);

        self.allocator.destroy(node.?);
    }
};

// =========================
// TREE PRINT
// =========================
fn printTree(node: ?*Node, level: usize) void {
    if (node == null) return;

    printTree(node.?.right, level + 1);

    var i: usize = 0;
    while (i < level) : (i += 1) {
        std.debug.print("    ", .{});
    }

    std.debug.print("{d}\n", .{node.?.value});

    printTree(node.?.left, level + 1);
}

// =========================
// MAIN
// =========================
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var tree = AVLTree.init(gpa.allocator());
    defer tree.deinit(tree.root);

    try tree.insertValue(8);
    try tree.insertValue(4);
    try tree.insertValue(10);
    try tree.insertValue(9);
    try tree.insertValue(15);
    try tree.insertValue(2);

    std.debug.print("\n=== INITIAL TREE ===\n", .{});
    printTree(tree.root, 0);

    std.debug.print("\nInOrder: ", .{});
    AVLTree.inOrder(tree.root);

    std.debug.print("\n\nDeleting 10...\n", .{});

    tree.deleteValue(10);

    std.debug.print("\n=== AFTER DELETE ===\n", .{});
    printTree(tree.root, 0);

    std.debug.print("\nInOrder: ", .{});
    AVLTree.inOrder(tree.root);

    std.debug.print("\n\n", .{});

    const found = tree.searchValue(9);

    if (found != null) {
        std.debug.print("Found value: {d}\n", .{found.?.value});
    } else {
        std.debug.print("Value not found\n", .{});
    }
}
