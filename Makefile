BIN_A=/usr/local/bin/cproc # The untrusted compiler

# does the full ddc comparison
all: stage2
	$(info    Comparing untrusted A to C(sA, A) and untrusted C(sA, A) to C(sA, C(sA, T)))
	cmp $(BIN_A) ./stage0/cproc
	cmp ./stage0/cproc ./stage2/cproc

# setup dependencies (qbe and untrusted compiler cproc, A)
.PHONY: deps
deps:
	$(MAKE) -C ./qbe-1.2 clean
	$(MAKE) -C ./qbe-1.2
	sudo cp ./qbe-1.2/qbe /usr/local/bin/qbe
	rm ./cproc/config.mk
	cp stage1.mk ./cproc/config.mk
	$(MAKE) -C ./cproc clean
	$(MAKE) -C ./cproc
	sudo cp ./cproc/cproc /usr/local/bin/cproc
	sudo cp ./cproc/cproc-qbe /usr/local/bin/cproc-qbe
	rm ./cproc/config.mk
 	cp regenerate.mk ./cproc/config.mk
	$(MAKE) -C ./cproc clean
	$(MAKE) -C ./cproc
	sudo cp ./cproc/cproc /usr/local/bin/cproc

# compile cproc source with untrusted cproc, C(sA, A)
.PHONY: self-regenerate
self-regenerate:
	rm ./cproc/config.mk
	cp regenerate.mk ./cproc/config.mk
	$(MAKE) -C ./cproc clean
	$(MAKE) -C ./cproc
	mkdir ./stage0
	mv ./cproc/cproc ./stage0/
	mv ./cproc/cproc-qbe ./stage0/


# compile cproc with trusted gcc, C(sA, T)
.PHONY: stage1
stage1: self-regenerate
	rm ./cproc/config.mk
	cp stage1.mk ./cproc/config.mk
	$(MAKE) -C ./cproc clean
	$(MAKE) -C ./cproc
	mkdir ./stage1
	mv ./cproc/cproc ./stage1/
	mv ./cproc/cproc-qbe ./stage1/

# compile cproc with result of stage1, C(sA, C(sA, T))
.PHONY: stage2
stage2: stage1
	rm ./cproc/config.mk
	cp stage2.mk ./cproc/config.mk
	$(MAKE) -C ./cproc clean
	$(MAKE) -C ./cproc
	mkdir ./stage2
	mv ./cproc/cproc ./stage2/
	mv ./cproc/cproc-qbe ./stage2/

.PHONY: clean
clean:
	rm -rf ./stage0 ./stage1 ./stage2
