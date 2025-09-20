# AUM Ternary Logic Gate Functions
# Mapping: A = +1, U = 0, M = -1

def AUM_NOT(x):
    if x == 1: return -1
    if x == -1: return 1
    return 0

def AUM_AND(x, y):
    return min(x, y)

def AUM_OR(x, y):
    return max(x, y)

def AUM_NAND(x, y):
    val = AUM_AND(x, y)
    return -val if val != 0 else 0

def AUM_NOR(x, y):
    val = AUM_OR(x, y)
    return -val if val != 0 else 0

def AUM_XOR(x, y):
    if x == y:
        return -1
    if (x == 1 and y == -1) or (x == -1 and y == 1):
        return 1
    return 0

def AUM_XNOR(x, y):
    val = AUM_XOR(x, y)
    return -val if val != 0 else 0
