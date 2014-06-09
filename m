From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] tests: fix left-over e2fsprogs-tmp files not getting clean up
Date: Mon, 9 Jun 2014 14:34:45 -0600
Message-ID: <3C6E678A-D052-40A1-BDEE-84A386CEB887@dilger.ca>
References: <20140609144901.GE8418@thunk.org> <1402325451-5275-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2DF73C37-9FFE-4413-80DB-040767B1147D"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	bensberg@justemail.net
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43920 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaFIUel (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2014 16:34:41 -0400
Received: by mail-pb0-f53.google.com with SMTP id md12so5389901pbc.12
        for <linux-ext4@vger.kernel.org>; Mon, 09 Jun 2014 13:34:41 -0700 (PDT)
In-Reply-To: <1402325451-5275-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2DF73C37-9FFE-4413-80DB-040767B1147D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 9, 2014, at 8:50 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> diff --git a/tests/f_mmp/script b/tests/f_mmp/script
> index d921672..8d7ab1f 100644
> --- a/tests/f_mmp/script
> +++ b/tests/f_mmp/script
> @@ -1,8 +1,5 @@
> FSCK_OPT=3D-yf
>=20
> -TMPFILE=3D$test_name.tmp
> -> $TMPFILE
> -
> stat -f $TMPFILE | grep -q "Type: tmpfs"
> if [ $? =3D 0 ]; then
> 	rm -f $TMPFILE
>         echo "$test_name: $test_description: skipped for tmpfs (no =
O_DIRECT)"
>         return 0
> fi

The reason I created these temp files on the local filesystem instead of
on /tmp where $TMPFILE normally is normally located is because tmpfs =
does
not support O_DIRECT.  With the current patch all of these tests would =
be
skipped in the default test configuration.

I think it makes more sense to change the tests to just delete $TMPFILE
before creating the local TMPFILE.

Cheers, Andreas

> diff --git a/tests/f_mmp_garbage/script b/tests/f_mmp_garbage/script
> index 02cc12a..9ff4d8e 100644
> --- a/tests/f_mmp_garbage/script
> +++ b/tests/f_mmp_garbage/script
> @@ -1,8 +1,5 @@
> FSCK_OPT=3D-yf
>=20
> -TMPFILE=3D$test_name.tmp
> -> $TMPFILE
> -
> stat -f $TMPFILE | grep -q "Type: tmpfs"
> if [ $? =3D 0 ] ; then
> 	rm -f $TMPFILE
> diff --git a/tests/m_mmp/script b/tests/m_mmp/script
> index 02b0b4b..1ed284d 100644
> --- a/tests/m_mmp/script
> +++ b/tests/m_mmp/script
> @@ -2,8 +2,6 @@ DESCRIPTION=3D"enable MMP during mke2fs"
> FS_SIZE=3D65536
> MKE2FS_DEVICE_SECTSIZE=3D2048
> export MKE2FS_DEVICE_SECTSIZE
> -TMPFILE=3D$test_name.tmp
> -> $TMPFILE
> stat -f $TMPFILE | grep -q "Type: tmpfs"
> if [ $? =3D 0 ]; then
> 	rm -f $TMPFILE
> diff --git a/tests/t_mmp_1on/script b/tests/t_mmp_1on/script
> index 8fc8158..b99aad9 100644
> --- a/tests/t_mmp_1on/script
> +++ b/tests/t_mmp_1on/script
> @@ -1,8 +1,5 @@
> FSCK_OPT=3D-yf
>=20
> -TMPFILE=3D$test_name.tmp
> -> $TMPFILE
> -
> stat -f $TMPFILE | grep -q "Type: tmpfs"
> if [ $? =3D 0 ] ; then
> 	rm -f $TMPFILE
> diff --git a/tests/t_mmp_2off/script b/tests/t_mmp_2off/script
> index 1dee14e..6822278 100644
> --- a/tests/t_mmp_2off/script
> +++ b/tests/t_mmp_2off/script
> @@ -1,8 +1,5 @@
> FSCK_OPT=3D-yf
>=20
> -TMPFILE=3D$test_name.tmp
> -> $TMPFILE
> -
> stat -f $TMPFILE | grep -q "Type: tmpfs"
> if [ $? =3D 0 ]; then
> 	rm -f $TMPFILE
> diff --git a/tests/test_one.in b/tests/test_one.in
> index d053fd7..01a9260 100644
> --- a/tests/test_one.in
> +++ b/tests/test_one.in
> @@ -28,9 +28,10 @@ fi
>=20
> . $TEST_CONFIG
>=20
> -TMPFILE=3D$(mktemp -t e2fsprogs-tmp.XXXXXX)
> -
> test_name=3D`echo $test_dir | sed -e 's;.*/;;'`
> +
> +TMPFILE=3D$(mktemp -t e2fsprogs-tmp-$test_name.XXXXXX)
> +
> if [ -f $test_dir ] ; then
> 	exit 0;
> fi
> --=20
> 2.0.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2DF73C37-9FFE-4413-80DB-040767B1147D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU5YaZXKl2rkXzB/gAQIj2xAArRe4m771fS3DX99123AzBKYYf3tfMc2O
Qi8BT4FxB9J3NKyOqRJLQX+6lAHyrhduk5rldU7mx1vmOhLMr4FzUGFYpFXBhMPb
WswmWnpd0KqPxtQo2jbTgFBfUFzEfJz89tPnOIqruZCSwNhQM871GpUIiP/wFnR/
EZcAD6jyDkwp4cjGMETNn5/7yBYfwzt98FNeoXb+AdvdM+OBuhS3v9wNxw/rEsN2
yLKxssWoA4SphdhgFMQ5pvcrfPRhZ2uDR4yE5+avW6IPuxYnog2L3Fq2NLcOxltT
WVC2QYu/nTVlg5xZM5umRQTL6i8wp8At0ZfZJk6gxHRz/WcAmbBy9V0jVzw1IEm/
MrJwoXv+aS58O6J9PbtwMowWuTREbEJzgQFQSwXlwfgU1Qmod2Wmuoz8/k5QW+wp
ikOBisFXxRW3vF+MNTiHsjIjF1Yf2RhhRG9kzbIX0BeS2Lj7FLOutceLPhV0rqL2
xM0IQ616RE1seRLJOolqceAj65NuIruy9dgRXH9MIJWtUF2WgfWZxygsJbVyX6mD
PemQkyqdwzw7gxsD54v5g8NyUnfatw1isuL7raDvzW9H4csUYfESd4IXvnraTR02
jvC/akrMoy8ZE7QwxZoB2KEkOt0qapkgjvrPSJOIFRX66Y1AL5eZJHra0qDtpeQF
aoSodAH5Idc=
=xVft
-----END PGP SIGNATURE-----

--Apple-Mail=_2DF73C37-9FFE-4413-80DB-040767B1147D--
