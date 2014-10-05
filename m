From: Sami Liedes <sami.liedes@iki.fi>
Subject: Intentionally corrupted ext4s causing two different kernel panics at
 umount
Date: Sun, 5 Oct 2014 03:12:40 +0300
Message-ID: <20141005001239.GD27150@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:40285 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJEAUF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Oct 2014 20:20:05 -0400
Received: from sli.dy.fi (a91-156-209-44.elisa-laajakaista.fi [91.156.209.44])
	by gw02.mail.saunalahti.fi (Postfix) with ESMTP id 46FA0401B4
	for <linux-ext4@vger.kernel.org>; Sun,  5 Oct 2014 03:12:40 +0300 (EEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

I ran some fuzz tests on an ext4 filesystem on 3.16.3 and on 3.17-rc7
and found some filesystems that differ from a pristine filesystem by
one bit and cause a kernel panic at unmount time.

The set of operations I run for each filesystem is this:

   mount $TARGET_DEV /mnt -t $FSTYPE -o errors=continue
   cd /mnt
   timeout 30 cp -r doc doc2 >&/dev/null
   timeout 30 find -xdev >&/dev/null
   timeout 30 find -xdev -print0 2>/dev/null |xargs -0 touch -- >&/dev/null
   timeout 30 mkdir tmp >&/dev/null
   timeout 30 echo whoah >tmp/filu >&/dev/null
   timeout 30 rm -rf /mnt/* >&/dev/null
   cd /
   umount /mnt

I got two distinct backtraces, and for both of them I have two test
images that differ from a clean ext4 filesystem by a single bit.

You can get the pristine filesystem from

   http://www.niksula.hut.fi/~sliedes/ext4/testimg.ext4.pristine.bz2

For the rest of the files, see

   http://www.niksula.hut.fi/~sliedes/ext4/


1. Crash in ext4_put_super
==========================

Test filesystems and diffs to the pristine image:

   http://www.niksula.hut.fi/~sliedes/ext4/ext4_put_super/testimg.ext4.20942.min.bz2

--- /dev/fd/63  2014-10-05 02:22:36.822155073 +0300
+++ /dev/fd/62  2014-10-05 02:22:36.822155073 +0300
@@ -32572,7 +32572,7 @@
 001795a0  2d 70 63 73 70 6b 72 2d  65 76 65 6e 74 2d 73 70  |-pcspkr-event-sp|
 001795b0  6b 72 0c 00 e1 01 00 00  20 00 18 02 62 75 73 5c  |kr...... ...bus\|
 001795c0  78 32 66 75 73 62 5c 78  32 66 30 30 38 5c 78 32  |x2fusb\x2f008\x2|
-001795d0  66 30 30 31 05 02 00 00  18 00 0e 02 75 73 62 64  |f001........usbd|
+001795d0  66 30 30 31 05 00 00 00  18 00 0e 02 75 73 62 64  |f001........usbd|
 001795e0  65 76 37 2e 31 5f 65 70  38 31 10 00 1f 02 00 00  |ev7.1_ep81......|
 001795f0  18 00 0e 02 75 73 62 64  65 76 31 2e 31 5f 65 70  |....usbdev1.1_ep|
 00179600  30 30 04 02 25 02 00 00  18 00 0e 02 75 73 62 64  |00..%.......usbd|


   http://www.niksula.hut.fi/~sliedes/ext4/ext4_put_super/testimg.ext4.106360.min.bz2

--- /dev/fd/63  2014-10-05 02:22:36.501155217 +0300
+++ /dev/fd/62  2014-10-05 02:22:36.501155217 +0300
@@ -36271,7 +36271,7 @@
 *
 001b8400  03 04 00 00 0c 00 01 02  2e 00 00 00 0c 00 00 00  |................|
 001b8410  0c 00 02 02 2e 2e 00 00  04 04 00 00 0c 00 04 04  |................|
-001b8420  73 64 65 33 05 04 00 00  14 00 0c 04 72 6f 6f 74  |sde3........root|
+001b8420  73 64 65 33 05 00 00 00  14 00 0c 04 72 6f 6f 74  |sde3........root|
 001b8430  2d 63 72 79 70 74 65 64  06 04 00 00 24 00 1b 04  |-crypted....$...|
 001b8440  6c 76 6d 32 7c 6d 79 5f  63 6f 6e 74 61 69 6e 65  |lvm2|my_containe|
 001b8450  72 7c 6d 79 5f 72 65 67  69 6f 6e 00 07 04 00 00  |r|my_region.....|


The backtrace, trimmed from

   http://www.niksula.hut.fi/~sliedes/ext4/ext4_put_super/testimg.ext4.20942.min.log

[    1.034753] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: errors=continue
[    1.353376] EXT4-fs warning (device vdb): ext4_unlink:2820: Deleting nonexistent file (5), 0
[    1.354480] EXT4-fs (vdb): Inode 5 (ffff8800048a0e10): orphan list check failed!
[    1.355433] ffff8800048a0e10: 00000000 00000000 00000000 00000000  ................
[...]
[    1.437175] ffff8800048a1500: 00000081 0000007f 00000000 00000000  ................
[    1.437769] CPU: 0 PID: 207 Comm: rm Not tainted 3.16.3 #3
[    1.438195] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    1.438979]  ffff8800048a0e10 ffff880000647dd0 ffffffff81850b5c ffff8800048a0f80
[    1.439592]  ffff880000647e00 ffffffff812615bd 0000000000000700 ffff880000000001
[    1.440217]  ffff8800048a0f80 ffff8800048a1000 ffff880000647e18 ffffffff8116d723
[    1.440837] Call Trace:
[    1.441035]  [<ffffffff81850b5c>] dump_stack+0x45/0x56
[    1.441437]  [<ffffffff812615bd>] ext4_destroy_inode+0x9d/0xa0
[    1.441894]  [<ffffffff8116d723>] destroy_inode+0x33/0x70
[    1.442313]  [<ffffffff8116dd72>] evict+0x112/0x1a0
[    1.442696]  [<ffffffff8116eacd>] iput+0xed/0x190
[    1.443063]  [<ffffffff81162cd7>] do_unlinkat+0x197/0x2c0
[    1.443484]  [<ffffffff81063485>] ? sys32_fstatat+0x15/0x30
[    1.443920]  [<ffffffff81162e16>] SyS_unlinkat+0x16/0x40
[    1.444343]  [<ffffffff81859aa8>] sysenter_dispatch+0x7/0x25
[    1.447553] tsc: Refined TSC clocksource calibration: 3400.019 MHz
[    1.455218] EXT4-fs warning (device vdb): ext4_rmdir:2760: empty directory has too many links (3)
[    1.570473] EXT4-fs (vdb): sb orphan head is 5
[    1.571220] sb_info orphan list:
[    1.571645]   inode vdb:5 at ffff8800048a0f80: mode 100000, nlink 0, next 0
[    1.572569] ------------[ cut here ]------------
[    1.573168] kernel BUG at fs/ext4/super.c:836!
[    1.573745] invalid opcode: 0000 [#1] SMP
[    1.574308] CPU: 0 PID: 209 Comm: umount Not tainted 3.16.3 #3
[    1.575060] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    1.576354] task: ffff880005e5c100 ti: ffff880005e34000 task.ti: ffff880005e34000
[    1.576549] RIP: 0010:[<ffffffff81261516>]  [<ffffffff81261516>] ext4_put_super+0x366/0x370
[    1.576549] RSP: 0018:ffff880005e37e70  EFLAGS: 00010202
[    1.576549] RAX: 000000000000003f RBX: ffff880005e31800 RCX: 0000000000000006
[    1.576549] RDX: 0000000000000007 RSI: 0000000000000001 RDI: 0000000000000246
[    1.576549] RBP: ffff880005e37ea0 R08: 0000000000000001 R09: 0000000000000000
[    1.576549] R10: 0000000000000000 R11: 0000000000000219 R12: ffff880005e31b28
[    1.576549] R13: ffff880005e31000 R14: ffff880005e31a88 R15: ffff880005e31b28
[    1.576549] FS:  0000000000000000(0000) GS:ffff880007c00000(0063) knlGS:00000000f746a780
[    1.576549] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.576549] CR2: 0000000008d05014 CR3: 0000000005c2b000 CR4: 00000000000006b0
[    1.576549] Stack:
[    1.576549]  ffff880000000000 ffff880005e31000 ffff880005e310f8 ffffffff81a32840
[    1.576549]  0000000000000000 0000000000000000 ffff880005e37ec8 ffffffff811547dd
[    1.576549]  0000000000000083 ffff880006c0e100 0000000000000000 ffff880005e37ee8
[    1.576549] Call Trace:
[    1.576549]  [<ffffffff811547dd>] generic_shutdown_super+0x6d/0xf0
[    1.576549]  [<ffffffff81155a12>] kill_block_super+0x22/0x70
[    1.576549]  [<ffffffff811544fc>] deactivate_locked_super+0x3c/0x60
[    1.576549]  [<ffffffff8115457c>] deactivate_super+0x5c/0x60
[    1.576549]  [<ffffffff811728c1>] mntput_no_expire+0x171/0x260
[    1.576549]  [<ffffffff811744aa>] ? SyS_oldumount+0x7a/0xe0
[    1.576549]  [<ffffffff811744aa>] SyS_oldumount+0x7a/0xe0
[    1.576549]  [<ffffffff81859aa8>] sysenter_dispatch+0x7/0x25
[    1.576549] Code: b0 90 05 00 00 41 8b 87 64 ff ff ff 89 04 24 31 c0 e8 ab c1 5e 00 4d 8b 3f 4d 39 fc 75 b5 4c 3b a3 28 03 00 00 0f 84 af fe ff ff <0f> 0b 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 4c 8d a7 90 fe
[    1.576549] RIP  [<ffffffff81261516>] ext4_put_super+0x366/0x370
[    1.576549]  RSP <ffff880005e37e70>
[    1.596184] ---[ end trace e2c3a1b45e3598c1 ]---
[    1.596551] Kernel panic - not syncing: Fatal exception
[    1.597076] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    1.597870] Rebooting in 1 seconds..


2. Crash in start_this_handle
=============================

Test filesystems and diffs to the pristine image:

   http://www.niksula.hut.fi/~sliedes/ext4/start_this_handle/testimg.ext4.8473.min.bz2

--- /dev/fd/63  2014-10-05 02:22:37.396154814 +0300
+++ /dev/fd/62  2014-10-05 02:22:37.395154815 +0300
@@ -164,7 +164,7 @@
 *
 0000b000  02 00 00 00 0c 00 01 02  2e 00 00 00 02 00 00 00  |................|
 0000b010  0c 00 02 02 2e 2e 00 00  0b 00 00 00 14 00 0a 02  |................|
-0000b020  6c 6f 73 74 2b 66 6f 75  6e 64 00 00 0c 00 00 00  |lost+found......|
+0000b020  6c 6f 73 74 2b 66 6f 75  6e 64 00 00 08 00 00 00  |lost+found......|
 0000b030  0c 00 03 02 64 65 76 00  ff 04 00 00 c8 03 03 02  |....dev.........|
 0000b040  64 6f 63 00 00 00 00 00  00 00 00 00 00 00 00 00  |doc.............|
 0000b050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|


   http://www.niksula.hut.fi/~sliedes/ext4/start_this_handle/testimg.ext4.610085.min.bz2

--- /dev/fd/63  2014-10-05 02:22:37.100154947 +0300
+++ /dev/fd/62  2014-10-05 02:22:37.100154947 +0300
@@ -36276,7 +36276,7 @@
 001b8440  6c 76 6d 32 7c 6d 79 5f  63 6f 6e 74 61 69 6e 65  |lvm2|my_containe|
 001b8450  72 7c 6d 79 5f 72 65 67  69 6f 6e 00 07 04 00 00  |r|my_region.....|
 001b8460  18 00 0f 04 6d 79 76 67  2d 72 6f 6f 74 5f 63 72  |....myvg-root_cr|
-001b8470  79 70 74 00 08 04 00 00  28 00 1f 04 6c 76 6d 32  |ypt.....(...lvm2|
+001b8470  79 70 74 00 08 00 00 00  28 00 1f 04 6c 76 6d 32  |ypt.....(...lvm2|
 001b8480  7c 6d 79 5f 63 6f 6e 74  61 69 6e 65 72 7c 73 77  ||my_container|sw|
 001b8490  61 70 30 2d 63 72 79 70  74 65 64 00 09 04 00 00  |ap0-crypted.....|
 001b84a0  0c 00 04 04 73 64 64 32  0a 04 00 00 14 00 09 04  |....sdd2........|


The backtrace, trimmed from

   http://www.niksula.hut.fi/~sliedes/ext4/start_this_handle/testimg.ext4.8473.min.log

[    1.025503] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: errors=continue
[    1.275936] ------------[ cut here ]------------
[    1.276860] kernel BUG at fs/jbd2/transaction.c:307!
[    1.277789] invalid opcode: 0000 [#1] SMP
[    1.278622] CPU: 0 PID: 208 Comm: umount Not tainted 3.16.3 #3
[    1.279721] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    1.279862] task: ffff880005db5140 ti: ffff88000042c000 task.ti: ffff88000042c000
[    1.279862] RIP: 0010:[<ffffffff81293e60>]  [<ffffffff81293e60>] start_this_handle+0x330/0x760
[    1.279862] RSP: 0018:ffff88000042fc60  EFLAGS: 00010202
[    1.279862] RAX: 0000000000000039 RBX: ffff880005e06828 RCX: 0000000000000002
[    1.279862] RDX: 000000000000000a RSI: 0000000000000001 RDI: ffff880005e06828
[    1.279862] RBP: ffff88000042fd00 R08: 0000000000000000 R09: 0000000000000000
[    1.279862] R10: ffff880005e06840 R11: 0000000000000002 R12: ffff880005e06800
[    1.279862] R13: ffff8800067fc000 R14: ffff880005e06800 R15: 0000000000000000
[    1.279862] FS:  0000000000000000(0000) GS:ffff880007c00000(0063) knlGS:00000000f7424780
[    1.279862] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.279862] CR2: 0000000009ae8014 CR3: 0000000005d53000 CR4: 00000000000006b0
[    1.279862] Stack:
[    1.279862]  0000000000000286 ffff880005db5810 ffff8800049102b9 ffff880005e06df8
[    1.279862]  0000000000000000 00000000fffedc46 ffff88000042fcc8 ffff8800067f9000
[    1.279862]  0000005b00000050 ffffffff0000005b ffffffff81293a1b ffff8800067fc000
[    1.279862] Call Trace:
[    1.279862]  [<ffffffff81293a1b>] ? new_handle+0x1b/0x50
[    1.279862]  [<ffffffff8129451b>] jbd2__journal_start+0xcb/0x1a0
[    1.279862]  [<ffffffff8124a45d>] ? ext4_evict_inode+0x17d/0x500
[    1.279862]  [<ffffffff81272635>] __ext4_journal_start_sb+0x65/0xd0
[    1.279862]  [<ffffffff8124a45d>] ext4_evict_inode+0x17d/0x500
[    1.279862]  [<ffffffff8116dd0f>] evict+0xaf/0x1a0
[    1.279862]  [<ffffffff8116eacd>] iput+0xed/0x190
[    1.279862]  [<ffffffff8129f418>] jbd2_journal_destroy+0x1a8/0x240
[    1.279862]  [<ffffffff810a7710>] ? __wake_up_common+0x90/0x90
[    1.279862]  [<ffffffff8126120f>] ext4_put_super+0x5f/0x370
[    1.279862]  [<ffffffff811547dd>] generic_shutdown_super+0x6d/0xf0
[    1.279862]  [<ffffffff81155a12>] kill_block_super+0x22/0x70
[    1.279862]  [<ffffffff811544fc>] deactivate_locked_super+0x3c/0x60
[    1.279862]  [<ffffffff8115457c>] deactivate_super+0x5c/0x60
[    1.279862]  [<ffffffff811728c1>] mntput_no_expire+0x171/0x260
[    1.279862]  [<ffffffff811744aa>] ? SyS_oldumount+0x7a/0xe0
[    1.279862]  [<ffffffff811744aa>] SyS_oldumount+0x7a/0xe0
[    1.279862]  [<ffffffff81859aa8>] sysenter_dispatch+0x7/0x25
[    1.279862] Code: 1f 40 00 8b 45 a8 3e 29 82 cc 00 00 00 4c 89 e7 e8 06 fc ff ff 48 89 df e8 fe 32 5c 00 49 8b 04 24 a8 01 0f 84 a7 fd ff ff 66 90 <0f> 0b 66 0f 1f 44 00 00 8b 45 a8 3e 41 29 00 48 89 df e8 19 34
[    1.279862] RIP  [<ffffffff81293e60>] start_this_handle+0x330/0x760
[    1.279862]  RSP <ffff88000042fc60>
[    1.301916] ---[ end trace 52c6387c01b65be9 ]---
[    1.302279] Kernel panic - not syncing: Fatal exception
[    1.302792] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    1.303577] Rebooting in 1 seconds..

	Sami

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUMIz3AAoJEKLT589SE0a0SwcQAMyLrpUbmyC4R09ijUOmxETa
Dyk/zPyqfe8JJEgY5JmnWHSFU6IU5R3DCUNQMmTBAd/s1LPjfQzBFekI/fQHiatx
9LGUSraWBzLHI1ss5urXPDjpzKU1Q/HMuJzaQM2ULR5yuBft7O+56xoEAfL8Ifoy
EDdsFUR3p2+QRMAHl680RffKUWBRXQyKE36CRQ02RykcsDZJ4Zpqp6l9b2XMpy/s
Z023uU78x+R3UCGzNF5+PPGaPcKouANfkboWHA80utuh04wuWgXgy3USLtfO/0v5
MXVZsezEN8kI7Va6B42Jml8FUWPdzpLLF0VOUrBv5WYcxUuS6H090R73ryEH135K
Ap5KeKPiGmSNsweDWNA/GNnK6X6q7LLghCisbKuIz//FcYZsqb0T3ZI9Ce+u6U+G
Q/jXBVqPRMXiK1sOiJJcmayvG+aGPgEoPnwEHBZC3cZ7lyfzO4XmJCU16621Yqvu
2inzPgOd7yhkbS0Te4pscvOkH4izQxA9auPmOTqd5i3GShBtOPskZgnOmB/NQwZz
9Ni55PpkXyZNJkF+N5UOxYZV8PvB/g3uZ7jvCak+7IGOZcvOnFUu/R5W6VlbDC2W
xeaxqxgsVrZn1RdJfXeFsMDwZgJBJNTnNiFMv065FXpAdxl/FMOWf9Tfc2iqBPQH
YpNOSBMz8jXsRncjt2WX
=n3mk
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
