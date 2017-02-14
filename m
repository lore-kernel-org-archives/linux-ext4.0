From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 4/4] tests: 3 level hash tree test
Date: Tue, 14 Feb 2017 13:40:34 -0700
Message-ID: <40D3354F-7FF3-44E1-A122-0C0D21042BFF@dilger.ca>
References: <1486977617-17216-1-git-send-email-artem.blagodarenko@gmail.com>
 <1486977617-17216-5-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5E89F8EB-582D-4545-BBE1-359BA7D59705";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36158 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbdBNUkj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Feb 2017 15:40:39 -0500
Received: by mail-it0-f65.google.com with SMTP id f200so7073491itf.3
        for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2017 12:40:39 -0800 (PST)
In-Reply-To: <1486977617-17216-5-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5E89F8EB-582D-4545-BBE1-359BA7D59705
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 13, 2017, at 2:20 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> Test is added that recreate directory (-fD fsck option)
> with 47.5k of 255-symbol name files. This amount of files
> can not be stored only in 2 hevel htree, so 3 levels are used.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> ---
> tests/f_large_dir/debugfs_script |   15 +++++++++++++++
> tests/f_large_dir/expect         |   12 ++++++++++++
> tests/f_large_dir/name           |    1 +
> tests/f_large_dir/script         |   28 ++++++++++++++++++++++++++++
> 4 files changed, 56 insertions(+), 0 deletions(-)
>=20
> diff --git a/tests/f_large_dir/debugfs_script =
b/tests/f_large_dir/debugfs_script
> new file mode 100755
> index 0000000..b869db5
> --- /dev/null
> +++ b/tests/f_large_dir/debugfs_script

Instead of making a separate script to supply the commands to debugfs,
this could be part of the test script and then just piped into debugfs?
That keeps all the logic in one place in the test script and makes it
easier to see what the test is doing.

> @@ -0,0 +1,15 @@
> +#!/bin/bash
> +echo "feature large_dir"
> +echo "mkdir /foo"
> +echo "cd /foo"
> +touch foofile
> +echo "write foofile foofile"
> +for i in $(seq 47300); do

(style) "for ((i =3D 0; i < 47300; i++)); do" avoids an external shell =
command

It might be useful to show how "47300" is derived, something like:

	NAMELEN=3D255
	DIRENT_SZ=3D8
	BLOCKSZ=3D1024
	DIRENT_PER_LEAF=3D$(((BLOCKSZ / (NAMELEN + DIRENT_SZ)))
	HEADER=3D32
	INDEX_SZ=3D8
	INDEX_L1=3D$(((BLOCKSZ - HEADER) / INDEX_SZ))
	INDEX_L2=3D$(((BLOCKSZ - DIRENT_SZ) / INDEX_SZ))
	ENTRIES=3D$((INDEX_L1 * INDEX_L2 * DIRENT_PER_LEAF))

which gives 47244 entries to overflow the L2 htree.

> +	[[ $(( $i % 3 )) -eq 0 ]] && \

(style) no need for '$' inside $((...))

> +	echo "expand ./"

(style) no need to continue this line

> +	[[ $(( $i % 5000 )) -eq 0 ]] && \
> +	>&2 echo "$i processed"

(style) same two as above

> +	new_uuid=3D`printf %0255X $i`

(style) prefer $(...) as used above
(style) not sure I'd call this a "uuid", maybe just "filename"? Or maybe
        just get rid of echo and "new_uuid" entirely and use:

         printf "ln foofile %0255X\n" $i

> +	echo "ln foofile $new_uuid"
> +done
> +
> diff --git a/tests/f_large_dir/expect b/tests/f_large_dir/expect
> new file mode 100644
> index 0000000..9c94675
> --- /dev/null
> +++ b/tests/f_large_dir/expect
> @@ -0,0 +1,12 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 3A: Optimizing directories
> +Pass 4: Checking reference counts
> +Inode 13 ref count is 1, should be 47301.  Fix? yes
> +
> +Pass 5: Checking group summary information
> +
> +test.img: ***** FILE SYSTEM WAS MODIFIED *****
> +test.img: 13/115368 files (0.0% non-contiguous), 32839/460800 blocks
> +Exit status is 1
> diff --git a/tests/f_large_dir/name b/tests/f_large_dir/name
> new file mode 100644
> index 0000000..4b96890
> --- /dev/null
> +++ b/tests/f_large_dir/name
> @@ -0,0 +1 @@
> +optimize 3 level htree directories
> diff --git a/tests/f_large_dir/script b/tests/f_large_dir/script
> new file mode 100644
> index 0000000..25983c2
> --- /dev/null
> +++ b/tests/f_large_dir/script
> @@ -0,0 +1,28 @@
> +OUT=3D$test_name.log
> +EXP=3D$test_dir/expect
> +DFSCRIPT=3D$test_dir/debugfs_script
> +E2FSCK=3D../e2fsck/e2fsck
> +
> +TMPFILE2=3D/tmp/image

Why not use the existing $TMPFILE?  That is sure to be in the right =
location,
while hard-coding "/tmp/image" can fail for various reasons (e.g. /tmp =
is
too small, another test is using /tmp/image when running tests in =
parallel,
or worse it is some important file).

> +cp /dev/null $OUT
> +$MKE2FS -b 1024 -O large_dir,uninit_bg,dir_nlink -F $TMPFILE2 460800 =
> /dev/null
> +$DFSCRIPT | $DEBUGFS -w -f /dev/stdin $TMPFILE2 > /dev/null

Something like:

{
	echo "feature large_dir"
	echo "mkdir /foo"
	echo "cd /foo"
	touch foofile
	echo "write foofile foofile"
	for ((i =3D 0; i < $ENTRIES; i++)); do
		[[ $((i % 3)) =3D=3D 0 ]] && echo "expand ./"
		[[ $((i % 5000)) =3D=3D 0 ]] && echo "$i processed" 1>&2
		printf "ln foofile %0255X\n" $i
	done
} | $DEBUGFS -w -f /dev/stdin $TMPFILE2 > /dev/null

> +$E2FSCK -yfD $TMPFILE2 > $OUT.new 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT.new
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE2;test.img;" $OUT.new >> =
$OUT
> +rm -f $OUT.new
> +
> +cmp -s $OUT $EXP
> +RC=3D$?
> +if [ $RC -eq 0 ]; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff -u $EXP $OUT > $test_name.failed
> +fi
> +
> +
> +
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_5E89F8EB-582D-4545-BBE1-359BA7D59705
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYo2tCpIg59Q01vtYRAk2AAJ0Rc9q1z1zqx43puYUKbY3ZqvDfTQCfUgI2
DQG/kDf9cHu6W93jprVssO0=
=JEEQ
-----END PGP SIGNATURE-----

--Apple-Mail=_5E89F8EB-582D-4545-BBE1-359BA7D59705--
