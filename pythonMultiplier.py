print("Please enter matrix size:")

n = input()
while True:
    if n.isnumeric():
        n = int(n)
        break
    print("Invalid input, please try again:")
    n = input()

first_matrix = []
second_matrix = []

print("Please enter the first matrix:")
for _ in range(n) :
    first_matrix.append(list(map(float, input().split())))


print("Please enter the second matrix:")
for _ in range(n) :
    second_matrix.append(list(map(float, input().split())))

result = [[sum(a * b for a, b in zip(A_row, B_col)) 
                        for B_col in zip(*second_matrix)]
                                for A_row in first_matrix]

for i in range(n) :
    for j in range(n) :
        print(result[i][j], end = " ")
    print()