From: Sami Liedes <sami.liedes@iki.fi>
Subject: Intentionally corrupted ext4: panic in
 jbd2_journal_commit_transaction()
Date: Tue, 7 Oct 2014 23:34:58 +0300
Message-ID: <20141007203458.GE27150@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:34023 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaJGUfC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2014 16:35:02 -0400
Received: from sli.dy.fi (a91-156-209-44.elisa-laajakaista.fi [91.156.209.44])
	by gw01.mail.saunalahti.fi (Postfix) with ESMTP id 1C91D40028
	for <linux-ext4@vger.kernel.org>; Tue,  7 Oct 2014 23:34:58 +0300 (EEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Here's one more ext4 filesystem with a single bit corrupted in a way
that causes a crash on 3.17 with the two patches from this thread
applied.

Corrupted image:

   http://www.niksula.hut.fi/~sliedes/ext4/jbd2_journal_commit_transaction/testimg.ext4.23934.min.bz2

Pristine image:

   http://www.niksula.hut.fi/~sliedes/ext4/testimg.ext4.pristine.bz2

Diff:

--- /dev/fd/63  2014-10-07 23:10:25.527812967 +0300
+++ /dev/fd/62  2014-10-07 23:10:25.527812967 +0300
@@ -552,7 +552,7 @@
 00012ba0  00 00 08 00 00 00 00 00  0a f3 03 00 04 00 00 00  |................|
 00012bb0  00 00 00 00 00 00 00 00  01 00 00 00 39 00 00 00  |............9...|
 00012bc0  01 00 00 00 0e 00 00 00  3c 00 00 00 0f 00 00 00  |........<.......|
-00012bd0  f1 03 00 00 8b 01 00 00  00 00 00 00 00 00 00 00  |................|
+00012bd0  f1 03 00 00 8b 00 00 00  00 00 00 00 00 00 00 00  |................|
 00012be0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
 *
 00012d00  e4 41 00 00 00 30 00 00  c8 a7 4a 48 9e 26 bf 48  |.A...0....JH.&.H|

Backtrace:

[    5.085227] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: errors=continue
[    5.179552] ------------[ cut here ]------------
[    5.180205] kernel BUG at fs/jbd2/commit.c:848!
[    5.180751] invalid opcode: 0000 [#1] SMP
[    5.181186] CPU: 0 PID: 878 Comm: jbd2/vdb-8 Not tainted 3.17.0+ #29
[    5.181186] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    5.181186] task: ffff880000066360 ti: ffff880004c98000 task.ti: ffff880004c98000
[    5.181186] RIP: 0010:[<ffffffff812ad28f>]  [<ffffffff812ad28f>] jbd2_journal_commit_transaction+0x16df/0x1c50
[    5.181186] RSP: 0018:ffff880004c9bc78  EFLAGS: 00010246
[    5.181186] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000180270022
[    5.181186] RDX: 0000000180270023 RSI: ffffea0000193080 RDI: ffff880006513070
[    5.181186] RBP: ffff880004c9bde8 R08: 00000000064c2f01 R09: 0000000180270022
[    5.181186] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800044ce680
[    5.181186] R13: ffff8800064c28f0 R14: ffff8800063cb000 R15: ffff880000c39000
[    5.181186] FS:  0000000000000000(0000) GS:ffff880007c00000(0000) knlGS:0000000000000000
[    5.181186] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.181186] CR2: 00000000f7780866 CR3: 00000000050ef000 CR4: 00000000000006b0
[    5.181186] Stack:
[    5.181186]  ffff880007d68c00 0000001804c9bd50 0000000134960a6e ffffffff00000008
[    5.181186]  0000000000000234 ffff880000c390cc 0000000000000000 ffff880005c82000
[    5.181186]  ffff880000c39000 ffff880000c39050 ffff880007d68dcc ffff880004c9bd40
[    5.181186] Call Trace:
[    5.181186]  [<ffffffff812b2bd3>] kjournald2+0x143/0x3c0
[    5.181186]  [<ffffffff810a5110>] ? __wake_up_common+0x90/0x90
[    5.181186]  [<ffffffff812b2a90>] ? __jbd2_debug+0x60/0x60
[    5.181186]  [<ffffffff8108a451>] kthread+0xf1/0x110
[    5.181186]  [<ffffffff8108a360>] ? __kthread_parkme+0x70/0x70
[    5.181186]  [<ffffffff8188c77c>] ret_from_fork+0x7c/0xb0
[    5.181186]  [<ffffffff8108a360>] ? __kthread_parkme+0x70/0x70
[    5.181186] Code: 00 00 49 8b 5f 28 e9 51 f1 ff ff 0f 0b 48 8b 7c 24 70 e8 f5 e8 5d 00 48 8d 84 24 c8 00 00 00 48 89 44 24 58 e9 1a f0 ff ff 0f 0b <0f> 0b 65 ff 04 25 a0 b8 00 00 48 8b 1d 80 b7 c3 00 48 85 db 74
[    5.181186] RIP  [<ffffffff812ad28f>] jbd2_journal_commit_transaction+0x16df/0x1c50
[    5.181186]  RSP <ffff880004c9bc78>
[    5.204927] ---[ end trace f1b91b47d2c74c2f ]---
[    5.205477] Kernel panic - not syncing: Fatal exception
[    5.206217] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    5.207413] Rebooting in 1 seconds..

	Sami

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUNE5yAAoJEKLT589SE0a05vYP/1WJULeAw76QgBYdNwK5k965
+PPN+3nR1cwDXkNUI0E8r2TlzXW/eIKRMTcN3C3s/1rME6DtX79cxyR7KEBXDf9/
z4og4+rVgsY+qQJhffU9wUBnqo0m9Qw1aIYQ3uJ8B7jhKraiVjPX3PYQr3cpjNFq
NzEbxljF//iedQV1nXCiz8yfbL8GxrJVzptTL6Ks3F4LSfGpJogXrMtYIB9995fn
gRUX/p74X9LczdLVRha+t/TitT29Vp5GfNloL2ueoPadiFLc3nybfnR8cGuALaSJ
22iFzOGZbZcGUn2FZi2XlD7day0CkvZ628HmAYdJhfkpz9zunRN/ttYdUaU8NK7t
vzKOeieM44fhmLAi2F8fmc40eDVFQHPpt13v3kd8T7rumqxjucXiajF6sWg2uwjD
12b6WgDDBukbGOTuvOnXYXDZOR+VGMnDe9xZiH/qSFSYss49KDSE9omMcD9j2ijJ
6n4zYTVX2SVXzxs5h5bf1cBaUUHpitZBK6tSZkQEOBTVXI4MLvZMmVVqUMky/WgK
bJP5lkaj3ZIwnncXFTxOsnnFyh8kzGKJkO8oD6i/YrS2/PbFhmB35lDHS9DS7bSC
+U7j/jlklLrqo6t/PtKtUvza3eSCei18ncqmzJNqil+Na3Zwm+otBfKjL6z6pTkE
/Sk3Ihw4d7p6uBQsDvta
=kCXr
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
