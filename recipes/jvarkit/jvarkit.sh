#!/bin/bash
# jvarkit executable shell script, adapted from snpEff shell script


set -eu -o pipefail
set -o pipefail
export LC_ALL=en_US.UTF-8

# Find original directory of bash script, resolving symlinks
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in/246128#246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

JAR_DIR=${DIR}

java=java

if [ -n "${JAVA_HOME:=}" ]; then
  if [ -e "$JAVA_HOME/bin/java" ]; then
      java="$JAVA_HOME/bin/java"
  fi
fi

# extract memory and system property Java arguments from the list of provided arguments
# http://java.dzone.com/articles/better-java-shell-script
default_jvm_mem_opts="-Xms512m -Xmx1g"
jvm_mem_opts=""
jvm_prop_opts=""
pass_args=""
jar_name=""
for arg in "$@"; do
    case $arg in
        '-J-D'*)
            jvm_prop_opts="$jvm_prop_opts ${arg:2}"
            ;;
        '-J-XX'*)
            jvm_prop_opts="$jvm_prop_opts ${arg:2}"
            ;;
         '-J-Xm'*)
            jvm_mem_opts="$jvm_mem_opts ${arg:2}"
            ;;
         *)
            # first argument is the name of the jvarkit tool
            if [[ "${jar_name}" == "" ]]
            then
            	jar_name="${arg}"
            else
            	pass_args="$pass_args $arg"
            fi
            ;;
    esac
done

if [ "$jvm_mem_opts" == "" ]; then
    jvm_mem_opts="$default_jvm_mem_opts"
fi


pass_arr=($pass_args)


if [ "${jar_name}" == "" ]
then
	 echo "jvarkit tool name missing"  1>&2
	 echo "Available tools are:" 1>&2
	 find "${JAR_DIR}" -type f -name "*.jar" -exec basename '{}' ';' | sed 's/\(\-fat\).jar$//' | sort | uniq 1>&2
	 exit 1
fi

if [ ! -f "${JAR_DIR}/${jar_name}-fat.jar" ]
then
	 echo "jvarkit jar file '${JAR_DIR}/${jar_name}.jar' missing/not available in bioconda or check your arguments."  1>&2
	 echo "Available tools are:" 1>&2
	 find "${JAR_DIR}" -type f -name "*.jar" -exec basename '{}' ';' | sed 's/\(\-fat\).jar$//' | sort | uniq 1>&2
	 exit 1
fi


if [[ ${pass_arr[0]:=} == org* ]]
then
    eval "$java" $jvm_mem_opts $jvm_prop_opts -cp "$JAR_DIR/${jar_name}-fat.jar" $pass_args
else
    eval "$java" $jvm_mem_opts $jvm_prop_opts -jar "$JAR_DIR/${jar_name}-fat.jar" $pass_args
fi
exit
