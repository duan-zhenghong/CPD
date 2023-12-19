#!/bin/bash
# *********************************************************
# author: zhenghong
# creat: 2022.03.15
# *********************************************************
set -eux
set -o pipefail

# check install file
ls diff_cover-6.4.4-py3-none-any.whl

# check dependence
which python
function check_dependence()
{
    echo "import $1"|python
}

check_dependence pip

if ! echo "import diff_cover" | python >/dev/null 2>&1;then
    python -m pip install diff_cover-6.4.4-py3-none-any.whl
fi
