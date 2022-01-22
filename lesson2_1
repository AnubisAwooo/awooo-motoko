import Array "mo:base/Array";

actor QuickSort {

    func copy(source: [var Int], s1: Nat, dist: [var Int], s2: Nat, size: Nat): () {
        var i = 0;
        while(i < size) {
            dist[s2 + i] := source[s1 + i];
            i += 1;
        };
    };

    func quicksort(arr: [var Int], start: Nat, end: Nat): () {
        if (start < end) {
            let value = arr[start];
            var i1 = 0;
            var i2 = 0;
            var i3 = 0;
            var a1 = Array.init<Int>(arr.size(), 0);
            var a3 = Array.init<Int>(arr.size(), 0);
            
            var i: Nat = start;
            while (i < end) {
                if (arr[i] < value) {
                    a1[i1] := arr[i];
                    i1 += 1;
                } else if (arr[i] > value) {
                    a3[i3] := arr[i];
                    i3 += 1;
                } else {
                    i2 += 1;
                };
                i += 1;
            };

            copy(a1, 0, arr, start, i1);
            copy(Array.init<Int>(i2, value), 0, arr, start + i1, i2);
            copy(a3, 0, arr, start + i1 + i2, i3);
            
            quicksort(arr, start, start + i1);
            quicksort(arr, start + i1 + i2, end);
        }
    };
  
    // Increment the value of the counter.
    public func qsort(arr: [Int]) : async [Int] {
        let temp = Array.thaw<Int>(arr);
        quicksort(temp, 0, temp.size());
        Array.freeze(temp)
    };
};
