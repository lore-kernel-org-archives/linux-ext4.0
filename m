From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: ext4 info leak in creation times in latest mainline
Date: Sun, 16 Feb 2014 16:52:37 +0100
Message-ID: <5300DEC5.2080908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Kalpak Shah <kalpak@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

There seems to be a bug in ext4 where the i_crtime of struct 
ext4_inode_info is not initialised, so (some) creation times contain 
essentially random values. Here's a report from kmemcheck:

[   92.402035] WARNING: kmemcheck: Caught 64-bit read from uninitialized 
memory (ffff8800168ab208)
[   92.403724] 
00000000000000000000000000000000000000000000000018b28a160088ffff
[   92.406378]  i i i i i i i i u u u u u u u u i i i i i i i i i i i i 
i i i i
[   92.408990]                  ^
[   92.409850] RIP: 0010:[<ffffffff8119d8b6>]  [<ffffffff8119d8b6>] 
ext4_mark_iloc_dirty+0x176/0x670
[   92.411749] RSP: 0018:ffff880016737c18  EFLAGS: 00010206
[   92.412547] RAX: 000000000000009c RBX: ffff880016737c80 RCX: 
0000000000000000
[   92.413603] RDX: 0000000000000000 RSI: ffff8800168aaf70 RDI: 
ffff8800168aaf20
[   92.414664] RBP: ffff880016737c68 R08: 0000080000010000 R09: 
ffff880017d11680
[   92.415732] R10: ffff8800168aaf20 R11: 0000000000000000 R12: 
ffff8800168611a0
[   92.416789] R13: ffff880017d11600 R14: ffff880016683800 R15: 
ffff8800168aafd0
[   92.417859] FS:  00007f3997461700(0000) GS:ffff880017a00000(0000) 
knlGS:0000000000000000
[   92.419051] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   92.419891] CR2: ffff880017404160 CR3: 0000000016351000 CR4: 
00000000000006f0
[   92.420946] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   92.422120] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 
0000000000000400
[   92.423371]  [<ffffffff8119dec1>] ext4_mark_inode_dirty+0x71/0x1b0
[   92.424858]  [<ffffffff811a0b64>] ext4_dirty_inode+0x44/0x70
[   92.425853]  [<ffffffff81148169>] __mark_inode_dirty+0x29/0x200
[   92.427432]  [<ffffffff8113ae79>] update_time+0x79/0xc0
[   92.428236]  [<ffffffff8113b09a>] touch_atime+0xfa/0x140
[   92.429105]  [<ffffffff810d6cee>] generic_file_aio_read+0x4ae/0x6b0
[   92.430076]  [<ffffffff81120d55>] do_sync_read+0x55/0x90
[   92.430874]  [<ffffffff81121d46>] vfs_read+0xa6/0x180
[   92.431648]  [<ffffffff81121fbd>] SyS_read+0x4d/0xa0

RIP here corresponds to the line:

     EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);

in ext4_do_update_inode(), in particular the

     (raw_inode)->xtime = cpu_to_le32((einode)->xtime.tv_sec);

line of EXT4_EINODE_SET_XTIME. As an aside, kmemcheck reports a 64-bit 
read, but that's just because gcc generates a 64-bit load followed by a 
32-bit store, so it essentially just discards the upper 32 bits:

ffffffff8119d8b6:       49 8b 87 38 02 00 00    mov    0x238(%r15),%rax
ffffffff8119d8bd:       41 89 85 90 00 00 00    mov    %eax,0x90(%r13)

A few of the weird crtimes I've observed (using debugfs):

crtime: 0x00000101:00000000 -- Thu Jan  1 00:04:17 1970
crtime: 0x00001000:00000000 -- Thu Jan  1 01:08:16 1970
crtime: 0x02020202:00000002 -- Mon Jan 25 21:13:38 1971 (looks like some 
kind of poison value?)
crtime: 0x03030303:00000003 -- Sun Aug  8 19:50:27 1971
crtime: 0x15406b80:00000000 -- Sun Apr 19 15:49:20 1981 (these look like 
lower 32 bits of stack addresses/kernel pointers)
crtime: 0x16be86a0:00000000 -- Wed Feb  3 11:50:56 1982
crtime: 0x2f0d5ac1:00000000 -- Fri Jan  6 14:59:13 1995

And enabling SLUB debugging removes any trace of a doubt:

crtime: 0x5a5a5a5a:00000002 -- Sat Jan 13 19:13:30 2018

I don't know if it's relevant, but the filesystem is actually ext3 
mounted using ext4. It's 100% reproducible for me, so I can test patches.


Vegard
