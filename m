From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: 3.3 oops
Date: Mon, 02 Apr 2012 09:25:10 +0300
Message-ID: <1333347910.5440.81.camel@sauron.fi.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qpWUiMNOP+lE3oPcdiyV"
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21817 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2DBGV5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 02:21:57 -0400
Received: from [10.237.72.167] (sauron.fi.intel.com [10.237.72.167])
	by linux.intel.com (Postfix) with ESMTP id 82AAF6A4007
	for <linux-ext4@vger.kernel.org>; Sun,  1 Apr 2012 23:21:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-qpWUiMNOP+lE3oPcdiyV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I am testing vanilla 3.3 kernel under kvm using xfstests and kernel
usually oopses when I run it overnight, e.g.:

[36928.586097] ------------[ cut here ]------------
[36928.586198] kernel BUG at fs/buffer.c:2871!
[36928.586280] invalid opcode: 0000 [#1] SMP=20
[36928.586374] CPU 1=20
[36928.586414] Modules linked in: [last unloaded: scsi_wait_scan]
[36928.586615]=20
[36928.586650] Pid: 11400, comm: fsstress Not tainted 3.3.0+ #43 Bochs Boch=
s
[36928.586792] RIP: 0010:[<ffffffff811a9add>]  [<ffffffff811a9add>] submit_=
bh+0x10d/0x120
[36928.586985] RSP: 0018:ffff880121713758  EFLAGS: 00010202
[36928.587045] RAX: 000000000004d025 RBX: ffff8802256a4a90 RCX: 00000000000=
00005
[36928.587045] RDX: ffff880121713fd8 RSI: ffff8802256a4a90 RDI: 00000000000=
00211
[36928.587045] RBP: ffff880121713778 R08: ffff8804075c0770 R09: 00001600000=
00000
[36928.587045] R10: 0000000000000001 R11: ffff880406fdd480 R12: 00000000000=
00211
[36928.587045] R13: ffff880121713834 R14: ffff88012a9c2000 R15: ffff8801217=
13fd8
[36928.587045] FS:  00007f5470a81700(0000) GS:ffff88041fc20000(0000) knlGS:=
0000000000000000
[36928.587045] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[36928.587045] CR2: 00007f546c02c698 CR3: 000000012e4e9000 CR4: 00000000000=
006e0
[36928.587045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[36928.587045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[36928.587045] Process fsstress (pid: 11400, threadinfo ffff880121712000, t=
ask ffff8802cbba5c40)
[36928.587045] Stack:
[36928.587045]  ffff88012a9c2000 ffff8802256a4a90 0000000000000211 ffff8801=
21713834
[36928.587045]  ffff880121713798 ffffffff811ab59d 000000000000000a ffff8801=
2a9c2168
[36928.587045]  ffff8801217137f8 ffffffff8123be2d 0000000091827364 ffff8801=
217137b0
[36928.587045] Call Trace:
[36928.587045]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
[36928.587045]  [<ffffffff8123be2d>] __flush_batch+0x4d/0xa0
[36928.587045]  [<ffffffff8123c615>] jbd2_log_do_checkpoint+0xf5/0x4f0
[36928.587045]  [<ffffffff8123ca99>] __jbd2_log_wait_for_space+0x89/0x190
[36928.587045]  [<ffffffff81237aa8>] start_this_handle+0x3a8/0x4e0
[36928.587045]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
[36928.587045]  [<ffffffff81237ca3>] jbd2__journal_start+0xc3/0x100
[36928.587045]  [<ffffffff81237cf3>] jbd2_journal_start+0x13/0x20
[36928.587045]  [<ffffffff8121740f>] ext4_journal_start_sb+0x7f/0x1d0
[36928.587045]  [<ffffffff811f9322>] ? ext4_write_begin+0x112/0x310
[36928.587045]  [<ffffffff812404ab>] ? jbd2_journal_force_commit_nested+0x5=
b/0xa0
[36928.587045]  [<ffffffff811f9322>] ext4_write_begin+0x112/0x310
[36928.587045]  [<ffffffff811f96d4>] ext4_da_write_begin+0x1b4/0x210
[36928.587045]  [<ffffffff812383e7>] ? jbd2_journal_stop+0x1b7/0x2b0
[36928.587045]  [<ffffffff8111af42>] generic_file_buffered_write+0x112/0x29=
0
[36928.587045]  [<ffffffff8111c7b9>] __generic_file_aio_write+0x229/0x440
[36928.587045]  [<ffffffff8111ca42>] generic_file_aio_write+0x72/0xe0
[36928.587045]  [<ffffffff811f319f>] ext4_file_write+0xbf/0x260
[36928.587045]  [<ffffffff81165d5f>] ? kmem_cache_free+0x2f/0x130
[36928.587045]  [<ffffffff81186af3>] ? putname+0x33/0x50
[36928.587045]  [<ffffffff8117ada2>] do_sync_write+0xd2/0x110
[36928.587045]  [<ffffffff812633bc>] ? security_file_permission+0x2c/0xb0
[36928.587045]  [<ffffffff8117b321>] ? rw_verify_area+0x61/0xf0
[36928.587045]  [<ffffffff8117b683>] vfs_write+0xb3/0x180
[36928.587045]  [<ffffffff8117b9aa>] sys_write+0x4a/0x90
[36928.587045]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
[36928.587045] Code: ee 44 89 e7 e8 45 1f 0f 00 49 8b 5d 18 4c 89 ef e8 19 =
4e 00 00 48 83 c4 08 c1 e3 18 c1 fb 1f 83 e3 a1 89 d8 5b 41 5c 41 5d 5d c3 =
<0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48=20
[36928.587045] RIP  [<ffffffff811a9add>] submit_bh+0x10d/0x120
[36928.587045]  RSP <ffff880121713758>
[36928.603933] ---[ end trace 8b118138c2b68b02 ]---
[36928.604272] ------------[ cut here ]------------
[36928.604587] WARNING: at kernel/exit.c:897 do_exit+0x55/0x870()
[36928.604933] Hardware name: Bochs
[36928.605235] Modules linked in: [last unloaded: scsi_wait_scan]
[36928.605726] Pid: 11400, comm: fsstress Tainted: G      D      3.3.0+ #43
[36928.606154] Call Trace:
[36928.606420]  [<ffffffff810572bf>] warn_slowpath_common+0x7f/0xc0
[36928.606852]  [<ffffffff8105731a>] warn_slowpath_null+0x1a/0x20
[36928.607251]  [<ffffffff8105b1c5>] do_exit+0x55/0x870
[36928.607581]  [<ffffffff81058f6c>] ? kmsg_dump+0x5c/0xf0
[36928.607935]  [<ffffffff815dfeac>] oops_end+0xac/0xf0
[36928.608273]  [<ffffffff81017928>] die+0x58/0x90
[36928.608645]  [<ffffffff815df7a4>] do_trap+0xc4/0x170
[36928.608953]  [<ffffffff81014fa5>] do_invalid_op+0x95/0xb0
[36928.609361]  [<ffffffff811a9add>] ? submit_bh+0x10d/0x120
[36928.609685]  [<ffffffff8129eefc>] ? blk_queue_bio+0x3bc/0x400
[36928.610028]  [<ffffffff815e7f9b>] invalid_op+0x1b/0x20
[36928.610464]  [<ffffffff811a9add>] ? submit_bh+0x10d/0x120
[36928.610827]  [<ffffffff811a9ac7>] ? submit_bh+0xf7/0x120
[36928.611187]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
[36928.611586]  [<ffffffff8123be2d>] __flush_batch+0x4d/0xa0
[36928.611900]  [<ffffffff8123c615>] jbd2_log_do_checkpoint+0xf5/0x4f0
[36928.612324]  [<ffffffff8123ca99>] __jbd2_log_wait_for_space+0x89/0x190
[36928.612689]  [<ffffffff81237aa8>] start_this_handle+0x3a8/0x4e0
[36928.613095]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
[36928.613424]  [<ffffffff81237ca3>] jbd2__journal_start+0xc3/0x100
[36928.613752]  [<ffffffff81237cf3>] jbd2_journal_start+0x13/0x20
[36928.614097]  [<ffffffff8121740f>] ext4_journal_start_sb+0x7f/0x1d0
[36928.614428]  [<ffffffff811f9322>] ? ext4_write_begin+0x112/0x310
[36928.614824]  [<ffffffff812404ab>] ? jbd2_journal_force_commit_nested+0x5=
b/0xa0
[36928.615437]  [<ffffffff811f9322>] ext4_write_begin+0x112/0x310
[36928.615762]  [<ffffffff811f96d4>] ext4_da_write_begin+0x1b4/0x210
[36928.616108]  [<ffffffff812383e7>] ? jbd2_journal_stop+0x1b7/0x2b0
[36928.616438]  [<ffffffff8111af42>] generic_file_buffered_write+0x112/0x29=
0
[36928.616776]  [<ffffffff8111c7b9>] __generic_file_aio_write+0x229/0x440
[36928.617133]  [<ffffffff8111ca42>] generic_file_aio_write+0x72/0xe0
[36928.617465]  [<ffffffff811f319f>] ext4_file_write+0xbf/0x260
[36928.617783]  [<ffffffff81165d5f>] ? kmem_cache_free+0x2f/0x130
[36928.618133]  [<ffffffff81186af3>] ? putname+0x33/0x50
[36928.618643]  [<ffffffff8117ada2>] do_sync_write+0xd2/0x110
[36928.619166]  [<ffffffff812633bc>] ? security_file_permission+0x2c/0xb0
[36928.619609]  [<ffffffff8117b321>] ? rw_verify_area+0x61/0xf0
[36928.619929]  [<ffffffff8117b683>] vfs_write+0xb3/0x180
[36928.620344]  [<ffffffff8117b9aa>] sys_write+0x4a/0x90
[36928.620690]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
[36928.621100] ---[ end trace 8b118138c2b68b03 ]---

Here is how I run kvm:

#!/bin/sh -efu

IMAGE=3D"np_ubifs.img"
DEVEL_DISK1=3D"devel-disk-1.img"
DEVEL_DISK2=3D"devel-disk-2.img"

kvm -m 16384 -spice port=3D7837,disable-ticketing \
        -cpu core2duo -smp 12,sockets=3D1,cores=3D6,threads=3D2 \
        -enable-kvm -name np_ubifs \
        -drive file=3D$IMAGE,if=3Dvirtio,cache=3Dnone,boot=3Don \
        -drive file=3D$DEVEL_DISK1,if=3Dvirtio,cache=3Dnone \
        -drive file=3D$DEVEL_DISK2,if=3Dvirtio,cache=3Dnone \
        -rtc base=3Dutc \
        -net nic,model=3Dvirtio -net user \
        -device virtio-balloon-pci \
        -redir tcp:7838::22


xfstests setup:

TEST_DIR=3D/mnt/xfstests-disk-1
TEST_DEV=3D/dev/vdb
SCRATCH_MNT=3D/mnt/xfstests-disk-2
SCRATCH_DEV=3D/dev/vdc
FSTYP=3Dext4

/dev/vdb is 4GiB
/dev/vdc is 12GiB

Then I just run something like this in a forever loop:


#!/bin/sh -euf

sudo umount $TEST_DEV ||:
sudo umount $SCRATCH_DEV ||:

mkfs.ext4 $TEST_DEV
mkfs.ext4 $SCRATCH_DEV

mount $TEST_DEV $TEST_DIR
mount $SCRATCH_DEV $SCRATCH_MNT

./check -g auto


where "check" is the xfstests' script.

--=20
Best Regards,
Artem Bityutskiy

--=-qpWUiMNOP+lE3oPcdiyV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPeUZGAAoJECmIfjd9wqK0ploP/R7H6YI10Bwje9fhsOZtvyNS
B8J6ft6sh5TKHYjYCPq3qaYi/ahUlY3XM8an2oIYFSQDb3LwvnWzxqDy7E3Go7MW
uaeNcwKvKtFha0Ci9bY9BF4sNeL6Y7LM+FFEt1yK7jDms51TujqWJSKBwsEtrP/f
k7oe6DklQFdE5o09RCi9B2va3Nj+AlAODBjoWLuE0FJR/mMsOD4lVAU4QfNAH0lo
196zFda4qtdm+ic9MfIQzpU8yxxutND4cXQhsy+z9aWSe57vLjpQcUA04Q3m0mCR
4OrCh2bc0rV2yxKYHpBN2rBfiNin3SNXSl/GioSjdGOTSSVpqs2fyB0POHmVXBGa
Mg/b2NrH9aWzvSE6ZhBdFwPjqBHbdXwssUGbgHLSI6vfDhfQu3hA0j/HUBvxDUHs
gt3onLM7e4QhyQLMeYkLZaJbhS2mhj6I4Yg0gGR5RdEk2qRHdITZnTx8TlodyLla
Wm030EGBjUsQS5PoNz/fzAKDMyE6yehuBLeXAVAd5WJ/K0/ggXDIWolnCWIm/5Rx
0RoYXeVRvp+pgrrhIVGdbSviOSTPjBhgeU7zm22WknS1gA1Q7H1m8IZ+Cyg2LKb1
bTFOszyF6CINDKFziXgZpknjFf4Z54XD30axSMphG68Jv+e+EOAGZ33rde3Hue+F
XsagE8Umxjv6ZCILEV6z
=z5Ur
-----END PGP SIGNATURE-----

--=-qpWUiMNOP+lE3oPcdiyV--

