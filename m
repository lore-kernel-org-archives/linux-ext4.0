From: Andreas Schultz <aschultz@warp10.net>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Fri, 14 Nov 2008 13:49:32 +0100
Message-ID: <200811141349.39160.aschultz@warp10.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1926371.xCqVI767Fu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tpip.net ([213.187.84.201]:36947 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYKNNJY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Nov 2008 08:09:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1926371.xCqVI767Fu
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

[...]

> Unfortunately, ltrace doesn't show what is calling this code, so
> a stack trace is needed from GDB.

Got the same problem, here is a GDB backtrace done on Ubuntu Intrepid, e2fsprogs 1.41.3:

(gdb) bt
#0  0x00007fa619228bcc in ext2fs_new_block (fs=0x1fea860, goal=263012, map=0x1feaa30, ret=0x7fff21668cac) at /build/buildd/e2fsprogs-1.41.3/lib/ext2fs/alloc.c:166
#1  0x000000000040408d in resize_inode (fs=0x1fea860, new_size=<value optimized out>) at /build/buildd/e2fsprogs-1.41.3/misc/tune2fs.c:1020
#2  0x0000000000404d83 in main (argc=<value optimized out>, argv=<value optimized out>) at /build/buildd/e2fsprogs-1.41.3/misc/tune2fs.c:1638

Cheers
Andreas

--nextPart1926371.xCqVI767Fu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkdc90ACgkQ9wB/4yf/y7ewBgCeMv3lbZBx9ANgjbSoUleJXKNb
dAAAoL/XCVfP+vuehN/t1jYeFnZ8swus
=+pVy
-----END PGP SIGNATURE-----

--nextPart1926371.xCqVI767Fu--
