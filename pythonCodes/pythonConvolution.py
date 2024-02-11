import timeit
from datetime import date
mat1 = []
mat2 = []

print("Please enter matrix size:")
n = input()
while True:
    if n.isnumeric():
        n = int(n)
        break
    print("Invalid input, please try again:")
    n = input()

print("Please enter the first matrix:")
for _ in range(n) :
    mat1.append(list(map(float, input().split())))

print("Please enter matrix size:")
m = input()
while True:
    if m.isnumeric():
        m = int(m)
        break
    print("Invalid input, please try again:")
    m = input()


print("Please enter the second matrix:")
for _ in range(m) :
    mat2.append(list(map(float, input().split())))

t_0 = timeit.default_timer()

mat3 = [[0] * (n - m + 1) for _ in range(n - m + 1)]


for i in range(n - m + 1):
    for j in range(n - m + 1):
        for k in range(m):
            for l in range(m):
                mat3[i][j] += mat1[i + k][j + l] * mat2[k][l]

for i in range(n - m + 1) :
    for j in range(n - m + 1) :
        print(mat3[i][j], end = " ")
    print()


t_1 = timeit.default_timer()
 
elapsed_time = t_1 - t_0
f = open("TimeLog/timelog", "a")
f.write(today.strftime('%c') + "\n" + "Process finished in: " + str(elapsed_time) + "\n-----------------------------\n")
f.close()

