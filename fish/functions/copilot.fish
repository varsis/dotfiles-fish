function qq --wraps github-copilot-cli --description "Alias github-copilot-cli what-the-shell"
    set TMPFILE (mktemp)
    trap "rm -f $TMPFILE" EXIT
    if /opt/homebrew/bin/github-copilot-cli what-the-shell "$argv" --shellout $TMPFILE
        if test -e $TMPFILE
            set FIXED_CMD (cat $TMPFILE)
            eval $FIXED_CMD
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

function gq --wraps github-copilot-cli --description "Alias github-copilot-cli git-assist"
    set TMPFILE (mktemp)
    trap "rm -f $TMPFILE" EXIT
    if /opt/homebrew/bin/github-copilot-cli git-assist "$argv" --shellout $TMPFILE
        if test -e $TMPFILE
            set FIXED_CMD (cat $TMPFILE)
            eval $FIXED_CMD
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

function ghq --wraps github-copilot-cli --description "Alias github-copilot-cli gh-assist"
    set TMPFILE (mktemp)
    trap "rm -f $TMPFILE" EXIT
    if /opt/homebrew/bin/github-copilot-cli gh-assist "$argv" --shellout $TMPFILE
        if test -e $TMPFILE
            set FIXED_CMD (cat $TMPFILE)
            eval $FIXED_CMD
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end
