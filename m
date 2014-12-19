From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] fs: make generic_block_fiemap sig-tolerant PING2...
Date: Fri, 19 Dec 2014 12:13:50 +0300
Message-ID: <87egrwf1dd.fsf@openvz.org>
References: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org> <871toikt7c.fsf@openvz.org> <87zjavehsx.fsf@openvz.org> <20141218151247.b6ccd73351f40db66818c07e@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-kernel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Michael Kerrisk <mtk.manpages@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141218151247.b6ccd73351f40db66818c07e@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 10 Dec 2014 16:49:18 +0300 Dmitry Monakhov <dmonakhov@openvz.org>=
 wrote:
>
>>=20
>> Hello. Someone please take care of this patch.
>>=20
>> W/o that patch unprivileged user may abuse system resources simply by sp=
awning
>> wast number of unkilable busyloops (works on ext2/ext3):
>>=20
>> truncate --size 1T test
>> for ((i=3D0;i<1024;i++))
>> do
>>        filefrag test > /dev/null &
>> done
>>=20
>> >> --- a/fs/ioctl.c
>> >> +++ b/fs/ioctl.c
>> >> @@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode *inode,
>> >>  				past_eof =3D true;
>> >>  		}
>> >>  		cond_resched();
>> >> +		if (fatal_signal_pending(current)) {
>> >> +			ret =3D -EINTR;
>> >> +			break;
>> >> +		}
>> >> +
>> >>  	} while (1);
>> >>=20=20
>
> Is FIEMAP documented anywhere (manpage)?  If so, that will need an
> update.
Yes you right. I just thought that it is assumed by default.
The only place I know is Documentation/filesystems/fiemap.txt
Please fold patch attached to original one.

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUk+xOAAoJELhyPTmIL6kBjyUIAJwZwQeyyx4v9SbVPPSKyNpL
XeppPJSR6VFcstkSobFErjoKuPA8YYH0ZIPd1W4Hgi1LSFiB0LC4eOhGyRAaZNaW
bLusOzrcNsVCh8VYlFO1gizPfxwSyXeoVvYkNElBUIyg+ETJ7+juHMymGW2zumMv
zVklhoP9/12iQ1EDvm6swn5LZSyfGeN3bxIxIYucc8KnZH4265/pLzaEKk757gX2
TL1mwJ2eUtL6COF9SX/FBcS+4SD0KtuIT7Zo0tTznbod865cXA/+8mWpLPPKExbZ
WzuaQmVcW14M9ACy4367dNetnEzy0O73MAOCjRxQn8D8Qhx0+bfEOFCO0CMbfvk=
=6Wke
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-doc-fimemap-update-signal-behaviour.patch

>From f7af425b2ac920065491a478b4f4359f422b3453 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Fri, 19 Dec 2014 13:11:29 +0400
Subject: [PATCH] doc: fimemap update signal behaviour


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 Documentation/filesystems/fiemap.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/fiemap.txt b/Documentation/filesystems/fiemap.txt
index 1b805a0..f6d9c99 100644
--- a/Documentation/filesystems/fiemap.txt
+++ b/Documentation/filesystems/fiemap.txt
@@ -196,7 +196,8 @@ struct fiemap_extent_info {
 };
 
 It is intended that the file system should not need to access any of this
-structure directly.
+structure directly. Filesystem handlers should be tolerant to signals and return
+EINTR once fatal signal received.
 
 
 Flag checking should be done at the beginning of the ->fiemap callback via the
-- 
1.7.1


--=-=-=--
