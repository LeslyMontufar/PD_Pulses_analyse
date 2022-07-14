with open('texto.txt','r') as f:
	comp = f.read();

nros = '\n'.join(comp.split("\n' '\n"))
print(nros)

with open('texto.txt','w') as f:
	f.write(nros);

f.close()