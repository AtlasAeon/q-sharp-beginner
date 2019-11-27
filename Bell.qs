namespace Quantum.Bell {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation Set(desired : Result, q1 : Qubit) : Unit {
        if (desired != M(q1)) {
            X(q1);
        }
    }

    operation CreateBellState(q0 : Qubit, q1 : Qubit): (Unit) {
        H(q0);
        CNOT(q0, q1);
    }

    operation DeutschJozsaAlgorithm(q0 : Qubit, q1 : Qubit): (Unit) {
        X(q1);
        H(q0);
        H(q1);
        CNOT(q0, q1);
        H(q0);
    }

    operation Pachinko(count : Int, levels : Int) : (Int[]) {
        using (q = Qubit()) {
            for(test in 1..count) {
                Set(Zero, q);
                mutable score = 0;
                for (level in 1..levels) {
                    H(q);
                    let result = M(q);
                    if (result == One) {
                        set score += 1;
                    }
                }
            }
            Set(Zero, q);
        }

        return [1];
    }

    operation TestBellState(count : Int, initial : Result) : (Int, Int, Int) {
        mutable numOnes = 0;
        mutable agree = 0;
        using ((q0, q1) = (Qubit(), Qubit())) {
            for (test in 1..count) {
                Set(initial, q0);
                Set(Zero, q1);
                
                CreateBellState(q0, q1);
                let res = M(q0);

                if (M(q1) == res) {
                    set agree += 1;
                }

                // Count the number of ones we saw:
                if (res == One) {
                    set numOnes += 1;
                }
            }
            
            Set(Zero, q0);
            Set(Zero, q1);
        }

        // Return number of times we saw a |0> and number of times we saw a |1>
        return (count-numOnes, numOnes, agree);
    }
}
