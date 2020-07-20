all: clean
	zilf -w deadmen.zil
	-zapf -ab deadmen.zap > deadmen_freq.xzap
	rm deadmen_freq.zap
	zapf deadmen.zap

test: clean
	zilf -w deadmen.zil
	zapf deadmen.zap
	
clean:
	rm -f *.xzap *.zap *.z?
