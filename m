From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: xfstests ext4/304 failing due to donor inode's i_size == 0
Date: Tue, 20 Oct 2015 17:44:03 +0300
Message-ID: <87h9llior0.fsf@openvz.org>
References: <20151019025727.GA6676@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:32911 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbJTOoK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2015 10:44:10 -0400
Received: by lbbec13 with SMTP id ec13so14654433lbb.0
        for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 07:44:09 -0700 (PDT)
In-Reply-To: <20151019025727.GA6676@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> Hi Dmitry,
>
> I was investigating why ext4/304 is failing, and it's due to
> defrag-fuzzer returning an error:
Yep. You are right. I have out of tree patch which fix that. I'll send it
to xfstests-dev list.=20


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJWJlMzAAoJELhyPTmIL6kB+O8H/RJ2zv8N3/4ibCe/CE+tiijo
b0hxQ48VrLmyiwqZZLA+SVOaWUId/OQfXACK2gqcrTDRNMlOsCmCEuf74RyzpPch
iXY0RbzrLy018No6ukn4CvpfPxKN29VS7u0A8ds5c5hz2GHNWCOs2wPqKgoOy57L
kyzBm8uukeE7s4WrdWJMNMYFpep5xK/bQdWUz8q/2wzaCZi48al2Xv7zWqZf6R2S
6/r71d11IN6ULLl3kYoJyVLm3hAYHH2APz/JOdB56d9Jhnv4uzaEgW4Y7cLxocdr
LPiQSYjDuS96xfekPbn9S44ET1AuWMRzo9xDNArRI2WgJWYstbb7WiJCQsnH6kg=
=aYOF
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=ext4-304-fix.patch

>From ee628504370564704e218ecf089f00c243b6fd12 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 20 Oct 2015 18:32:03 +0400
Subject: [PATCH] ext4/304 handle ENOSPC/EINVAL correctly

'defrag-fuzzer' is  task which  try to perform inplace defrag, inline-defrag
is basically  of {falloc,ioc_swap} and may fail due to ENOSPC on first stage.
In that case IOCTL returns EINVAL (because we try to swap invalid extents)

Since this is hard core test then ENOSPC and corresponding EINVAL is expected.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/304 |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tests/ext4/304 b/tests/ext4/304
index 7b90f1d..81d69b8 100644
--- a/tests/ext4/304
+++ b/tests/ext4/304
@@ -76,6 +76,7 @@ donorname=test4.def
 filename=test4
 inplace=1
 rw=randwrite
+ignore_error=,EINVAL
 numjobs=4*${LOAD_FACTOR}
 runtime=30*${TIME_FACTOR}
 time_based
-- 
1.7.1


--=-=-=--
