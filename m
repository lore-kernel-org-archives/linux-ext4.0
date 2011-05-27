From: Sage Weil <sage@newdream.net>
Subject: xattr crash in ext3_try_to_allocate_with_rsv
Date: Fri, 27 May 2011 13:02:20 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1105271256300.32088@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Fyodor Ustinov <ufm@ufm.su>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:46369 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1E0UAx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 May 2011 16:00:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey everyone,

There's a crash we've been seeing with xattrs on ext3.  I _thought_ it was 
always on older kernels (~.35 and older).  The crash below, though, is on 
2.6.39, which is the first time (I think) we've seen it on a new kernel.

We've never seen it on ext4; only ext3.

The workload is the ceph osd daemon, which makes extensive use of user 
xattrs.  It was pretty easy to reproduce on older kernels; I think Fyodor 
was triggering it pretty easily on .39 as well.  We haven't really looked 
closely since it goes away with ext4.

Here's a dump from 2.6.35: 
	http://www.spinics.net/lists/ceph-devel/msg00726.html

sage

---------- Forwarded message ----------
Date: Fri, 27 May 2011 22:41:44 +0300
From: Fyodor Ustinov <ufm@ufm.su>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org
Subject: Re: fs selection.

Hi!

May 27 14:33:25 osd2 kernel: [49531.310325] ------------[ cut here ]------------
May 27 14:33:25 osd2 kernel: [49531.310835] kernel BUG at fs/ext3/balloc.c:1404!
May 27 14:33:25 osd2 kernel: [49531.311339] invalid opcode: 0000 [#1] SMP
May 27 14:33:25 osd2 kernel: [49531.311804] last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
May 27 14:33:25 osd2 kernel: [49531.312664] CPU 1
May 27 14:33:25 osd2 kernel: [49531.312877] Modules linked in: btrfs
zlib_deflate libcrc32c 8021q garp stp xfs bonding psmouse xgifb(C) serio_raw lp
parport i3000_edac shpchp edac_core raid10 raid456 async_pq async_xor xor
async_memcpy async_raid6_recov e1000e e100 ahci libahci raid6_pq async_tx raid1
raid0 multipath linear
May 27 14:33:25 osd2 kernel: [49531.316080]
May 27 14:33:25 osd2 kernel: [49531.316237] Pid: 5505, comm: cosd Tainted: G
C  2.6.39-ufm2+ #1 empty empty/S5191
May 27 14:33:25 osd2 kernel: [49531.317164] RIP: 0010:[<ffffffff811d319c>]
[<ffffffff811d319c>] ext3_try_to_allocate_with_rsv+0x62c/0x630
May 27 14:33:25 osd2 kernel: [49531.318246] RSP: 0018:ffff880117d6f938  EFLAGS:
00010246
May 27 14:33:25 osd2 kernel: [49531.318826] RAX: 0000000000000027 RBX:
ffff8800a47f8840 RCX: ffffffff81bea460
May 27 14:33:25 osd2 kernel: [49531.319609] RDX: 0000000000000000 RSI:
0000000000000086 RDI: 0000000000000246
May 27 14:33:25 osd2 kernel: [49531.320004] RBP: ffff880117d6f9e8 R08:
0000000000000000 R09: 0000000000000000
May 27 14:33:25 osd2 kernel: [49531.320004] R10: 0000000000000000 R11:
0000000000000001 R12: 000000000f2cffff
May 27 14:33:25 osd2 kernel: [49531.320004] R13: 000000000f2c8000 R14:
ffff88011d0d0000 R15: ffff88011d0d3548
May 27 14:33:25 osd2 kernel: [49531.320004] FS:  00007f217f395700(0000)
GS:ffff880127d00000(0000) knlGS:0000000000000000
May 27 14:33:25 osd2 kernel: [49531.320004] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
May 27 14:33:25 osd2 kernel: [49531.320004] CR2: 00007f21660c0000 CR3:
000000011ff74000 CR4: 00000000000006e0
May 27 14:33:25 osd2 kernel: [49531.320004] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 27 14:33:25 osd2 kernel: [49531.320004] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 27 14:33:25 osd2 kernel: [49531.320004] Process cosd (pid: 5505, threadinfo
ffff880117d6e000, task ffff88011fad8000)
May 27 14:33:25 osd2 kernel: [49531.320004] Stack:
May 27 14:33:25 osd2 kernel: [49531.320004]  0000000000001e59 ffff88012747db20
ffff880117d6f9a8 000000000f2ced96
May 27 14:33:25 osd2 kernel: [49531.320004]  000000000f2ceb96 ffff88011e9d1108
ffff8800a47f8860 000000000f2cffff
May 27 14:33:25 osd2 kernel: [49531.320004]  00001e5917d6f9a8 000000000f2c8000
0000000000001e59 00008000ffffffff
May 27 14:33:25 osd2 kernel: [49531.320004] Call Trace:
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811d3c4c>]
ext3_new_blocks+0x40c/0x6b0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811d3f11>]
ext3_new_block+0x21/0x30
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811e798e>]
ext3_xattr_block_set+0x2ae/0x790
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811e86ba>]
ext3_xattr_set_handle+0x30a/0x4c0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811e88f5>]
ext3_xattr_set+0x85/0xe0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff81277053>] ?
security_inode_exec_permission+0x23/0x30
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811e8ae9>]
ext3_xattr_user_set+0x49/0x50
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811818e4>]
generic_setxattr+0x74/0x90
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811820c0>]
__vfs_setxattr_noperm+0x50/0x1a0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff8116adb8>] ?
inode_permission+0xa8/0xd0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811822cc>]
vfs_setxattr+0xbc/0xc0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff81182392>]
setxattr+0xc2/0x150
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff8114fec0>] ?
kmem_cache_free+0x20/0x110
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff8116ae33>] ?
putname+0x33/0x50
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff8116ef84>] ?
user_path_at+0x64/0xa0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff815d3493>] ?
schedule+0x3d3/0xa00
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff81099c7b>] ?
sys_futex+0x7b/0x180
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff811824b5>]
sys_setxattr+0x95/0xb0
May 27 14:33:25 osd2 kernel: [49531.320004]  [<ffffffff815ddec2>]
system_call_fastpath+0x16/0x1b
May 27 14:33:25 osd2 kernel: [49531.320004] Code: 48 8b 7d 18 41 83 cc ff 89 07
e9 59 ff ff ff 4d 63 ed 4c 01 6b 28 eb a1 48 81 c7 50 01 00 00 48 c7 c6 f0 fc 61
81 e8 a4 f1 ff ff <0f> 0b 66 90 55 48 89 e5 41 54 53 0f 1f 44 00 00 4c 8b 67 18
48
May 27 14:33:25 osd2 kernel: [49531.320004] RIP  [<ffffffff811d319c>]
ext3_try_to_allocate_with_rsv+0x62c/0x630
May 27 14:33:25 osd2 kernel: [49531.320004]  RSP <ffff880117d6f938>
May 27 14:33:25 osd2 kernel: [49531.790697] ---[ end trace d52659e715a28d90 ]---

WBR,
    Fyodor.

--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

