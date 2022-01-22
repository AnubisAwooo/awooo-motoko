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
        if (start + 1 < end) {
            var is: Nat = start; // 位置起始
            var ie: Nat = start; // 位置终止
            let value = arr[is]; // 值
            var last = end; // 最后不能使用的值

            var i1 = is + 1;
            while(i1 < end) { // 循环每一个数字
                if (arr[i1] < value) { // 数字小于值
                    arr[is] := arr[i1]; // 赋值给起始
                    arr[i1] := value; // 当前位置赋值值
                    is += 1; // 起始位置往后移动
                    ie += 1; // 终止位置往后移动
                } else if (arr[i1] == value) { // 数字等于值
                    ie += 1; // 此时只移动终止位置即可 
                } else { // 数字大于值
                    if (last <= 0) {
                        i1 := end; // 跳出循环
                    } else {
                        // 1. 要从后面寻找到一个小于等于值的位置
                        // 2. 找不到的话应该退出移动
                        var i2 = last - 1;
                        var found = false;
                        var index = 0;
                        while (i1 < i2) { // 如果还存在值就进行寻找
                            if (arr[i2] <= value) { // 这个位置可以用
                                found := true;
                                index := i2;
                                i2 := i1; // 这样会跳出循环
                            };
                            i2 -= 1;
                        };
                        if (found) {
                            arr[is] := arr[index]; // 把 index 位置移动到起始
                            arr[index] := arr[i1]; // 把当前大的数字移动到 index
                            arr[i1] := value; // 当前位置赋值值
                            is += 1; // 起始位置往后移动
                            ie += 1; // 终止位置往后移动
                            last := index; // 记录位置下次使用
                        } else {
                            // 如果没有发现那么说明已经分开了
                            i1 := end; // 跳出循环
                        };
                    };
                };
                i1 += 1;
            };

            quicksort(arr, start, is);
            quicksort(arr, ie + 1, end);
        }
    };

    public func qsort(arr: [Int]) : async [Int] {
        let temp = Array.thaw<Int>(arr);
        quicksort(temp, 0, temp.size());
        Array.freeze(temp)
    };
};
