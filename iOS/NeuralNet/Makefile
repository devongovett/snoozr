CC=clang

FRAMEWORKS:= -framework Foundation -framework Accelerate
LIBRARIES:= -lobjc

SOURCE=SNNeuralNet.m main.m

CFLAGS=-Wall -fobjc-arc -g $(SOURCE)
LDFLAGS=$(LIBRARIES) $(FRAMEWORKS)
OUT=main

all:
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(OUT)
	./$(OUT)