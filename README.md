# DFS & BFS Graph Traversal in MIPS Assembly
![MIPS](https://img.shields.io/badge/Language-MIPS-blue)
![Algorithms](https://img.shields.io/badge/Algorithms-DFS%20%26%20BFS-green)

A MIPS assembly program that demonstrates Depth-First Search (DFS) and Breadth-First Search (BFS) on a graph represented by an adjacency matrix. The program allows for exploration of vertices in a user-defined graph, starting from a specified vertex.

---

## How It Works

The program reads the number of vertices (N), edges (M), and the starting vertex (V) from the user. It then builds the adjacency matrix, initializes visited arrays, and performs DFS and BFS traversals from the starting vertex. The output displays the order of vertex traversal for both DFS and BFS.

### Program Flow:
1. **Graph Setup**: Initialize adjacency matrix and visited arrays.
2. **DFS Traversal**: Recursively explore connected vertices starting from V.
3. **BFS Traversal**: Explore vertices level by level using a queue.

---

## Features

- **Adjacency Matrix Representation**: Stores edges between vertices in a 300x300 matrix.
- **Recursive DFS**: Implements DFS recursively to traverse connected nodes.
- **Queue-based BFS**: Uses a queue to manage nodes in BFS traversal.
- **Memory Optimization**: Allocates necessary memory for graph, queue, and visited arrays.

---

## Project Structure

The program consists of the following main functions:
- **main**: Reads input values for N, M, V, and initializes graph and traversal arrays.
- **settingGraph**: Sets all elements in the adjacency matrix to 0.
- **settingEdges**: Adds edges between vertices based on user input.
- **recursiveDFS**: Recursively traverses connected vertices in DFS order.
- **bfs**: Performs BFS using a queue for level-order traversal.
- **enqueue**: Adds a vertex to the BFS queue.
- **settingvisitedarrayDFS/BFS**: Initializes DFS and BFS visited arrays to 0.

---

## Getting Started

### Prerequisites

To run the program, you need a MIPS emulator like SPIM or QtSPIM.

### Running the Program

1. **Load the program** into your MIPS simulator.
2. **Execute the program**. You will be prompted to enter values for:
   - Number of vertices (N)
   - Number of edges (M)
   - Starting vertex (V)

### Sample Output
```
Enter number of vertices (N): 4
Enter number of edges (M): 3
Enter start vertex (V): 1

DFS Traversal: 1 2 3 4
BFS Traversal: 1 2 3 4
```

---

## Customization

You can modify the maximum vertices by adjusting the `.space` declarations in the `.data` segment.

---

## Acknowledgments

- **MIPS Assembly Language**: This project serves as an educational example of implementing DFS and BFS in assembly.
- **Graph Algorithms**: Inspired by classic graph traversal techniques.
