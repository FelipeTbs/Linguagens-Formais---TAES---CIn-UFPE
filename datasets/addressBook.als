abstract sig Target {}

sig Addr extends Target {}
sig Name extends Target {}
sig Book {addr: Name -> Target}

fact Acyclic {all b: Book | no n: Name | n in n.^(b.addr)}

pred add [b, b': Book, n: Name, t: Target] {
	b'.addr = b.addr + n -> t
	}

fun lookup [b: Book, n: Name]: set Addr {n.^(b.addr) & Addr}

assert addLocal {
	all b,b': Book, n,n': Name, t: Target |
		add [b,b',n,t] and n != n' => lookup [b,n'] = lookup [b',n']
	}
