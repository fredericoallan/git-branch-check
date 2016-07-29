# git branch check

Bash script to check if your branches was merged into master/develop origin comparing tag datetime

## Parameters

```
#@param
# - 1$(project git path): /home/user/projects/website
# - 2$(tag name)        : v.1.2.0
# - 3$(branches)        : hotfix_2345_john,hotfix_2346_david
```

## Execution

1) Open your linux terminal and execute like this example:

```sh
./git-branch-check.sh /home/user/projects/website v1.2.0 hotfix_2345_john,hotfix_2346_david

```

## Results

example:

```sh
0)Web Check:
..conection : OK
1)Your parameters:
..git path: /home/user/projects/website
..tag     : v1.2.0
..branches: OK
2)Enter on git path
..git path : OK
3)Tag info
..Tag Date: 2016-07-12 17:54:38
4)Branch validation
..branch  : hotfix_2345_john     | develop merged on: 2016-07-11 18:11:04 [-OK-] | master merged on: 2016-01-13 17:24:49 [FAIL]
..branch  : hotfix_2346_david    | develop merged on: 1900-01-01 00:00:00 [FAIL] | master merged on: 1900-01-01 00:00:00 [FAIL]

```
