#!/bin/sh

# Outputs information about files
# Can be used for exampel to to get the configuration in .gitattributes done
# Git directories (.git) are ignored
#
# filetype.sh [path] [-t]
#
# [path] Path to a file or a directory
#        If no path is given, the current workding directory is used.
#
# [t]    Tabularized and sorted output
#        Depending on the number of files, this may take some time until the output is created.
#        Makes only sense for directories.
#        The sorting criteria is the charset

# TODO
# - Change order of input parameters: [-t] [path]

table_output="false"

# Gets the desired information from a file
get_file_info() {
    file_path="$1"
    if [ -f "$file_path" ]; then
        file_mime_type="$(   file -b -i "$file_path" | sed "s/;.*//")"
        file_mime_charset="$(file -b -i "$file_path" | sed "s/.*; //")"

        file_eol="$(file -b "$file_path" | grep -e " CRLF " -e " LF " | sed -e "s#.* \(CRLF\) .*#\1#" | sed "s/CRLF/crlf/")"
        if [ -z "$file_eol" ]; then
            file_eol="lf"
            if [ -n "$(echo "$file_mime_charset" | grep "binary")" ]; then
                file_eol="N/A"
            fi
        fi

        #echo "$file_path: $file_mime_type: $file_mime_charset: eol=$file_eol"
        if [ "$table_output" == "true" ]; then
            printf "%s:%s:%s:%s\n" "$file_mime_charset" "eol=$file_eol" "$file_path" "$file_mime_type"
        else
            printf "%s %s %s %s\n" "$file_mime_charset" "eol=$file_eol" "$file_path" "$file_mime_type"
        fi
    fi
}


# Calls get_file_info(), either in a single call or in a loop over a directory
get_file_info_wrapper() {
    if [ -f "$1" ]; then
        get_file_info "$1"
    elif [ -d "$1" ]; then
        for f in $(find "$1" -not -path "*/.git/*"); do
            get_file_info "$f"
        done
    else
        # should not happen
        echo "Error: input is not a file nor a directory"
        exit 1
    fi
}

# Processes the input parameters and calls get_file_info_wrapper()
if [ "$#" -eq "0" ]; then
        get_file_info_wrapper "."
elif [ "$#" -eq "1" ]; then
    if [ "$1" == "." ]; then
        get_file_info_wrapper "."
    elif [ "$1" == "-t" ]; then
        table_output="true"
        get_file_info_wrapper "." | column -t -s ":" | sort
    else
        get_file_info_wrapper "$1"
    fi
else
    if [ "$2" == "-t" ]; then
        table_output="true"
        get_file_info_wrapper "$1" | column -t -s ":" | sort
    else
        get_file_info_wrapper "$1"
    fi
fi

exit 0

