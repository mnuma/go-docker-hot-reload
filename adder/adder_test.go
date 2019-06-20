package adder

import "testing"

func TestAdd(t *testing.T) {
	var result int
	result = Add(1, 2)
	if result != 3 {
		t.Errorf("add failed. expect:%d, actual:%d", 3, result)
	}
	t.Logf("result is %d", result)
}
