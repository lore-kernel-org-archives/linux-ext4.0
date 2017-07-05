From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/4] tests: add test for e2image -b option
Date: Wed, 5 Jul 2017 16:27:15 -0600
Message-ID: <1416FCF2-F47E-4272-A7AB-D291CDE6269E@dilger.ca>
References: <1498496326-76684-1-git-send-email-artem.blagodarenko@gmail.com>
 <1498496326-76684-4-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8C11F100-7658-48C8-8367-C33578EDEEEC";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34050 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbdGEW12 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 18:27:28 -0400
Received: by mail-it0-f66.google.com with SMTP id o202so16171331itc.1
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jul 2017 15:27:28 -0700 (PDT)
In-Reply-To: <1498496326-76684-4-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8C11F100-7658-48C8-8367-C33578EDEEEC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 26, 2017, at 10:58 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> The test makes raw image from partition with broken super block
> and executes e2fsck.

It's great to have a test case for this.

If possible, it is preferred to create new test cases by writing a =
script that formats a new filesystem and induces corruption via debugfs =
or dd or similar.  That makes it easier to see what is actually =
corrupted in the filesystem.

Cheers, Andreas

> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> ---
> tests/i_zero_super/expect   |   22 ++++++++++++++++++++++
> tests/i_zero_super/image.gz |  Bin 0 -> 13262 bytes
> tests/i_zero_super/script   |   36 =
++++++++++++++++++++++++++++++++++++
> 3 files changed, 58 insertions(+), 0 deletions(-)
>=20
> diff --git a/tests/i_zero_super/expect b/tests/i_zero_super/expect
> new file mode 100644
> index 0000000..863d692
> --- /dev/null
> +++ b/tests/i_zero_super/expect
> @@ -0,0 +1,22 @@
> +test.img was not cleanly unmounted, check forced.

Shouldn't this report something about using the backup superblock?

> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +Free blocks count wrong for group #0 (7987, counted=3D7982).
> +Fix? no
> +
> +Free blocks count wrong (11602, counted=3D11597).
> +Fix? no
> +
> +Free inodes count wrong for group #0 (1493, counted=3D1488).
> +Fix? no
> +
> +Free inodes count wrong (2997, counted=3D2992).
> +Fix? no
> +
> +
> +test.img: ********** WARNING: Filesystem still has errors **********
> +
> +test.img: 11/3008 files (0.0% non-contiguous), 398/12000 blocks
> diff --git a/tests/i_zero_super/image.gz b/tests/i_zero_super/image.gz
> new file mode 100644
> index =
0000000000000000000000000000000000000000..eea9140194f4dd9ec9dc8bb7b9e2215b=
950587d2
> GIT binary patch
> literal 13262
> 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
>=20
> literal 0
> HcmV?d00001
>=20
> diff --git a/tests/i_zero_super/script b/tests/i_zero_super/script
> new file mode 100644
> index 0000000..5952c6f
> --- /dev/null
> +++ b/tests/i_zero_super/script
> @@ -0,0 +1,36 @@
> +if test -x $E2IMAGE_EXE; then
> +
> +IMAGE=3D$test_dir/image.gz
> +FSCK_OPT=3D-fy
> +OUT=3D$test_name.log
> +EXP=3D$test_dir/expect
> +
> +cp /dev/null $OUT

Truncating a file can be done directly by the shell, like: "> $OUT".

> +
> +gzip -d < $IMAGE > $TMPFILE
> +
> +$E2IMAGE_EXE -r -b 8193 $TMPFILE $TMPFILE.raw
> +$FSCK -n -b 8193 $TMPFILE.raw > $OUT.new 2>&1
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE.raw;test.img;" $OUT.new >> =
$OUT

This could avoid a temp output file and filter the result directly, =
like:

$FSCK -n -b 8193 $TMPFILE.raw |
	sed -f $cmd_dir/filter.sed -e 's;$TMPFILE.raw;test.img;' > $OUT

> +
> +rm -f $TMPFILE
> +rm -f $TMPFILE.raw
> +rm -f $OUT.new

These can be a single "rm" command.

> +cmp -s $OUT $EXP
> +status=3D$?
> +
> +if [ "$status" =3D 0 ] ; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff $EXP $OUT > $test_name.failed
> +	rm -f $test_name.tmp
> +fi
> +
> +unset IMAGE FSCK_OPT OUT EXP
> +
> +else #if test -x $E2IMAGE_EXE; then

Not sure what the comment here is?  This should be the "if ! test -x" =
branch?

> +	echo "$test_name: $test_description: skipped"
> +fi
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_8C11F100-7658-48C8-8367-C33578EDEEEC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZXWfFpIg59Q01vtYRApsZAJ0Ys46LsAkWL4sAy3sJAVl5ze4L8ACfVgXA
mC95+MK3GAmNSCZ0Q7b7MZc=
=ZPQD
-----END PGP SIGNATURE-----

--Apple-Mail=_8C11F100-7658-48C8-8367-C33578EDEEEC--
