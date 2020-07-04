#!/bin/bash

if [[ $# == 0 ]];then
    echo "Three params needed[Input \"--help\" for more details]"
    exit
fi

if [[ $1 == "--help" ]];then
    echo "[repalce opt] Input:"
    echo "./ini_config .  \"xxx = 1\" \"xxx = 0\""
    echo "[add opt] Input:"
    echo "./ini_config .  \"xxx = 1\" \"yyy = 0\""
    echo "[delete opt] Input:"
    echo "./ini_config .  \"xxx = 1\" \"\""
    exit
fi

echo "Searching path:";
echo "$1";
echo "str will be replace or add above:"
echo "$2";
echo "str will insert:"
echo "$3";

sourceStr=`echo $2 | cut -d ' ' -f 1` 
destStr=`echo $3 | cut -d ' ' -f 1`
echo "******************************************************"

oldIFS=$IFS
#set IFS to ";" 否则下面for循环会把grep结果按照空格拆分为多行
IFS=";"
i=0


for file in `grep -rn "$2" "$1"`
do
    #d不处理当前脚本文件内容
    if [[ "$file" == *$0* ]];then
         continue
    fi
    # reset IFS to old 方便接下来的命令从各个grep结果中提取完整文件名称
    IFS=$oldIFS
    file_name=`echo $file | cut -d ':' -f 1`
    let i++
    echo $file_name
    #using " to avoid $n cant be referring
	#必须把sed命令用""包围，使用''的话，不会去转义$n
    if [[ $sourceStr == $destStr ]];then
        echo "replace opt"
		#前面提取了带操作字段的内容，如果旧字段与新字段大部分相同，说明是修改动作，否则是新增或者删除
        sed -i "s/$2/$3/g" ${file_name}
    else
        if [[ '' == $destStr ]];then
            echo "delete opt"
            sed -i "/$2/d" ${file_name}
        else
            echo "add opt"
            sed -i "/$2/i $3" ${file_name}
        fi
    fi
done
echo "modify $i file(s) "
