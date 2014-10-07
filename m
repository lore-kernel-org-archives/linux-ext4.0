From: Sami Liedes <sami.liedes@iki.fi>
Subject: One more corrupted fs crash in ext4_put_super
Date: Tue, 7 Oct 2014 23:56:43 +0300
Message-ID: <20141007205643.GF27150@sli.dy.fi>
References: <20141005001239.GD27150@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:48062 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaJGU4s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2014 16:56:48 -0400
Content-Disposition: inline
In-Reply-To: <20141005001239.GD27150@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--BRE3mIcgqKzpedwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Here's one more filesystem that causes a crash in ext4_put_super on
3.17 both with and without the two patches from this thread applied.

Interestingly this one does not seem to crash on 3.16.4, with or
without the patches from this thread. Even on 3.17 I *think* I've seen
it not crash, but the reproducibility seems to be well over 95%.

Crashing image:

  http://www.niksula.hut.fi/~sliedes/ext4/ext4_put_super/testimg.ext4.112041.min.bz2

Pristine image:

  http://www.niksula.hut.fi/~sliedes/ext4/testimg.ext4.pristine.bz2

Diff:

--- /dev/fd/63  2014-10-07 23:52:33.397018880 +0300
+++ /dev/fd/62  2014-10-07 23:52:33.398018880 +0300
@@ -36771,7 +36771,7 @@
 001bd040  65 76 65 6e 74 30 00 00  b8 04 00 00 10 00 05 02  |event0..........|
 001bd050  62 79 2d 69 64 00 00 00  bc 04 00 00 10 00 07 02  |by-id...........|
 001bd060  62 79 2d 70 61 74 68 00  c2 04 00 00 10 00 06 03  |by-path.........|
-001bd070  65 76 65 6e 74 35 00 00  c3 04 00 00 0c 00 04 03  |event5..........|
+001bd070  65 76 65 6e 74 35 00 00  c3 00 00 00 0c 00 04 03  |event5..........|
 001bd080  6d 69 63 65 c4 04 00 00  10 00 06 03 65 76 65 6e  |mice........even|
 001bd090  74 32 00 00 c5 04 00 00  10 00 06 03 65 76 65 6e  |t2..........even|
 001bd0a0  74 33 00 00 c6 04 00 00  5c 03 06 03 65 76 65 6e  |t3......\...even|

Backtrace:

[    1.936509] EXT4-fs (vdb): sb orphan head is 195
[    1.936889] sb_info orphan list:
[    1.937145]   inode vdb:195 at ffff880006675d90: mode 40755, nlink 0, next 0
[    1.937699] ------------[ cut here ]------------
[    1.938057] kernel BUG at fs/ext4/super.c:836!
[    1.938419] invalid opcode: 0000 [#1] SMP
[    1.938788] CPU: 0 PID: 1041 Comm: umount Not tainted 3.17.0+ #32
[    1.939278] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    1.940059] task: ffff8800060bd2d0 ti: ffff88000639c000 task.ti: ffff88000639c000
[    1.940299] RIP: 0010:[<ffffffff812753e6>]  [<ffffffff812753e6>] ext4_put_super+0x366/0x370
[    1.940299] RSP: 0018:ffff88000639fe70  EFLAGS: 00010287
[    1.940299] RAX: 0000000000000040 RBX: ffff8800063b6800 RCX: 0000000000006665
[    1.940299] RDX: 0000000000000040 RSI: 0000000000000001 RDI: 0000000000000286
[    1.940299] RBP: ffff88000639fea0 R08: 0000000000000001 R09: 0000000000000000
[    1.940299] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800063b6b28
[    1.940299] R13: ffff8800063b6000 R14: ffff8800063b6a88 R15: ffff8800063b6b28
[    1.940299] FS:  0000000000000000(0000) GS:ffff880007c00000(0063) knlGS:00000000f7549780
[    1.940299] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[    1.940299] CR2: 000000000a02e004 CR3: 000000000635f000 CR4: 00000000000006b0
[    1.940299] Stack:
[    1.940299]  ffff880000000000 ffff8800063b6000 ffff8800063b60f8 ffffffff81a33e00
[    1.940299]  0000000000000000 0000000000000000 ffff88000639fec8 ffffffff81164ebd
[    1.940299]  0000000000000083 ffff880006c0d600 ffff8800063a2780 ffff88000639fee8
[    1.940299] Call Trace:
[    1.940299]  [<ffffffff81164ebd>] generic_shutdown_super+0x6d/0xf0
[    1.940299]  [<ffffffff81166122>] kill_block_super+0x22/0x70
[    1.940299]  [<ffffffff81164bdc>] deactivate_locked_super+0x3c/0x60
[    1.940299]  [<ffffffff81164c5c>] deactivate_super+0x5c/0x60
[    1.940299]  [<ffffffff81183cd0>] mntput_no_expire+0x180/0x210
[    1.940299]  [<ffffffff81185757>] ? SyS_umount+0x87/0x100
[    1.940299]  [<ffffffff81185757>] SyS_umount+0x87/0x100
[    1.940299]  [<ffffffff8188e888>] sysenter_dispatch+0x7/0x2a
[    1.940299]  [<ffffffff8165e9cb>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.940299] Code: b0 10 05 00 00 41 8b 87 64 ff ff ff 89 04 24 31 c0 e8 f7 ae 60 00 4d 8b 3f 4d 39 fc 75 b5 4c 3b a3 28 03 00 00 0f 84 af fe ff ff <0f> 0b 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 4c 8d a7 90 fe
[    1.940299] RIP  [<ffffffff812753e6>] ext4_put_super+0x366/0x370
[    1.940299]  RSP <ffff88000639fe70>
[    1.958649] ---[ end trace 6419dd181c457894 ]---
[    1.959008] Kernel panic - not syncing: Fatal exception
[    1.959568] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    1.960337] Rebooting in 1 seconds..

--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUNFOLAAoJEKLT589SE0a05LgQAJdM1It52wOaX+xTVN6PGwS+
tQLR3tH5wJf+rNCCNYJedmAjhe05rjTINNbwz5z3B4n8tjzWG5AsHr27w2phT3dN
Zh8ZyXzTrSChAfYZhQhleJur58JE9inlEdaAIIj1D7MLwjJfuQcYhDgb3vJNIgF4
fbiZ7Z5M0xr1BxSfqDLzGBeteZymv61/1U8tuf6JAvqgg1MxAvAoXarhJAB6qCQ9
EazNZxmI1UJSpLwO7RrMECzvu1QKvc5XvsbwQyvFjNXM7Vxv159AN/U9HzG2VqEi
EG9dT972WrrVoVnIge+D73m3DmkgejzVbUzzMYKzLkMNwmbkJCga2oW2hzrSm3zs
cS5k6ejkAeWgEWlo/nD9OAJnfWjNDOk1a6do7QjBrLL7WAwIQZNgeXYQp6wOLCA4
Cn9tY0LGyh8SzAHFJRLToK5Vwv6wE0QlovPVeJN9VTZcakHxuUaiuYLLb7I1l0iR
BDg4VnARAwrApARHsXFiyiSxxrJu8nSORjt04FlkEYtSvBwe3uUM71VWFJMCKbrB
+ayi0AfE7WwzdxXX/GgDBxlY6XzB6zUuoJQa0PRTTPKagqJ1LSV9+JG/tDvzVd/V
M6z28lsJfU5v7FzP0j1rvw8eEY7B0DCLU5eXOKL0jNzrBQgxr6UZcASQP1qfR8nf
UW0LiNoUHQQbnL8G0YjW
=3T9J
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
