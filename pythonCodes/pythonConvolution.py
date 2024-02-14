# Diba Hadi
# Pr. Jahangir
# Calculate colvolution by python
import timeit
from datetime import date
mat1 = []
mat2 = []

today = date.today()

# get the first matrix size
print("Please enter matrix size:")
n = input()
# get input until it's valid
while True:
    if n.isnumeric():
        n = int(n)
        break
    print("Invalid input, please try again:")
    n = input()

# get the first matrix and append to a list line by line
print("Please enter the first matrix:")
for _ in range(n) :
    mat1.append(list(map(float, input().split())))


# get second matrix size
print("Please enter matrix size:")
m = input()
# get until it's valid
while True:
    if m.isnumeric():
        m = int(m)
        break
    print("Invalid input, please try again:")
    m = input()

# get the second matrix size and append to the array
print("Please enter the second matrix:")
for _ in range(m) :
    mat2.append(list(map(float, input().split())))

# set the timer to calculate excution time
t_0 = timeit.default_timer()

# create matrix for saving result
mat3 = [[0] * (n - m + 1) for _ in range(n - m + 1)]


# convolution loop
for i in range(n - m + 1):
    for j in range(n - m + 1):
        for k in range(m):
            for l in range(m):
                mat3[i][j] += mat1[i + k][j + l] * mat2[k][l]

# print the result of convolution
for i in range(n - m + 1) :
    for j in range(n - m + 1) :
        print(mat3[i][j], end = " ")
    print()

# get the finish time
t_1 = timeit.default_timer()
 
#  calculate the time passed
elapsed_time = t_1 - t_0
# write the date and time along with the result in the log file
f = open("TimeLog/timelog", "a")
f.write(today.strftime('%c') + "\n" + "Process finished in: " + str(elapsed_time) + "\n-----------------------------\n")
f.close()

