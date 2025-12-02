abstract sig Person {
	father: lone Man,
	mother: lone Woman
	}

sig Man extends Person {
	wife: lone Woman
	}

sig Woman extends Person {
	husband: lone Man
	}

fact {
	no p: Person | p in p.^(mother+father)
	wife = ~husband
	}

assert NoSelfFather {
	no m: Man | m = m.father
	}

fun grandpas [p: Person] : set Person {
	let parent = mother + father + father.wife + mother.husband |
		p.parent.parent & Man
	}

pred ownGrandpa [p: Person] {
	p in p.grandpas
	}
