package main

import "testing"

func TestConversions(t *testing.T) {
	t.Run("cToF", func(t *testing.T) {
		got := cToF(0)
		if got != 32 {
			t.Fatalf("cToF(0) = %v, want 32", got)
		}
		got = cToF(100)
		if got != 212 {
			t.Fatalf("cToF(100) = %v, want 212", got)
		}
	})
	t.Run("fToC", func(t *testing.T) {
		got := fToC(32)
		if got != 0 {
			t.Fatalf("fToC(32) = %v, want 0", got)
		}
		got = fToC(212)
		if got != 100 {
			t.Fatalf("fToC(212) = %v, want 100", got)
		}
	})
}

