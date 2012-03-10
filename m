From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 0/5] Make filesystem shrinking faster and less CPU-intensive
Date: Sat, 10 Mar 2012 23:33:21 +0200
Message-ID: <20120310213321.GK6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vJI8q/aziP9idhqk"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:44268 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab2CJVz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 16:55:29 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALXNv7004348
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:33:23 +0200
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 05070-881 for <linux-ext4@vger.kernel.org>;
 Sat, 10 Mar 2012 23:33:23 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALXLBR004344
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:33:22 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--vJI8q/aziP9idhqk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch set speeds up at least resize2fs shrinking by causing its
CPU usage to drop by 99.5% by optimizing inode bitfield scanning.

Test case: A 100G ext4 filesystem filled to 50% with copies of
/usr/share/doc, shrinking to 75G on a slow disk (~5400 rpm) and fast
processor (Core i7):

Before:

# time resize2fs -p $FILESYSTEM 75G
[...]
real    96m26.852s
user    56m39.768s
sys     0m27.922s

After:

# time resize2fs -p $FILESYSTEM 75G
real    39m49.287s
user    0m16.601s
sys     0m26.606s

Sami Liedes (5):
      libext2fs: Move a modulo operation out of a hot loop.
      resize2fs: Use EXT2_FLAG_64BITS.
      libext2fs: Document EXT2_FLAG_64BITS in ext2fs_open2().
      libext2fs: Implement ext2fs_find_first_zero_generic_bmap().
      libext2fs: Implement fast find_first_zero() for bitarray bitmaps.

 lib/ext2fs/alloc.c        |   27 +++------------
 lib/ext2fs/bitops.h       |   16 ---------
 lib/ext2fs/blkmap64_ba.c  |   81 ---------------------------------------------
 lib/ext2fs/bmap64.h       |    5 ---
 lib/ext2fs/gen_bitmap64.c |   28 ---------------
 lib/ext2fs/openfs.c       |    1 -
 resize/main.c             |    3 --
 7 files changed, 5 insertions(+), 156 deletions(-)

--vJI8q/aziP9idhqk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPW8ihAAoJEKLT589SE0a0xFQP/2I2Xjg/cl8SDmBzU2Vlsoqd
blZm2eb9jmLLRxpi0SJSem9sBbj68WwxIDP0iXyWDY//AkQrfycczt2jjIv/ZzcV
c+C7sv794QhNXzAc3SDgZShn0xU4E/w5pN1IjEQR9BpQAMogofCOB+I/SG9eYvvr
5/FtA6JciGHugxU54Ip+K09CT4QSmC2SxTeHO6RC0KIBRTThq/K5N1gSpHO3yEDd
/ER5bOR8gy/oLnNGe5gO/EAnQmYCSDHnTTjqpe50PbCuVZZYdJu48Pt9zKdl+Xi3
ocz4medtJk/r5+iuzSL4bPuwwF1NFsytOEh2fKipIgv9KUu9oGipEG2m0RjqGhJS
FcqjxyTeGrf+LxAl9F2OBcyponRnKqAAFEknCPjMp6I/jfS++gnF5Bsz6H9eaYHo
622//UBdK0MafhMW5Wwx2GhClB+aWA1BEQD2RqYOj8tLX2nRwTtU/UL12Ij8h0J4
hcoG7wdUxDXaYiJBY/hwcaxJTUpc4FKCMSKkbcj8jvlArUixi1wEnGYx2SvC65ty
RHwbrwSsXeaO5vuNnJrtg/0C9gml3VRP7qAxokf/+ex6a9yKHevRU2koUmXYzeI2
P50PGpCZG7ufBQNSMZd5O1Ech89wrrPktBDBD2Issz3vUOB31rn/ZzjxdEf0TlET
YxJAuH2AGsaI3VQJHDvL
=/f09
-----END PGP SIGNATURE-----

--vJI8q/aziP9idhqk--
