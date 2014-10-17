From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] xfstests: update 'new' script
Date: Fri, 17 Oct 2014 11:56:33 +0400
Message-ID: <87wq7zt9hq.fsf@openvz.org>
References: <1413295189-28530-1-git-send-email-dmonakhov@openvz.org> <20141017073600.GM13912@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34555 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQH4m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2014 03:56:42 -0400
In-Reply-To: <20141017073600.GM13912@dhcp-13-216.nay.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Eryu Guan <eguan@redhat.com> writes:

> On Tue, Oct 14, 2014 at 05:59:48PM +0400, Dmitry Monakhov wrote:
>> - Update script to support new test cheme tests/$fs_type/$TEST_IDX
>> - Try to use first unused ID
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  new |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------------=
------
>>  1 files changed, 55 insertions(+), 23 deletions(-)
>>=20
>> diff --git a/new b/new
>> index f3e6fa1..9fa522e 100755
>> --- a/new
>> +++ b/new
>> @@ -32,10 +32,22 @@ _cleanup()
>>      :
>>  }
>>=20=20
>> -if [ ! -f group ]
>> +SRC_GROUPS=3D`find tests -not -path tests -type d -printf "%f "`
>> +function usage=20
>
> Trailing whitespace here.
>
>> +{
>> +    echo "Usage $0 test_dir"
>> +    echo "Available dirs are: $SRC_GROUPS"
>> +    exit
>> +}
>> +
>> +[ $# -eq 0 ] && usage
>> +tdir=3Dtests/$1
>> +shift
>> +
>> +if [ ! -f $tdir/group ]
>>  then
>> -    echo "Creating the group index ..."
>> -    cat <<'End-of-File' >group
>> +    echo "Creating the $tdir/group index ..."
>> +    cat <<'End-of-File' >$tdir/group
>>  # QA groups control
>>  #
>>  # define groups and default group owners
>> @@ -51,10 +63,10 @@ other		some-user-login
>>  End-of-File
>>  fi
>>=20=20
>> -if [ ! -w group ]
>> +if [ ! -w $tdir/group ]
>>  then
>> -    chmod u+w group
>> -    echo "Warning: making the index file \"group\" writeable"
>> +    chmod u+w $tdir/group
>> +    echo "Warning: making the index file \"$tdir/group\" writeable"
>>  fi
>>=20=20
>>  if make
>> @@ -64,13 +76,26 @@ else
>>      echo "Warning: make failed -- some tests may be missing"
>>  fi
>>=20=20
>> -last=3D`grep '^[0-9][0-9]* ' group | sort | tail -1 | sed -e 's/[ 	].*/=
/'`
>> -# get rid of leading 0s as can be interpreted as octal
>> -last=3D`echo $last | sed 's/^0*//'`
>> -id=3D`$AWK_PROG </dev/null 'BEGIN{printf "%03d\n",'$last'+1}'`
>> +i=3D0
>> +line=3D0
>> +[ -f "$tdir/group" ] || usage
>> +
>> +for found in `cat $tdir/group | gawk '{ print $1 }'`
>> +do
>> +    line=3D$((line+1))
>> +    if [ -z "$found" ] || [ "$found" =3D=3D "#" ];then
>> +	continue
>> +    fi
>> +    i=3D$((i+1))
>> +    id=3D`printf "%03d" $i`
>> +    if [ "$id" !=3D "$found" ];then
>> +	break
>> +    fi
>> +done
>> +
>
> If the group file is all in shape and first unused id is the lastid+1,
> the script fails here, ./new btrfs could reproduce this
>
Ohh, Indeed. I've missed that case, sorry. Will resend the path shortly.
>  # ./new btrfs
>  .....
>  Next test is 078
>  Error: test 078 already exists!
>
> Thanks,
> Eryu
>>  echo "Next test is $id"
>>=20=20
>> -if [ -f $id ]
>> +if [ -f $tdir/$id ]
>>  then
>>      echo "Error: test $id already exists!"
>>      _cleanup
>> @@ -81,7 +106,7 @@ echo -n "Creating skeletal script for you to edit ..."
>>=20=20
>>  year=3D`date +%Y`
>>=20=20
>> -cat <<End-of-File >$id
>> +cat <<End-of-File >$tdir/$id
>>  #! /bin/bash
>>  # FS QA Test No. $id
>>  #
>> @@ -146,11 +171,12 @@ End-of-File
>>  sleep 2		# latency to read messages to this point
>>  echo ""
>>=20=20
>> -chmod 755 $id
>> -${EDITOR-vi} $id
>> +chmod 755 $tdir/$id
>> +${EDITOR-vi} $tdir/$id
>>=20=20
>>  if [ $# -eq 0 ]
>>  then
>> +
>>      while true
>>      do
>>  	echo -n "Add to group(s) [other] (? for list): "
>> @@ -158,12 +184,15 @@ then
>>  	[ -z "$ans" ] && ans=3Dother
>>  	if [ "X$ans" =3D "X?" ]
>>  	then
>> -	    $AWK_PROG <group '
>> -BEGIN		{ text =3D "# ???" }
>> -/^[a-z]/	{ printf "%-16.16s %s\n",$1,text; text =3D "# ???"; next }
>> -NF < 2		{ next }
>> -		{ text =3D $0 }' \
>> -	    | sort
>> +	    for d in $SRC_GROUPS; do
>> +		l=3D$(sed -n < tests/$d/group \
>> +		    -e 's/#.*//' \
>> +		    -e 's/$/ /' \
>> +		    -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
>> +		grpl=3D"$grpl $l"
>> +	    done
>> +	    lst=3D`for word in $grpl; do echo $word; done | sort| uniq `
>> +	    echo $lst
>>  	else
>>  	    break
>>  	fi
>> @@ -173,18 +202,21 @@ else
>>      #
>>      for g in $*
>>      do
>> -	if grep "^$g[ 	]" group >/dev/null
>> +	if grep "^$g[ 	]" $tdir/group >/dev/null
>>  	then
>>  	    :
>>  	else
>> -	    echo "Warning: group \"$g\" not defined in ./group"
>> +	    echo "Warning: group \"$g\" not defined in $tdir/group"
>>  	fi
>>      done
>>      ans=3D"$*"
>>  fi
>>=20=20
>>  echo -n "Adding $id to group index ..."
>> -echo "$id $ans" >>group
>> +head -n $(($line-1)) $tdir/group > /tmp/$$.group
>> +echo "$id $ans" >> /tmp/$$.group
>> +tail -n +$((line)) $tdir/group >> /tmp/$$.group
>> +mv /tmp/$$.group $tdir/group
>>  echo " done."
>>=20=20
>>  exit 0
>> --=20
>> 1.7.1
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQMuxAAoJEFzOBSYIXfveUL8P/2Rsl99XxUzg8naHWKcH2FLE
KTJj+rhxzuXovb/hwozQguGJ0jEaClxm8Vob+j6lVBEis8Epe2nIeNujIkU1SkB0
5LY8vC2mcas2ktqk2jxD8wQS+8qxcvodW7dtefzDhFmQeotl/tyZlSRbIhxRQ4mC
ikpmypC5TkRvVspyKFlzYZ1GxtYKrC2P1ZhEMxAVyRvBhDsPtIAa5APkJYqjn2ch
m5TSCrErXcvWnqXGjHSo6qxy7kmb8lBMP7pv+OXOQmc4rsofUM3xiJ+M1q9JLKJw
A9Ks86ssYQ7/WcT6zyuMOVkeIlNMFFV1Y+TGrJw8jDoeD1nj3VXOgR0gp8IV8to2
Zh0x8cHeT1cKzpM6zn4MPAmmdsotbpvXzcnpEqTbRONzyrX9N/jOlZ66XDFlSnCD
wnKELUeKkgwNg4ubn0TIXsNf+PoKAfqUh81SJT7L1Cf9WOktXfj/1dyD0z39cmKZ
rAIIH4rPAmubYFFnXEVW7AwQYArRD955iBuXv+NrCr2lI/xGQxFiQE4Scy2Y3H6E
Uu9z4fTHfm2/KFml3SkvftMRBnPakdp3XxkbyceCyMqghW5UbnN1Yy0gkbFhPt9d
F+OyBNo9H55YEFigmpI1jwXP+bS7NjeAyOyuYvneSI4ZPpZ148h1uJxVfubvYvRX
Z5/ZuWMVsvi1TK7af5DX
=L6ko
-----END PGP SIGNATURE-----
--=-=-=--
