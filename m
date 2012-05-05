From: Sami Liedes <sami.liedes@iki.fi>
Subject: ext2 hang on (intentionally) corrupted filesystem
Date: Sat, 5 May 2012 04:38:41 +0300
Message-ID: <20120505013841.GD13332@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
To: linux-ext4@vger.kernel.org, linux-fsdev@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:34912 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2EEBiw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 May 2012 21:38:52 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

There seems to be a bug in the ext2 implementation (in vanilla 3.3.4)
where operations on a corrupted ext2 filesystem cause a hung task:

1. wget http://sli.dy.fi/~sliedes/berserker/testcases/ext2.110.min.bz2
2. mount ... /mnt -t ext2 -o errors=continue
3. Do some operations; what I do (it's the rm that crashes):

  timeout 30 cp -r doc doc2 >&/dev/null
  timeout 30 find -xdev >&/dev/null
  timeout 30 find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
  timeout 30 mkdir tmp >&/dev/null
  timeout 30 echo whoah >tmp/filu 2>/dev/null
  timeout 30 rm -rf /mnt/* >&/dev/null

4. The rm task hangs

The filesystem in fact differs from a pristine, fully working ext2
filesystem by only one bit:

------------------------------------------------------------
$ diff -u <(hd testimg.ext2) <(hd testimg.ext2.110.min)
--- /dev/fd/63 2012-05-05 04:26:49.972546154 +0300
+++ /dev/fd/62 2012-05-05 04:26:49.972546154 +0300
@@ -13520,7 +13520,7 @@
 00902c90  73 64 65 31 00 00 00 00  00 00 00 00 00 00 00 00  |sde1............|
 00902ca0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
 *
-00903000  1d 05 00 00 0c 00 01 02  2e 00 00 00 29 00 00 00  |............)...|
+00903000  1d 05 00 00 0c 00 01 02  6e 00 00 00 29 00 00 00  |........n...)...|
 00903010  0c 00 02 02 2e 2e 00 00  1e 05 00 00 e8 03 26 01  |..............&.|
 00903020  5c 78 32 66 64 65 76 69  63 65 73 5c 78 32 66 76  |\x2fdevices\x2fv|
 00903030  69 72 74 75 61 6c 5c 78  32 66 74 74 79 5c 78 32  |irtual\x2ftty\x2|
------------------------------------------------------------

The buggy filesystem (10 MiB uncompressed) can be downloaded from

   http://sli.dy.fi/~sliedes/berserker/testcases/ext2.110.min.bz2

and the pristine filesystem from

   http://sli.dy.fi/~sliedes/berserker/testcases/pristine.ext2.bz2

See the dmesg output below.

	Sami


------------------------------------------------------------
INFO: task rm:1549 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rm              D ffff880006f0cd40     0  1549   1548 0x00020004
 ffff88000560ddc8 0000000000000046 ffff8800068b2040 ffff88000560dfd8
 ffff88000560dfd8 ffff88000560dfd8 ffff880007852040 ffff8800068b2040
 ffff88000560de08 ffff880006f0cd00 ffff8800068b2040 0000000000000246
Call Trace:
 [<ffffffff8171d609>] schedule+0x39/0x50
 [<ffffffff8171baa0>] mutex_lock_nested+0x130/0x2f0
 [<ffffffff810fb467>] ? vfs_rmdir+0x67/0x120
 [<ffffffff810fb467>] vfs_rmdir+0x67/0x120
 [<ffffffff810fb62b>] do_rmdir+0x10b/0x120
 [<ffffffff81556e5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff810fb94d>] sys_unlinkat+0x2d/0x40
 [<ffffffff817204b1>] sysenter_dispatch+0x7/0x2a
 [<ffffffff81556e1e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
2 locks held by rm/1549:
 #0:  (&type->i_mutex_dir_key#4/1){+.+.+.}, at: [<ffffffff810fb58c>] do_rmdir+0x6c/0x120
 #1:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<ffffffff810fb467>] vfs_rmdir+0x67/0x120
Kernel panic - not syncing: hung_task: blocked tasks
Pid: 361, comm: khungtaskd Not tainted 3.3.4 #3
Call Trace:
 [<ffffffff81713aff>] panic+0xb5/0x1be
 [<ffffffff8108a017>] watchdog+0x2b7/0x2c0
 [<ffffffff81089dc6>] ? watchdog+0x66/0x2c0
 [<ffffffff81089d60>] ? hung_task_panic+0x20/0x20
 [<ffffffff810525cd>] kthread+0x8d/0xa0
 [<ffffffff81720304>] kernel_thread_helper+0x4/0x10
 [<ffffffff8171ec30>] ? retint_restore_args+0x13/0x13
 [<ffffffff81052540>] ? kthread_flush_work_fn+0x10/0x10
 [<ffffffff81720300>] ? gs_change+0x13/0x13
Rebooting in 1 seconds..
------------------------------------------------------------

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPpISgAAoJEKLT589SE0a0VdwP/RjS5r4RsLbMRdfHU4Yu0KzF
c0+Bz7dyserJ4Ueo08/a8l0fFmetlH61uKWBC1zJwD7mQUE5oRp5QxcNp7jE97mn
Cq13uUii/ma43llDBeVw3u+6eFJyyw0Ok9SGIxtwOiCIlbDTWJ955kM2TWd0AYLh
LFwbE5D9B7bDIuJEJ42zM0hGb4ni3yb3vOkzwsi2X6Uh8y9JEl4DCGffVpFX4Ogo
e31A2eI4T9FguvIed48ZFET6rGGcaAJc3RQdq+lYCEwxE/rXn5zopaHzsXv2nccW
Le2dXZ3zwQmAC2o/FxfxQwco1kjqSPArqgvzhsz/Q9DTiYqgcoLP+yCUaToqAFuZ
ca+9HgUXrH5rVV2Tc8SDnmHTo7WFYntTLgUzjG1l8hVdZUC0Njw9yh9TOXmBSpDK
Oegquhv77R6WFh3IntfV0jf0b7D+k8FKTr1s/DHxtiQaDz10S8/A9FhqaQtWuAdl
7GCOhWJm0jq8y2vg084x/1wFLTq1DJp3+87MOfc1PZz6n+/5AMUVKMRK5X1zcHBl
cN8cpyXQ2Sx+QHoUYmOPgrfnFcmfcm5b7akw0oWuq0FbxQSyIk5qCGFLLcMCRBPR
im/SlzrQIro4rKLn/feZrdS4F+Tp/Idyeyv1QiYIxBY1JQiqniCn1LW/fhJSBd+1
TrkwckKc5MUVOF5lxEkk
=zqVt
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--
