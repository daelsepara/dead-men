@echo off
del *.xzap *.zap *.z?
zilf -w deadmen.zil
zapf -ab deadmen.zap > deadmen_freq.xzap
del deadmen_freq.zap
zapf deadmen.zap
