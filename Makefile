ASFLAGS+=-W

CFLAGS+=-O1 -masm=intel -fno-asynchronous-unwind-tables

CPPFLAGS+=-Wall -Wextra -Wpedantic

BINS = fibonacci

FILES = main.o

all: build

.PHONY: all

debug: CFLAGS += -DDEBUG -g
debug: CPPFLAGS += -DDEBUG -g
debug:  $(FILES)
	gcc -o $(BINS) $(FILES) $(ASFLAGS) $(CPPFLAGS) $(CFLAGS)
	$(MAKE) clean


build: $(FILES)
	gcc -o $(BINS) $(FILES) $(ASFLAGS) $(CPPFLAGS) $(CFLAGS)
	$(MAKE) clean

clean:
	$(RM) *.o *.a

cleanAll:
	$(RM) $(BINS) *.o *.a