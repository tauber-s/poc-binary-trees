const std = @import("std");
const avl = @import("avl_tree.zig");
const AVLTree = avl.AVLTree;
const Node = avl.Node;
const testing = std.testing;

// =====================================
// HELPERS
// =====================================
fn nodeHeight(node: ?*Node) i32 {
    if (node == null) return 0;
    return node.?.height;
}

fn expectNode(node: ?*Node, expected: i32) !void {
    try testing.expect(node != null);
    try testing.expectEqual(expected, node.?.value);
}

fn isBalanced(node: ?*Node) bool {
    if (node == null) return true;

    const lh = nodeHeight(node.?.left);
    const rh = nodeHeight(node.?.right);

    if (@abs(lh - rh) > 1) {
        return false;
    }

    return isBalanced(node.?.left) and
        isBalanced(node.?.right);
}

fn countNodes(node: ?*Node) usize {
    if (node == null) return 0;

    return 1 +
        countNodes(node.?.left) +
        countNodes(node.?.right);
}

// =====================================
// BASIC INSERT
// =====================================
test "insert single value" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(10);

    try expectNode(tree.root, 10);
    try testing.expectEqual(@as(i32, 1), tree.root.?.height);
}

// =====================================
// SEARCH
// =====================================
test "search existing value" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(8);
    try tree.insertValue(4);
    try tree.insertValue(10);

    const result = tree.searchValue(4);

    try expectNode(result, 4);
}

test "search missing value" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(8);

    try testing.expect(tree.searchValue(999) == null);
}

// =====================================
// LEFT LEFT ROTATION
// =====================================
test "left-left rotation" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(30);
    try tree.insertValue(20);
    try tree.insertValue(10);

    //      20
    //     /  \
    //   10    30

    try expectNode(tree.root, 20);
    try expectNode(tree.root.?.left, 10);
    try expectNode(tree.root.?.right, 30);

    try testing.expect(isBalanced(tree.root));
}

// =====================================
// RIGHT RIGHT ROTATION
// =====================================
test "right-right rotation" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(10);
    try tree.insertValue(20);
    try tree.insertValue(30);

    try expectNode(tree.root, 20);
    try expectNode(tree.root.?.left, 10);
    try expectNode(tree.root.?.right, 30);

    try testing.expect(isBalanced(tree.root));
}

// =====================================
// LEFT RIGHT ROTATION
// =====================================
test "left-right rotation" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(30);
    try tree.insertValue(10);
    try tree.insertValue(20);

    try expectNode(tree.root, 20);
    try expectNode(tree.root.?.left, 10);
    try expectNode(tree.root.?.right, 30);

    try testing.expect(isBalanced(tree.root));
}

// =====================================
// RIGHT LEFT ROTATION
// =====================================
test "right-left rotation" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(10);
    try tree.insertValue(30);
    try tree.insertValue(20);

    try expectNode(tree.root, 20);
    try expectNode(tree.root.?.left, 10);
    try expectNode(tree.root.?.right, 30);

    try testing.expect(isBalanced(tree.root));
}

// =====================================
// DUPLICATES
// =====================================
test "duplicate values are ignored" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(10);
    try tree.insertValue(10);
    try tree.insertValue(10);

    try testing.expectEqual(@as(usize, 1), countNodes(tree.root));
}

// =====================================
// DELETE LEAF
// =====================================
test "delete leaf node" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(20);
    try tree.insertValue(10);
    try tree.insertValue(30);

    tree.deleteValue(10);

    try testing.expect(tree.searchValue(10) == null);
    try testing.expect(isBalanced(tree.root));
}

// =====================================
// DELETE NODE WITH ONE CHILD
// =====================================
test "delete node with one child" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(20);
    try tree.insertValue(10);
    try tree.insertValue(5);

    tree.deleteValue(10);

    try testing.expect(tree.searchValue(10) == null);
    try testing.expect(isBalanced(tree.root));
}

// =====================================
// DELETE NODE WITH TWO CHILDREN
// =====================================
test "delete node with two children" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(20);
    try tree.insertValue(10);
    try tree.insertValue(30);
    try tree.insertValue(25);
    try tree.insertValue(40);

    tree.deleteValue(30);

    try testing.expect(tree.searchValue(30) == null);
    try testing.expect(isBalanced(tree.root));
}

// =====================================
// DELETE ROOT
// =====================================
test "delete root node" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(10);

    tree.deleteValue(10);

    try testing.expect(tree.root == null);
}

// =====================================
// DELETE MISSING VALUE
// =====================================
test "delete missing value does nothing" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);

    try tree.insertValue(10);

    tree.deleteValue(999);

    try expectNode(tree.root, 10);
}

// =====================================
// LARGE INSERTION
// =====================================
test "large insertion keeps tree balanced" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);
    var i: i32 = 0;

    while (i < 1000) : (i += 1) {
        try tree.insertValue(i);
    }

    try testing.expect(isBalanced(tree.root));
}

// =====================================
// LARGE DELETE
// =====================================
test "large delete keeps tree balanced" {
    var tree = AVLTree.init(testing.allocator);
    defer tree.deinit(tree.root);
    var i: i32 = 0;

    while (i < 1000) : (i += 1) {
        try tree.insertValue(i);
    }

    i = 0;

    while (i < 500) : (i += 1) {
        tree.deleteValue(i);
    }

    try testing.expect(isBalanced(tree.root));
}
