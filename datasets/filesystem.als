abstract sig Object {}

sig Dir extends Object {contents: set Object}

one sig Root extends Dir { }

sig File extends Object {}

fact {
	Object in Root.*contents
	}

assert SomeDir {
	all o: Object - Root | some contents.o
	}
check SomeDir 

assert RootTop {
	no o: Object | Root in o.contents
	}
check RootTop

assert FileInDir {
	all f: File | some contents.f
	}
check FileInDir 
