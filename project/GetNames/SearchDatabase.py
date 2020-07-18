import psycopg2
import psycopg2.extras
def connect():
    conn_string = "host=localhost dbname=names user=postgres password=kaan"
    conn = psycopg2.connect(conn_string)
    cursor = conn.cursor()
    return cursor


def infer_gender(name, cursor):
    #take the first word of the name
    #print name
    if(' ' in name):
        part=name.split(' ')
        name=part[0]
    # conn_string = "host=localhost dbname=names user=postgres password=kaan"
    # conn = psycopg2.connect(conn_string)
    # cursor = conn.cursor()
    name=name.lower().title()
    print (name)

    cursor.execute('SELECT * from name_gender where firstname like \''+name+'\'')
    tot_fem=0
    tot_mal=0
    for row in cursor:
        # print (row)
        if(row[1]=='F    '):
            tot_fem=tot_fem+row[2]
        else:
            tot_mal=tot_mal+row[2]

    if(tot_mal>tot_fem):
        gender='m'
        prob=tot_mal/float(tot_mal+tot_fem)
    elif(tot_fem>tot_mal):
        gender='f'
        prob=1-tot_fem/float(tot_fem+tot_mal)
    else:
        gender=-1
        prob=0.5
    #returns the probability to be male
    return gender, prob

cursor = connect()
count = 0
array = []
f = open('output.txt', 'w')


with open("realnames.txt", "r") as ins:
    for line in ins:
        print(str(count))
        # print(line)
        gender ,prob = infer_gender(line, cursor)
        array.append(prob)
        f.write(str(prob) + '\n')
        # print(gender)
        # print(prob)
        count = count +1

f.close()

