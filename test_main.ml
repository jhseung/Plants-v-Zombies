open OUnit2

let suite = "P-vs-C test suite" >:::
            Test_mega.tests @ Test_control.tests

let _ = run_test_tt_main suite
