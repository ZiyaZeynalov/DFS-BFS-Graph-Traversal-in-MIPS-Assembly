# My Program: DFS & BFS
# Ziya Zeynalov 20220935

    .data

    graph:      .space 360000           # Giving space for the graph's Adjacency Matrix (300 * 300 * 4 bytes)
    visitedarrayDFS: .space 1200        # Giving space to visited array (300 * 4 bytes)
    visitedarrayBFS: .space 1200        # Giving space to visited array (300 * 4 bytes)
    queue:       .space 1200            # Giving space to the BFS queue (300 * 4 bytes)
    front:       .word 0            # front start index of the queue 
    back:        .word 0            # back start index of the queue

    space:       .asciiz " "         # Space during printing
    newline:     .asciiz "\n"        # Newline during printing

    .text
    .globl main

main:      # Start of my code section
    # Reading numbers of N,M,V
    li $v0, 5              # To read integer
    syscall
    move $s0, $v0          # Storing N (vertices) in $s0

    li $v0, 5              # To read integer
    syscall
    move $s1, $v0          # Store M (edges) in $s1

    li $v0, 5              # To read integer
    syscall
    move $s2, $v0          # Store V (start vertex) in $s2

    jal settingGraph         # jumping to seting graph's Adjacency Matrix to 0s
    jal settingEdges        # jumping to inputing M edges to fill graph
    jal settingvisitedarrayDFS   # jumping to setting the whole visited array of DFS to 0s
    jal settingvisitedarrayBFS   # jumping to setting the whole visited array of BFS to 0s

    # DFS running from start vertex V
    move $a0, $s2          # Placing vertex V in $a0
    jal recursiveDFS      # jumping to recursive function of dfs

    li $v0, 4              # Printing newline after the DFS
    la $a0, newline        # Putting address of the newline string
    syscall

    # Setting front and back indices of the BFS queue to 0
    li $t5, 0              # $t5 is 0
    la $t6, front          # Loading address of front to $t6
    sw $t5, 0($t6)         # front is 0
    la $t7, back           # Loading address of back to $t7
    sw $t5, 0($t7)         # back is 0

    move $a0, $s2          # Placing enqueue start vertex V in $a0(into the BFS queue)
    jal enqueue            # jumping to enqueue

    subu $t8, $s2, 1       # converting to zero-based index
    sll $t9, $t8, 2        # calculating offset
    la $t0, visitedarrayBFS    # Loading base address of visitedarrayBFS to $t0
    addu $t1, $t0, $t9     # Calculating address of visitedarrayBFS[V-1]
    li $t2, 1              # $t2 is equal to 1 (which means visited)
    sw $t2, 0($t1)         # visitedarrayBFS[V-1] is visited
    jal bfs                # jumping to bfs to run from starting vertex V 

    li $v0, 4              # Printing newline after the BFS
    la $a0, newline        # Putting address of the newline string
    syscall

    li $v0, 10             # Exiting the main
    syscall


settingGraph:     # Setting graph's Adjacency Matrix to 0s
    la $t5, graph          # putting base address of graph to $t5
    mul $t6, $s0, $s0      # Putting number of elements in $t6 (num of vertecis)^2 

looping:
    beq $t6, $zero, endingLoop   # Looping until all elements initialized
    sw $zero, 0($t5)       # Making current element 0
    addi $t5, $t5, 4       # Going to next element (by 4 bytes)
    addi $t6, $t6, -1      # decreasing count by 1 
    j looping      # Repeating the loop

endingLoop:
    jr $ra                 # Returning back to caller


settingEdges:      # Inputing M edges to fill graph
    li $t7, 0              # Edge num is 0

loopingofsettingEdges:
    bge $t7, $s1, endingofsettingM  # stoping loop when all edges are inputed

    li $v0, 5              # reading integer to set as vertex u
    syscall
    move $t8, $v0          # putting vertex u to reg $t8
    li $v0, 5              # reading integer to set as vertex u
    syscall
    move $t9, $v0          # putting vertex u to reg $t9

    # Setting graph[u][v] to 1
    subu $t0, $t8, 1       # making u - 1 and place to $t0
    mul $t1, $t0, $s0      # $t1 is equal to (u - 1) * N
    subu $t2, $t9, 1       # $t2 is equal to v - 1
    addu $t3, $t1, $t2     # $t3 is index equal to sum of $t1 and $t2
    sll $t3, $t3, 2        # making byte offset
    la $t4, graph          # putting base address of graph to $t4
    addu $t5, $t4, $t3     # putting address of graph[u][v] to $t5
    li $t6, 1              # $t6 is equal to 1
    sw $t6, 0($t5)         # finally graph[u][v] is equal to 1

    # Setting graph[v][u] to 1 (As the graph must be undirected) 
    subu $t0, $t9, 1       # $t0 is equal to v - 1
    mul $t1, $t0, $s0      # $t1 is equal to (v - 1) * N
    subu $t2, $t8, 1       # $t2 is equal to u - 1
    addu $t3, $t1, $t2     # $t3 is index equal to sum of $t1 and $t2
    sll $t3, $t3, 2        # making byte offset
    la $t4, graph          # putting base address of graph to $t4
    addu $t5, $t4, $t3     # putting address of graph[v][u] to $t5
    sw $t6, 0($t5)         # finally graph[v][u] is equal to 1

    addi $t7, $t7, 1       # Edge num ++
    j loopingofsettingEdges     # Repeating the loop

endingofsettingM:
    jr $ra                 # Returning to caller


settingvisitedarrayDFS:   # Setting the whole visited array of DFS to 0s
    la $t8, visitedarrayDFS    # Putting base address of visitedarrayDFS to $t8
    move $t9, $s0          # $t9 is now number of vertices

loopingsettingvisitedarrayDFS:
    beq $t9, $zero, endofthisloop   # Looping until all vertices are initialized
    sw $zero, 0($t8)       # Setting current element to zero
    addi $t8, $t8, 4       # Going to the next element (by 4 bytes)
    addi $t9, $t9, -1      # decreasing count by 1
    j loopingsettingvisitedarrayDFS     # jumping to the start of loop

endofthisloop:
    jr $ra                 # Returning to caller


settingvisitedarrayBFS:    #Setting the whole visited array of BFS to 0s
    la $t0, visitedarrayBFS    # Putting base address of visitedarrayBFS to $t0
    move $t1, $s0          # $t1 is now number of vertices

loopingvisitedarrayloopBFS:
    beq $t1, $zero, endingofloopingBFS  # Looping until all vertices are initialized
    sw $zero, 0($t0)       # Setting current element to zero
    addi $t0, $t0, 4       # Going to the next element (by 4 bytes)
    addi $t1, $t1, -1      # decreasing count by 1
    j loopingvisitedarrayloopBFS     # jumping to the start of loop

endingofloopingBFS:
    jr $ra                 # Returning to caller


enqueue:     #Enqueuing vertex into BFS queue
    la $t2, back           # address of back is put to $t2
    lw $t3, 0($t2)         # current back index is placed to $t3 

    sll $t4, $t3, 2        # back * 4 is put to $t4 (offset)
    la $t5, queue          # base address of queue is placed at $t5 
    addu $t6, $t5, $t4     # address of back in queue is placed at $t6
    sw $a0, 0($t6)         # back in queue is put in vertex

    addi $t3, $t3, 1       # back's index ++
    move $t7, $s0          # size of queue is put in $t7
    bge $t3, $t7, enqueueBackwrap   # If back equal or more than N performing wrap around
    j skipwrapping                 #jumping there

enqueueBackwrap:
    subu $t3, $t3, $t7     # wrap around by sutracting N

skipwrapping:
    sw $t3, 0($t2)         # Updating back's index
    jr $ra                 # Returning to caller


recursiveDFS:    # recursive DFS implementation
    addi $sp, $sp, -12     # Allocating space on the stack
    sw $ra, 8($sp)         # Saving return address
    sw $s3, 4($sp)         # Saving $s3
    sw $a0, 0($sp)         # Saving current vertex

    # Use $s3 as loop variable
    subu $t0, $a0, 1       # $t0 is vertex - 1 
    sll $t1, $t0, 2        # $t1 is (vertex - 1) * 4 (bytes)
    la $t2, visitedarrayDFS    # base address of visitedarrayDFS is put in $t2
    addu $t3, $t2, $t1     # address of visitedarrayDFS(vertex - 1) is in $t3
    lw $t4, 0($t3)         # Loading visitedarrayDFS(vertex - 1)
    bne $t4, $zero, exitingDFS   # Exiting If already visited

    li $t5, 1              # $t5 is 1
    sw $t5, 0($t3)         # Marking current vertex as visited

    move $a1, $a0          # Saving current vertex in $a1 register
    li $v0, 1              # Printing current vertex
    move $a0, $a1          # returning it
    syscall

    li $v0, 4              # Syscall code for print string
    la $a0, space          # Placing space to print it
    syscall

    move $a0, $a1          # Restoring current vertex ($a0)
    li $s3, 1              # Initializing loop variable $s3 to 1 

loopingDFS:   # Looping through all possible vertices to find neighbors
    bgt $s3, $s0, exitingDFS   # Exiting loop If $s3 more than N

    # Checking if there's an edge between current vertex and vertex in $s3
    subu $t6, $a0, 1       # decremented vertex by 1 is put in $t6
    mul $t7, $t6, $s0      # decremented vertex time N is put in $t7 
    subu $t8, $s3, 1       # decremented i is in $t8
    addu $t9, $t7, $t8     # index is in $t9
    sll $t9, $t9, 2        # and then multiplied by 4
    la $t0, graph          # base address of graph is in $t0 
    addu $t1, $t0, $t9     # address of graph decremented vertex and i - 1 is in $t1 
    lw $t2, 0($t1)         # and then loaded to $t2
    beq $t2, $zero, nextvertexDFS   # If there is no edge going to next vertex

    # Checking if vertex in $s3 is visited
    subu $t3, $s3, 1       # decreasing i by 1
    sll $t3, $t3, 2        # and times 4
    la $t4, visitedarrayDFS    # base address of visitedarrayDFS is loaded to $t4 
    addu $t5, $t4, $t3     # address of visited array dfs decremented i is in $t5
    lw $t6, 0($t5)         # and loaded to $t6
    bne $t6, $zero, nextvertexDFS   # Moving to next vertex, if it's already visited

    move $a0, $s3          # Passing neighboring vertex $s3 to $a0
    jal recursiveDFS      # Recursive calling to recursiveDFS
    lw $a0, 0($sp)         # Restoring current vertex $a0 

nextvertexDFS:
    addi $s3, $s3, 1       # Incrementing i by 1
    j loopingDFS             # Repeating the loop

exitingDFS:
    lw $a0, 0($sp)         # Restoring $a0
    lw $s3, 4($sp)         # Restoring $s3
    lw $ra, 8($sp)         # Restoring $ra
    addi $sp, $sp, 12      # Returning back the stack space
    jr $ra  


bfs:       # My implementation of BFS 
    addi $sp, $sp, -20     # Allocating space on the stack
    sw $ra, 16($sp)        # Saving return address
    sw $s3, 12($sp)        # Saving $s3
    sw $s4, 8($sp)         # Saving $s4
    sw $s5, 4($sp)         # Saving $s5
    sw $s6, 0($sp)         # Saving $s6

loopingBFS:
    # The queue is empty if front is equal to back
    la $t7, front          # address of front is loaded in $t7
    lw $s3, 0($t7)         # front index loaded to $s3 
    la $t8, back           # address of back loaded to $t8
    lw $s4, 0($t8)         # back index is loaded to $s4 
    beq $s3, $s4, exitingBFS     #  Exiting BFS, if queue is empty,

    # Dequeuing current vertex
    sll $t9, $s3, 2        # front times 4 is put in $t9 as of byte offset
    la $t0, queue          # base address of queue is loaded to $t0 
    addu $t1, $t0, $t9     # address of queue front is calculated and loaded to $t1
    lw $s6, 0($t1)         # dequeued vertex is put in $s6

    # Incrementing front index with wrap-around if necessary
    addi $s3, $s3, 1       # incrementing front by 1
    move $t2, $s0          # queue size stored in $t2
    bge $s3, $t2, frontwrapingBFS   # jumping to wrap around, if front is more or equal to N
    j normalfrontBFS       # jumping to normalfrontBFS

frontwrapingBFS:
    subu $s3, $s3, $t2     # Subtracting N from front

normalfrontBFS:
    sw $s3, 0($t7)         # Updating front index

    li $v0, 1              # for printing current vertex 
    move $a0, $s6          # current vertex is put in $a0
    syscall

    li $v0, 4              # for printing string 
    la $a0, space          # for printing space 
    syscall
    li $s5, 1              # Initializing loop variable $s5 to 1

inloopingBFS:     # Looping through all possible neighbors of current vertex
    bgt $s5, $s0, continueloopBFS   # Exiting inner loop, if $s5 is more than N

    # Checking if there is an edge between current vertex and vertex in $s5
    subu $t3, $s6, 1       # decreasing current vertext by 1
    mul $t4, $t3, $s0      # multiplying it by N and store in $t4
    subu $t5, $s5, 1       # decreasing $s5 by 1
    addu $t6, $t4, $t5     # suming them and add to $t6 
    sll $t6, $t6, 2        # Byte offset
    la $t7, graph          # base address of graph is loaded to $t7 
    addu $t8, $t7, $t6     # address of graph current vertex - 1 and i - 1 is put in $t8
    lw $t9, 0($t8)         # loading this graph to $t9
    beq $t9, $zero, nextneighborBFS   # If there is no edge, going to next neighbor

    # Checking if vertex $s5 is already visited in BFS
    subu $t0, $s5, 1       # decreasing $s5 by 1
    sll $t0, $t0, 2        # byte offset
    la $t1, visitedarrayBFS    # base address of visitedarrayBFS is loaded to $t1 
    addu $t2, $t1, $t0     # address of visitedarrayBFS current vertex - 1 is put in $t2
    lw $t3, 0($t2)         # and loaded to $t3
    bne $t3, $zero, nextneighborBFS   # If it's already visited, going to next neighbor
    li $t4, 1              # $t4 is 1
    sw $t4, 0($t2)         # Marking vertex $s5 as visited in BFS 

    addi $sp, $sp, -4      # Allocating space on stack
    sw $ra, 0($sp)         # Saving return address before calling enqueue

    move $a0, $s5          # Passing neighbor vertex $s5 to $a0
    jal enqueue            # Enqueueing vertex $s5

    lw $ra, 0($sp)         # Restoring return address after enqueue returns
    addi $sp, $sp, 4       # Restoring the stack space

nextneighborBFS:
    addi $s5, $s5, 1       # Incrementing i by 1
    j inloopingBFS       # Repeating inner loop

continueloopBFS:
    j loopingBFS             # Repeaing outer loop

exitingBFS:
    lw $s6, 0($sp)         # Restoring $s6
    lw $s5, 4($sp)         # Restoring $s5
    lw $s4, 8($sp)         # Restoring $s4
    lw $s3, 12($sp)        # Restoring $s3
    lw $ra, 16($sp)        # Restoring return address
    addi $sp, $sp, 20      # Restoring the stack space
    jr $ra                 # Returning to caller
