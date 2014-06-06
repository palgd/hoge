#!/bin/bash
# div-convert file
divconvert()
{
  local src=$1
  local dst=`divname $1`
  if [ ! -d $dst ]; then
    divcreate $dst
  fi
  cat $src | divwrite $dst
  divchangemtime $dst $src
}

# div-name file
divname()
{
  case $1 in
  *.div|*.div/)
    echo `undivname $1`.div
    ;;
  *)
    echo $1.div
    ;;
  esac
}

# undiv-name file.div
undivname()
{
  basename $1 .div
}

divcreate()
{
  local dst=$1
  #local src=`undiv-name $1`
  if [ ! -d $dst ]; then
    mkdir -p $dst
    (cd $dst; divcreatelsl `divname $dst`)
    touch -r $dst/ls-l $dst/linked
    touch -r $dst/ls-l $dst/sha1
  fi
}

divcreatelsl()
{
  touch $1
  ls -l $1 > ls-l
  rm $1
}

# div-write file.dir
divwrite()
{
  local dst=`followlink $1`
  if [ ! -d $dst ]; then
    divcreate $dst
  else
    divtrunc $dst
  fi
  (cd $dst; split -a 5 -b 1m - M)
  divupdatesha1 $dst
  divchangesize $dst
  divchangemtimelast $dst
}

# follow-link src.div
followlink()
{
  local src=$1
  while [ -f $src/link ]
  do
    src=`cat $src/link`
  done
  echo $src
}

# div-trunc dst.div
divtrunc()
{
  local dst=`followlink $1`
  divparts $dst | while read p
  do
    rm $p
  done
  divchangesize $dst
  divchangemtimenow $dst
}

# div-parts file.dir
divparts()
{
  local dst=`followlink $1`
  find $dst -name 'M*' | sort | while read f
  do
    case $f in
    *.ref)
      d=`dirname $f`
      src=`cat $d/refer`
      bn=`basename $f .ref`
      echo $src/$bn
      ;;
    *)
      echo $f
      ;;
    esac
  done
}

# div-change-size dst.div
divchangesize()
{
  local dst=`followlink $1`
  local size=`divsize $dst`
  #local tmp=$dst/div-change-size.$$
  #awk -v sz="$size" '{$5=sz;print}' $dst/ls-l >$tmp
  #touch -r $dst/ls-l $tmp
  #mv $tmp $dst/ls-l
  divreplacelsl $dst 4 "$size" 
}

# div-size file.div
divsize()
{
  #local src=`follow-link $1`
  #local sum=0
  divparts $1 | while read p 
  do
    # here is sub-shell
    stat -f "%z" $p
    #sum=`expr $sum + $s`
    #echo $sum
  done | divcount
}


divcount()
{
  local s=0
  while read n
  do
    s=`expr $s + $n`
  done
  echo $s
}

# div-replace-ls-l dst.div n val
divreplacelsl()
{
  local dst=$1
  local n=$2
  local val=$3
  local tmp=$dst/div-replace-ls-l.$$
  divsubstrlsl $dst $n "$val" >$tmp
  touch -r $dst/ls-l $tmp
  mv $tmp $dst/ls-l
}

# div-substr-ls-l src.div n val
divsubstrlsl()
{
  local src=$1
  local n=$2
  local val=$3
  local a=(`cat $src/ls-l`)
  a[$n]=$val
  echo ${a[@]}
}

divchangemtimenow()
{
  local dst=`followlink $1`
  local now=$dst/now.$$
  touch $now
  divchangemtime $dst $now
  rm $now
}

# div-change-mtime dst.div time_file
divchangemtime()
{
  local dst=`followlink $1`
  local last=$2
  local a=(`ls -l $last`)
  #md=`ls -l $last | awk '{print $6}'`
  #mt=`ls -l $last | awk '{print $7}'`
  #local tmp=$dst/div-change-mtime.$$
  #awk -v md="$md" -v mt="$mt" '{$6=md;$7=mt;print}' $dst/ls-l >$tmp
  #mv $tmp $dst/ls-l
  #touch -r $last $dst/ls-l
  divreplacelsl $dst 5 "${a[5]}" 
  divreplacelsl $dst 6 "${a[6]}" 
}

# div-sha1 dst.div
divupdatesha1()
{
  local dst=`followlink $1`
  local tmp=$dst/div-update-sha1.$$
  divparts $dst | while read p 
  do
    if [ ! $p -ot $dst/sha1 ]; then
      cat $p | openssl sha1 | awk -v x=`basename $p` '{print $1,x}' 
    else
      grep $p $dst/sha1
    fi
  done >$tmp
  mv $tmp $dst/sha1
}

divchangemtimelast()
{
  local dst=`followlink $1`
  local last=`divlastpart $dst`
  divchangemtime $dst $last 
}

divlastpart()
{
  local dst=`followlink $1`
  divparts $dst | tail -1
}


divconvert $1
