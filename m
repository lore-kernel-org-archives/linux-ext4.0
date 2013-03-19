From: Nix <nix@esperi.org.uk>
Subject: ext4: recursive oops doing online resize on 3.8.3, flexbg-related
Date: Tue, 19 Mar 2013 20:32:17 +0000
Message-ID: <87vc8n6sha.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:54274 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934089Ab3CSVZD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 17:25:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yes, it's another issue of 'Nix uses experimental options long before
they are fully baked and causes trouble after years in which they seemed
to work perfectly fine'.

So I tried to double the size of one of my ext4 filesystems just now,
using x86-64 Linux 3.8.3. Like almost all my filesystems, it's ext4 atop
LVM atop hardware RAID (on the same machine that experienced the
infamous journal_async_commit and reboot-during-unmount corruption bug
last year, as it happens). I did an online resize because the filesystem
is NFS-exported so unmounting it is a bit of a pain.

The resize never terminated, and most (but not all) I/O to ext4
filesystems locked up: looks like we grabbed a lock and never let it go.
And, indeed, we had oopses. On reboot, the thing journal-replayed and
did an unmounted resize fine: I took an e2image beforehand (but after it
had been mounted by the system on boot, and umounted by me).

I'm using a few-day-old resize2fs, from the maint branch of e2fsprogs,
commit 871ad94.

The filesystem is bind-mounted in two places, with the following
mount options (for fs features and other tune2fs output, see the bottom
of this email):

rw,nosuid,nodev,relatime,nobarrier,quota,usrquota,grpquota,commit=30,stripe=16,data=ordered,usrquota,grpquota

(hm, why are 'usrquota, grpquota' repeated? not important...)

This is not by any means the first time I've done an online resize of a
flexbg ext4 filesystem on this box. The last such was on April 17th
2012, using kernel 3.2.10 and e2fsprogs 1.42.1, and it worked fine. (I'm
aware this is such a large gap in time as to be basically useless for
problem resolution, but still.)

I'm quite glad not all ext4 I/O hung: this is also my loghost, so the
oopses were being logged to one of the afflicted filesystems! Here they
are:

info: [191093.449107] EXT4-fs (dm-6): resizing filesystem from 13107200 to 26214400 blocks
info: [191093.451269] EXT4-fs (dm-6): resizing filesystem from 16777216 to 26214400 blocks
info: [191093.451687] EXT4-fs (dm-6): Converting file system to meta_bg
info: [191093.474152] EXT4-fs (dm-6): resizing filesystem from 16777216 to 26214400 blocks
warning: [191093.474594] ------------[ cut here ]------------
crit: [191093.474821] kernel BUG at fs/ext4/resize.c:404!
warning: [191093.475048] invalid opcode: 0000 [#1] SMP
warning: [191093.475341] Modules linked in: firewire_ohci firewire_core [last unloaded: microcode]
warning: [191093.475891] CPU 0
warning: [191093.475934] Pid: 23548, comm: resize2fs Not tainted 3.8.3-dirty #1 empty empty/S7010
warning: [191093.476556] RIP: 0010:[<ffffffff811af44f>]  [<ffffffff811af44f>] set_flexbg_block_bitmap+0x8f/0x149
warning: [191093.477008] RSP: 0018:ffff88052327bb58  EFLAGS: 00010216
warning: [191093.477237] RAX: ffff8805bb4cd300 RBX: 0000000000000081 RCX: 0000000001008000
warning: [191093.477648] RDX: 0000000000000001 RSI: ffff8806113aa000 RDI: ffff88062234cc00
warning: [191093.478056] RBP: ffff88052327bbb8 R08: ffff88052327bb84 R09: 0000000000000000
warning: [191093.478466] R10: 00000000000001a7 R11: 0000000000000000 R12: ffff88062234c800
warning: [191093.478876] R13: ffff88013212e068 R14: ffff880523022040 R15: 0000000001008000
warning: [191093.479286] FS:  00007f73c45e0740(0000) GS:ffff88063fc00000(0000) knlGS:0000000000000000
warning: [191093.479698] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
warning: [191093.479929] CR2: 00007ff3f4364000 CR3: 000000039e119000 CR4: 00000000000027f0
warning: [191093.480345] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
warning: [191093.480756] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
warning: [191093.490624] Process resize2fs (pid: 23548, threadinfo ffff88052327a000, task ffff8805bb770000)
warning: [191093.491038] Stack:
warning: [191093.491254]  ffff88013212e068 01008000816386e0 ffff880623fe07b0 0000008101008000
warning: [191093.491802]  ffff88052327bbb8 00000001811b7782 ffff88052327bbb8 0000000000000008
warning: [191093.492352]  0000000000000040 0000000000000200 ffff88062234c800 0000000000000000
warning: [191093.492900] Call Trace:
warning: [191093.493120]  [<ffffffff811afa9e>] ext4_flex_group_add+0x595/0x1456
warning: [191093.493353]  [<ffffffff811b199f>] ext4_resize_fs+0x8ca/0xba7
warning: [191093.493585]  [<ffffffff8113bd16>] ? __mnt_want_write+0x48/0x4f
warning: [191093.493819]  [<ffffffff81193a36>] ext4_ioctl+0x83e/0x967
warning: [191093.494049]  [<ffffffff811300b8>] ? do_filp_open+0x38/0x86
warning: [191093.494280]  [<ffffffff8113158a>] vfs_ioctl+0x26/0x39
warning: [191093.494508]  [<ffffffff81131e02>] do_vfs_ioctl+0x3ba/0x3fd
warning: [191093.494738]  [<ffffffff8111bd1c>] ? kmem_cache_free+0x5d/0x105
warning: [191093.494969]  [<ffffffff8112c91b>] ? final_putname+0x35/0x3a
warning: [191093.495198]  [<ffffffff81131e9c>] sys_ioctl+0x57/0x87
warning: [191093.495428]  [<ffffffff8151bd12>] system_call_fastpath+0x16/0x1b
warning: [191093.495657] Code: 49 8b 44 24 18 89 4d b8 8d 04 c1 44 29 f8 39 d8 0f 47 c3 89 45 bc 49 8b 46 08 f6 04 50 02 74 0d 41 83 7e 10 01 0f 86 98 00 00 00 <0f> 0b 48 8b 7d b0 e8 1c ff ff ff 85 c0 0f 85 98 00 00 00 8b 45
alert: [191093.498529] RIP  [<ffffffff811af44f>] set_flexbg_block_bitmap+0x8f/0x149
warning: [191093.498796]  RSP <ffff88052327bb58>
warning: [191093.499035] ---[ end trace 2931a3907f03d739 ]---
warning: [191093.499362] ------------[ cut here ]------------
crit: [191093.499588] kernel BUG at fs/jbd2/transaction.c:364!
warning: [191093.499814] invalid opcode: 0000 [#2] SMP
warning: [191093.500106] Modules linked in: firewire_ohci firewire_core [last unloaded: microcode]
warning: [191093.500713] CPU 0
warning: [191093.500756] Pid: 23548, comm: resize2fs Tainted: G      D      3.8.3-dirty #1 empty empty/S7010
warning: [191093.501377] RIP: 0010:[<ffffffff811c9d29>]  [<ffffffff811c9d29>] jbd2__journal_start+0x3e/0xdb
warning: [191093.501825] RSP: 0018:ffff88052327b3f8  EFLAGS: 00010206
warning: [191093.502053] RAX: ffff88060f069300 RBX: ffff880623fe07b0 RCX: 0000000000000018
warning: [191093.502461] RDX: 0000000000000050 RSI: 0000000000000002 RDI: ffff880622380800
warning: [191093.502870] RBP: ffff88052327b428 R08: 0000000000000040 R09: ffff88052327b868
warning: [191093.503277] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8805bb770000
warning: [191093.503687] R13: ffff880622380800 R14: ffffffff811921cf R15: 0000000000000000
warning: [191093.504096] FS:  00007f73c45e0740(0000) GS:ffff88063fc00000(0000) knlGS:0000000000000000
warning: [191093.504508] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
warning: [191093.504738] CR2: 00007ff3f4364000 CR3: 0000000001a0b000 CR4: 00000000000027f0
warning: [191093.505147] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
warning: [191093.505555] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
warning: [191093.505963] Process resize2fs (pid: 23548, threadinfo ffff88052327a000, task ffff8805bb770000)
warning: [191093.506375] Stack:
warning: [191093.506593]  78302b6874617074 00623178302f3631 ffff880093532400 ffff880624246800
warning: [191093.507143]  0000000000000002 ffffffff811921cf ffff88052327b438 ffffffff811c9dd9
warning: [191093.507690]  ffff88052327b468 ffffffff811ab104 ffff880093532400 ffff880093532400
warning: [191093.508237] Call Trace:
warning: [191093.508457]  [<ffffffff811921cf>] ? ext4_dirty_inode+0x1d/0x4c
warning: [191093.508688]  [<ffffffff811c9dd9>] jbd2_journal_start+0x13/0x15
warning: [191093.508921]  [<ffffffff811ab104>] ext4_journal_start_sb+0xca/0xf3
warning: [191093.509153]  [<ffffffff811921cf>] ext4_dirty_inode+0x1d/0x4c
warning: [191093.509385]  [<ffffffff811441ad>] __mark_inode_dirty+0x32/0x1e8
warning: [191093.509617]  [<ffffffff81137a0d>] update_time+0x9e/0xa7
warning: [191093.509846]  [<ffffffff8113b13c>] ? mnt_clone_write+0x12/0x2a
warning: [191093.510077]  [<ffffffff81137ab7>] file_update_time+0xa1/0xc2
warning: [191093.510313]  [<ffffffff810e46ae>] __generic_file_aio_write+0x1c2/0x2d7
warning: [191093.510546]  [<ffffffff8112537d>] ? __sb_start_write+0xc2/0xf6
warning: [191093.510776]  [<ffffffff810e4835>] generic_file_aio_write+0x72/0xd3
warning: [191093.511008]  [<ffffffff81189463>] ext4_file_write+0x37b/0x3b0
warning: [191093.511239]  [<ffffffff8112357c>] do_sync_write+0x96/0xd6
warning: [191093.511470]  [<ffffffff810ab73a>] do_acct_process.isra.4+0x2af/0x2e2
warning: [191093.511703]  [<ffffffff810abcf8>] acct_process+0x6b/0x8b
warning: [191093.511933]  [<ffffffff810684e0>] do_exit+0x31e/0x87c
warning: [191093.512161]  [<ffffffff8103ab58>] oops_end+0x82/0x87
warning: [191093.512387]  [<ffffffff8103ac93>] die+0x5a/0x63
warning: [191093.512611]  [<ffffffff8103834d>] do_trap+0x6e/0x13a
warning: [191093.512841]  [<ffffffff81084313>] ? __atomic_notifier_call_chain+0x12/0x14
warning: [191093.513073]  [<ffffffff8103861c>] do_invalid_op+0x96/0x9f
warning: [191093.513302]  [<ffffffff811af44f>] ? set_flexbg_block_bitmap+0x8f/0x149
warning: [191093.513535]  [<ffffffff811caeee>] ? do_get_write_access+0x37e/0x3ba
warning: [191093.513769]  [<ffffffff8151cc78>] invalid_op+0x18/0x20
warning: [191093.513998]  [<ffffffff811af44f>] ? set_flexbg_block_bitmap+0x8f/0x149
warning: [191093.514232]  [<ffffffff811af3fc>] ? set_flexbg_block_bitmap+0x3c/0x149
warning: [191093.514464]  [<ffffffff811afa9e>] ext4_flex_group_add+0x595/0x1456
warning: [191093.514697]  [<ffffffff811b199f>] ext4_resize_fs+0x8ca/0xba7
warning: [191093.514926]  [<ffffffff8113bd16>] ? __mnt_want_write+0x48/0x4f
warning: [191093.515157]  [<ffffffff81193a36>] ext4_ioctl+0x83e/0x967
warning: [191093.515387]  [<ffffffff811300b8>] ? do_filp_open+0x38/0x86
warning: [191093.515618]  [<ffffffff8113158a>] vfs_ioctl+0x26/0x39
warning: [191093.515846]  [<ffffffff81131e02>] do_vfs_ioctl+0x3ba/0x3fd
warning: [191093.516076]  [<ffffffff8111bd1c>] ? kmem_cache_free+0x5d/0x105
warning: [191093.516307]  [<ffffffff8112c91b>] ? final_putname+0x35/0x3a
warning: [191093.516537]  [<ffffffff81131e9c>] sys_ioctl+0x57/0x87
warning: [191093.516765]  [<ffffffff8151bd12>] system_call_fastpath+0x16/0x1b
warning: [191093.516994] Code: 48 83 ec 10 65 4c 8b 24 25 80 b8 00 00 48 85 ff 49 8b 9c 24 f0 05 00 00 0f 84 8a 00 00 00 48 85 db 74 12 48 8b 03 48 39 38 74 02 <0f> 0b ff 43 0c e9 83 00 00 00 48 8b 3d 5e ac af 00 41 89 f6 be
alert: [191093.519855] RIP  [<ffffffff811c9d29>] jbd2__journal_start+0x3e/0xdb
warning: [191093.520124]  RSP <ffff88052327b3f8>
warning: [191093.520353] ---[ end trace 2931a3907f03d73a ]---
alert: [191093.520580] Fixing recursive fault but reboot is needed!

("reboot is needed", like I can reboot when everything blocks. Big red
switch was needed :) )

tune2fs output of the e2image of the filesystem (which is 3.5Mb as an
lzipped qcow e2image, if anyone wants it, just ask):

tune2fs 1.42.7 (21-Jan-2013)
Filesystem volume name:   non-free
Last mounted on:          /pkg/non-free
Filesystem UUID:          07799ff5-baef-4492-875d-c73730d6149e
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              3276800
Block count:              13107200
Reserved block count:     655360
Free blocks:              2095428
Free inodes:              3184251
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stripe width:        16
Flex block group size:    64
Filesystem created:       Tue May 26 21:33:29 2009
Last mount time:          Tue Mar 19 19:47:26 2013
Last write time:          Tue Mar 19 19:51:08 2013
Mount count:              10
Maximum mount count:      33
Last checked:             Sun Oct 28 13:25:54 2012
Check interval:           15552000 (6 months)
Next check after:         Fri Apr 26 14:25:54 2013
Lifetime writes:          49 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      04d4f165-9ba9-40be-bdb4-c321cb0d6215
Journal backup:           inode blocks
