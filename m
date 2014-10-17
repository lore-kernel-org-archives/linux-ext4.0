From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] xfstests: update 'new' script
Date: Fri, 17 Oct 2014 15:36:00 +0800
Message-ID: <20141017073600.GM13912@dhcp-13-216.nay.redhat.com>
References: <1413295189-28530-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaJQHgH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Oct 2014 03:36:07 -0400
Content-Disposition: inline
In-Reply-To: <1413295189-28530-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2014 at 05:59:48PM +0400, Dmitry Monakhov wrote:
> - Update script to support new test cheme tests/$fs_type/$TEST_IDX
> - Try to use first unused ID
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  new |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------------------
>  1 files changed, 55 insertions(+), 23 deletions(-)
> 
> diff --git a/new b/new
> index f3e6fa1..9fa522e 100755
> --- a/new
> +++ b/new
> @@ -32,10 +32,22 @@ _cleanup()
>      :
>  }
>  
> -if [ ! -f group ]
> +SRC_GROUPS=`find tests -not -path tests -type d -printf "%f "`
> +function usage 

Trailing whitespace here.

> +{
> +    echo "Usage $0 test_dir"
> +    echo "Available dirs are: $SRC_GROUPS"
> +    exit
> +}
> +
> +[ $# -eq 0 ] && usage
> +tdir=tests/$1
> +shift
> +
> +if [ ! -f $tdir/group ]
>  then
> -    echo "Creating the group index ..."
> -    cat <<'End-of-File' >group
> +    echo "Creating the $tdir/group index ..."
> +    cat <<'End-of-File' >$tdir/group
>  # QA groups control
>  #
>  # define groups and default group owners
> @@ -51,10 +63,10 @@ other		some-user-login
>  End-of-File
>  fi
>  
> -if [ ! -w group ]
> +if [ ! -w $tdir/group ]
>  then
> -    chmod u+w group
> -    echo "Warning: making the index file \"group\" writeable"
> +    chmod u+w $tdir/group
> +    echo "Warning: making the index file \"$tdir/group\" writeable"
>  fi
>  
>  if make
> @@ -64,13 +76,26 @@ else
>      echo "Warning: make failed -- some tests may be missing"
>  fi
>  
> -last=`grep '^[0-9][0-9]* ' group | sort | tail -1 | sed -e 's/[ 	].*//'`
> -# get rid of leading 0s as can be interpreted as octal
> -last=`echo $last | sed 's/^0*//'`
> -id=`$AWK_PROG </dev/null 'BEGIN{printf "%03d\n",'$last'+1}'`
> +i=0
> +line=0
> +[ -f "$tdir/group" ] || usage
> +
> +for found in `cat $tdir/group | gawk '{ print $1 }'`
> +do
> +    line=$((line+1))
> +    if [ -z "$found" ] || [ "$found" == "#" ];then
> +	continue
> +    fi
> +    i=$((i+1))
> +    id=`printf "%03d" $i`
> +    if [ "$id" != "$found" ];then
> +	break
> +    fi
> +done
> +

If the group file is all in shape and first unused id is the lastid+1,
the script fails here, ./new btrfs could reproduce this

 # ./new btrfs
 .....
 Next test is 078
 Error: test 078 already exists!

Thanks,
Eryu
>  echo "Next test is $id"
>  
> -if [ -f $id ]
> +if [ -f $tdir/$id ]
>  then
>      echo "Error: test $id already exists!"
>      _cleanup
> @@ -81,7 +106,7 @@ echo -n "Creating skeletal script for you to edit ..."
>  
>  year=`date +%Y`
>  
> -cat <<End-of-File >$id
> +cat <<End-of-File >$tdir/$id
>  #! /bin/bash
>  # FS QA Test No. $id
>  #
> @@ -146,11 +171,12 @@ End-of-File
>  sleep 2		# latency to read messages to this point
>  echo ""
>  
> -chmod 755 $id
> -${EDITOR-vi} $id
> +chmod 755 $tdir/$id
> +${EDITOR-vi} $tdir/$id
>  
>  if [ $# -eq 0 ]
>  then
> +
>      while true
>      do
>  	echo -n "Add to group(s) [other] (? for list): "
> @@ -158,12 +184,15 @@ then
>  	[ -z "$ans" ] && ans=other
>  	if [ "X$ans" = "X?" ]
>  	then
> -	    $AWK_PROG <group '
> -BEGIN		{ text = "# ???" }
> -/^[a-z]/	{ printf "%-16.16s %s\n",$1,text; text = "# ???"; next }
> -NF < 2		{ next }
> -		{ text = $0 }' \
> -	    | sort
> +	    for d in $SRC_GROUPS; do
> +		l=$(sed -n < tests/$d/group \
> +		    -e 's/#.*//' \
> +		    -e 's/$/ /' \
> +		    -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
> +		grpl="$grpl $l"
> +	    done
> +	    lst=`for word in $grpl; do echo $word; done | sort| uniq `
> +	    echo $lst
>  	else
>  	    break
>  	fi
> @@ -173,18 +202,21 @@ else
>      #
>      for g in $*
>      do
> -	if grep "^$g[ 	]" group >/dev/null
> +	if grep "^$g[ 	]" $tdir/group >/dev/null
>  	then
>  	    :
>  	else
> -	    echo "Warning: group \"$g\" not defined in ./group"
> +	    echo "Warning: group \"$g\" not defined in $tdir/group"
>  	fi
>      done
>      ans="$*"
>  fi
>  
>  echo -n "Adding $id to group index ..."
> -echo "$id $ans" >>group
> +head -n $(($line-1)) $tdir/group > /tmp/$$.group
> +echo "$id $ans" >> /tmp/$$.group
> +tail -n +$((line)) $tdir/group >> /tmp/$$.group
> +mv /tmp/$$.group $tdir/group
>  echo " done."
>  
>  exit 0
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
