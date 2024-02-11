import timeit
from datetime import date

today = date.today()

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

t_0 = timeit.default_timer()

result = [[sum(a * b for a, b in zip(A_row, B_col)) 
                        for B_col in zip(*second_matrix)]
                                for A_row in first_matrix]

for i in range(n) :
    for j in range(n) :
        print(result[i][j], end = " ")
    print()

t_1 = timeit.default_timer()
 
elapsed_time = t_1 - t_0
f = open("TimeLog/timelog", "a")
f.write(today.strftime('%c') + "\n" + "Process finished in: " + str(elapsed_time) + "\n-----------------------------\n")
f.close()



