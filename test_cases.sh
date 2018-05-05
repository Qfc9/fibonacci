make debug
clear

# error
./fibonacci

# 0x0
./fibonacci 0

# 00
./fibonacci -o 0

# 0x1333db76a7c594bfc3
./fibonacci 100

# 046317333552370545137703
./fibonacci -o 100

# error
./fibonacci 10 10

# error
./fibonacci -f 10

# error
./fibonacci 10 10 10

# error
./fibonacci -o 10 10

# No Memory leaks
valgrind ./fibonacci
valgrind ./fibonacci 0
valgrind ./fibonacci -o 0
valgrind ./fibonacci 100
valgrind ./fibonacci -o 100
valgrind ./fibonacci 10 10
valgrind ./fibonacci -f 10
valgrind ./fibonacci 10 10 10
valgrind ./fibonacci -o 10 10