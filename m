From: Sami Liedes <sami.liedes@iki.fi>
Subject: Intentionally corrupted fs: "kernel BUG at
 fs/jbd2/transaction.c:161!"
Date: Sat, 28 Apr 2012 03:30:52 +0300
Message-ID: <20120428003052.GA20648@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:41440 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab2D1Aa6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2012 20:30:58 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q3S0UtdI003492
	for <linux-ext4@vger.kernel.org>; Sat, 28 Apr 2012 03:30:55 +0300
Received: from smtp-1.hut.fi ([130.233.228.91])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 10915-325 for <linux-ext4@vger.kernel.org>;
 Sat, 28 Apr 2012 03:30:55 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q3S0Urlo003488
	for <linux-ext4@vger.kernel.org>; Sat, 28 Apr 2012 03:30:53 +0300
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The 10 MiB ext4 image available at

   http://www.niksula.hut.fi/~sliedes/ext4/313.min.ext4.bz2

causes a crash on mainline 3.3.4 kernel at umount time when the
following operations are run (not all of these are probably really
necessary):

1.  mount 313.min.ext4 /mnt -t ext4 -o errors=continue
2.  cd /mnt
3.  cp -r doc doc2 >&/dev/null
4.  find -xdev >&/dev/null
5.  find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
6.  mkdir tmp >&/dev/null
7.  echo whoah >tmp/filu 2>/dev/null
8.  rm -rf /mnt/* >&/dev/null
9.  cd /
10. umount /mnt

See the dmesg output below (the panic is due to panic_on_oops=1).

The image differs from a pristine, fully working ext4 filesystem
available at

   http://www.niksula.hut.fi/~sliedes/ext4/pristine.ext4.bz2

by only one bit:

------------------------------------------------------------
$ wget http://www.niksula.hut.fi/~sliedes/ext4/pristine.ext4.bz2
$ bunzip2 pristine.ext4.bz2
$ diff -u <(hd pristine.ext4) <(hd 313.min.ext4)
--- /dev/fd/63 2012-04-28 03:14:08.300016090 +0300
+++ /dev/fd/62 2012-04-28 03:14:08.300016090 +0300
@@ -6214,7 +6214,7 @@
 0002a980  ed 41 00 00 00 54 00 00  c8 a7 4a 48 9e 26 bf 48  |.A...T....JH.&.H|
 0002a990  11 31 48 48 00 00 00 00  00 00 02 00 2a 00 00 00  |.1HH........*...|
 0002a9a0  00 10 08 00 e9 00 00 00  0a f3 01 00 04 00 00 00  |................|
-0002a9b0  00 00 00 00 00 00 00 00  15 00 00 00 cb 06 00 00  |................|
+0002a9b0  00 00 00 00 00 40 00 00  15 00 00 00 cb 06 00 00  |.....@..........|
 0002a9c0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
 *
 0002a9e0  00 00 00 00 53 c0 4b 45  00 00 00 00 00 00 00 00  |....S.KE........|
------------------------------------------------------------


(This bug report serves also as a preview of the Berserker toolkit
that automates finding such bugs and minimizing the differences to
pristine filesystems. I plan on making the announcement and making the
toolkit available within the next few hours.)

	Sami


------------------------------------------------------------
EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: errors=continue
BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff8117c3b1>] ext4_readdir+0x4f1/0x5d0
PGD 160e067 PUD 160f067 PMD 0
Oops: 0000 [#1]
CPU 0
Pid: 1402, comm: find Not tainted 3.3.4 #1 Bochs Bochs
RIP: 0010:[<ffffffff8117c3b1>]  [<ffffffff8117c3b1>] ext4_readdir+0x4f1/0x5d0
RSP: 0018:ffff880006c07e38  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880007bbe4c0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff880007bbe4c0
RBP: ffff880006c07ed8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880005a53300
R13: 0000000000000000 R14: ffff88000738b388 R15: ffff880006c53800
FS:  0000000000000000(0000) GS:ffffffff8161d000(0063) knlGS:00000000f753a6c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: fffffffffffffff8 CR3: 0000000006d05000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process find (pid: 1402, threadinfo ffff880006c06000, task ffff880006cd1040)
Stack:
 ffff880006c07e48 ffff88000738b458 ffff880006c07ed8 ffffffff813f103d
 ffffffff810fde82 0000000000000002 ffffffff81135290 ffff880006c07f40
 ffff88000738b498 ffffffff810ed9e0 2222222222222222 2222222222222222
Call Trace:
 [<ffffffff813f103d>] ? mutex_lock_killable_nested+0x24d/0x380
 [<ffffffff810fde82>] ? vfs_readdir+0x52/0xd0
 [<ffffffff81135290>] ? compat_filldir+0x100/0x100
 [<ffffffff810ed9e0>] ? drop_file_write_access+0x50/0x50
 [<ffffffff81135290>] ? compat_filldir+0x100/0x100
 [<ffffffff810fded0>] vfs_readdir+0xa0/0xd0
 [<ffffffff81136dd3>] compat_sys_getdents64+0x83/0xf0
 [<ffffffff813f5331>] sysenter_dispatch+0x7/0x2a
 [<ffffffff8122ee0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Code: 00 48 85 c0 48 89 43 08 0f 84 d7 00 00 00 8b 50 f8 89 53 20 8b 40 fc 89 43 24 e9 e4 fb ff ff 48 89 df e8 03 c2 0a 00 48 89 43 08 <8b> 50 f8 48 8d 48 f8 4c 89 e7 48 8b 75 98 89 53 20 8b 50 fc 89
RIP  [<ffffffff8117c3b1>] ext4_readdir+0x4f1/0x5d0
 RSP <ffff880006c07e38>
CR2: fffffffffffffff8
---[ end trace 92147d6f5f9bc8fa ]---
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..
------------------------------------------------------------

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPmzo8AAoJEKLT589SE0a0M6wQAKmXo1gi9DvaVQHl8boK9LrX
Pf22FQ99dgQsFJrRVMrH+QCCzJ3VP/5OIpVDy9S1s2ZNvMa8uDdGUe2wp68rkE4w
LFSENt0vIJoihopvrXkZpEIS1JwVLoyhLjfRvJjXKWwk+BkqwVaMKxaqPuaHf9N8
UzyvTouV18eR/dXOB8BPTZkHVZxFtCZvDl2bv+VOSL2+gxq27kNcVViph/mEEx7b
8N9G6QvPDSZzMHsYrPS/tm/BelyKoBKerxen3vByiZPZqkzxWDUkRIDxxN0Flr9g
8t+2NLzFthj9DhyCJQkw21fcC3YgPFerF9X6mHQcEdXU7pXq9uyZYWCAUZ8Qg+h5
EHUsabLIkidZMI4f2pwfWPrk2AjsJ7wWTt3d0nuKy+eP57qW5xmevjQFPTM/kABJ
/q+w9GPxS1Raa8EvNZMqkf032zDrrV7z+3eVvbUbmPC8QW7C0UW2svFohnlSf1Rc
q8d5OUEXO1AkgGGClVeys8F43fXLuAKArf6yCQGZyhW7UJ694RqOPluBWaZxBZo0
2ata0xvrlBqQplSFpO25S3Utb1RCaZqjRvEik4bGvgbPNOSzkscZIVng3kfXUn4d
HcFgDlBhrOZ33XhUNJJ3V+nfBemrbKj63jY+cHynNROBOHTOCUEVFvyRWH1+NS7l
ysJJ2suj+x9q+6d++pUj
=6/cY
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
