#!/bin/bash

#@param
# - 1$(project git path): /home/user/projects/website
# - 2$(tag name)        : v.1.2.0
# - 3$(branches)        : hotfix_2345_john,hotfix_2346_david

#./git-branch-check.sh /home/user/projects/website v1.2.0 hotfix_2345_john,hotfix_2346_david


#get param
dir=$1
tag=$2
branches=$3
origin1="develop"
origin2="master"
DAYS=30

#0) Função main
function main(){

  clear

  echo -en "\e[46m\n0)Web Check:\e[0;37m\n"
  #conection ok?
  if [ ! -z "$wcheck" ]; then
      echo "..conection : FAIL"
      exit
  else
      echo "..conection : OK"
  fi


  #validações se existem os parametros
  echo -en "\e[46m1)Your parameters:\e[0;37m\n"

  #if git path not exists
  if [ ! -d "$dir" ]; then
      echo "..FAIL    : invalid git path"
      exit
  else
      echo "..git path: $dir"
  fi

  #if tag null
  if [ -z "$tag" ]; then
      echo "..FAIL    : invalid tag"
      exit
  else
      echo "..tag     : $tag"
  fi

  #if branches null
  if [ -z "$branches" ]; then
      echo "..FAIL    : invalid Branches"
      exit
  else
      echo "..branches: OK"
  fi

  echo -en "\e[46m2)Enter on git path\e[0;37m\n"
  cd $dir
  echo "..git path : OK"

  #get tag datetime
  echo -en "\e[46m3)Tag date\e[0;37m\n"
  dtTag=$(tagInfo $tag)

  #if tag date null
  if [ -z "$dtTag" ]; then
      echo "..FAIL    : tag [$tag] doesn't exists"
      exit
  else
      echo "..Tag Date: $dtTag"
  fi


  #get each branch information
  echo -en "\e[46m4)Branch validation\e[0;37m\n"

  #branch split

  branchesList=$(echo $branches | tr "," "\n")

  for addr in $branchesList
  do
      dtDevelop=$(mergeCheck $origin1 $addr)
      dtMaster=$(mergeCheck $origin2 $addr)

      #echo "dates: $dtTag | $dtDevelop | $dtMaster"

      opDevelop=$(dateCompare "$dtTag" "$dtDevelop")
      opMaster=$(dateCompare "$dtTag" "$dtMaster")

      echo -e "..branch  : $addr \t\t| $origin1 merged on: $dtDevelop [$opDevelop] | $origin2 merged on: $dtMaster [$opDevelop]"
  done

}

#function to verify webconection
function webCheck(){
  wcheck=$(curl -sL www.google.com.br | grep -oP "<title>Google</title>")
  echo $wcheck
}

#function to get tag datetime
function tagInfo(){

    #get tag date time from tag PARAMETERS $1
  local ltag="$1"

  dthrTag=$(git log -1 --format=%ai $ltag | awk '{print $1" "$2}')

  echo $dthrTag

}

#function to get  merge datetime
function mergeCheck(){

  local lorigin="$1"
  local lbranch="$2"

  dthrMerge=$(git branch -r --merged | grep $lbranch | xargs --no-run-if-empty git merge-base refs/heads/$lorigin | xargs --no-run-if-empty git log -n 1 --pretty=format:%ai | awk '{print $1" "$2}')

  if [ -z "$dthrMerge" ];then
      dthrMerge="1900-01-01 00:00:00"
  fi

  echo $dthrMerge

}

#function for compare dates > <=
function dateCompare(){

  local ldatatag=0
  local ldatabranch=0

  #if not null, convert string to date bash format
  if [ ! -z "$ldatatag" ]; then
    ldatatag=`date --date="$1" +%s`
  fi

  #if not null, convert string to date bash format
  if [ ! -z "$ldatabranch" ]; then
    ldatabranch=`date --date="$2" +%s`
  fi

  #echo "fredteste: $ldatabranch"

  #if pass invalid datetime 1900-01-01 00:00:00
  #-eq =
  if [ $ldatabranch -eq -2208977612 ]; then
    op="FAIL"
  else
    #-ge >=
    if [ $ldatatag -ge $ldatabranch ]; then
      op="-OK-"
    else
      op="FAIL"
    fi
  fi

  echo $op

}

#call main function
main
