From: "George Spelvin" <linux@sciencehorizons.net>
Subject: kernel BUG at fs/ext4/inline.c:1950!
Date: 26 Apr 2017 04:16:51 -0400
Message-ID: <20170426081651.9253.qmail@ns.sciencehorizons.net>
Cc: linux@sciencehorizons.net
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:47469 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1169438AbdDZIXg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Apr 2017 04:23:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was cleaning up the last of the wreckage in lost+found from my previous
inline directory adventures, and ran into the following:

# ./#1625089
Segmentation fault
# dmesg | tail -40
[  711.658809] EXT4-fs (md3): mounted filesystem with writeback data mode. Opts: data=writeback,delalloc
[  741.694687] ------------[ cut here ]------------
[  741.694711] kernel BUG at fs/ext4/inline.c:1950!
[  741.694729] invalid opcode: 0000 [#1] SMP
[  741.694731] Modules linked in: nfsd lockd grace sunrpc ablk_helper x86_pkg_temp_thermal crc32_pclmul crc32c_intel via_velocity [last unloaded: twofish_common]
[  741.694742] CPU: 0 PID: 893 Comm: rmdir Not tainted 4.10.2-00128-gebfcca29-dirty #607
[  741.694745] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F7 03/19/2014
[  741.694750] task: ffff880403d3e400 task.stack: ffffc90007f66000
[  741.694755] RIP: 0010:ext4_inline_data_truncate+0x3d5/0x3f0
[  741.694758] RSP: 0018:ffffc90007f67ce0 EFLAGS: 00010286
[  741.694761] RAX: 0000000000000000 RBX: ffff880428aeb270 RCX: 0000021810000000
[  741.694765] RDX: 00000000ffffffc3 RSI: ffffc90007f67d00 RDI: ffff8803e469d440
[  741.694768] RBP: ffffc90007f67d88 R08: ffff880428bab618 R09: ffff8804261fc0a0
[  741.694771] R10: ffff88041061bc00 R11: 0000000000000000 R12: ffff8803e469d440
[  741.694775] R13: ffff8803e469d3b0 R14: ffff8803e469d3f0 R15: 0000000000000000
[  741.694778] FS:  0000000000000000(0000) GS:ffff88043fc00000(0063) knlGS:00000000f76da800
[  741.694782] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  741.694785] CR2: 00000000f75b2cd0 CR3: 00000004055ff000 CR4: 00000000001406f0
[  741.694788] Call Trace:
[  741.694793]  ext4_truncate+0x1ea/0x300
[  741.694797]  ext4_evict_inode+0x2c7/0x3d0
[  741.694801]  evict+0xc2/0x190
[  741.694803]  iput+0x162/0x1f0
[  741.694806]  dentry_unlink_inode+0xbd/0x160
[  741.694809]  d_delete+0x99/0xb0
[  741.694812]  vfs_rmdir+0xfc/0x120
[  741.694815]  do_rmdir+0x19e/0x1e0
[  741.694818]  SyS_rmdir+0x11/0x20
[  741.694821]  do_fast_syscall_32+0x87/0x160
[  741.694825]  entry_SYSENTER_compat+0x4c/0x5b
[  741.694827] RIP: 0023:0xf76ddaf9
[  741.694830] RSP: 002b:00000000fffad8dc EFLAGS: 00000292 ORIG_RAX: 0000000000000028
[  741.694833] RAX: ffffffffffffffda RBX: 00000000fffae31f RCX: 0000000000000000
[  741.694837] RDX: 00000000565d5000 RSI: 00000000565d0cd8 RDI: 00000000fffae31f
[  741.694840] RBP: 00000000fffad938 R08: 0000000000000000 R09: 0000000000000000
[  741.694843] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  741.694846] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  741.694850] Code: ff ff 89 c1 48 89 d7 48 c7 44 0a f8 00 00 00 00 8d 48 ff 31 c0 c1 e9 03 f3 48 ab e9 34 fe ff ff 41 bf f4 ff ff ff e9 3f fe ff ff <0f> 0b 89 c0 c7 02 00 00 00 00 c7 44 02 fc 00 00 00 00 e9 12 fe 
[  741.694872] RIP: ext4_inline_data_truncate+0x3d5/0x3f0 RSP: ffffc90007f67ce0
[  741.697776] ---[ end trace abf8638ef9df5a2a ]---

# debugfs /dev/md3
debugfs 1.43.4 (31-Jan-2017)
debugfs:  stat <1625089>
Inode: 1625089   Type: directory    Mode:  0775   Flags: 0x10000000
Generation: 927350643    Version: 0x00000000:00000004
User:  1000   Group:   161   Project:     0   Size: 132
File ACL: 1664090185    Directory ACL: 0
Links: 0   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x590051a9:3a00ef08 -- Wed Apr 26 03:52:09 2017
 atime: 0x56b9e2f8:b68a7658 -- Tue Feb  9 08:00:40 2016
 mtime: 0x56c1bc4b:a7765de8 -- Mon Feb 15 06:53:47 2016
crtime: 0x56ba9eb4:a51d90ac -- Tue Feb  9 21:21:40 2016
Size of extra inode fields: 32
Extended attributes:
  system.data (72)
Inode checksum: 0x4ea228db
Size of inline data: 132

I know the directory appeared empty before I tried to rmdir it.
Also, the file system had recently passed e2fsck 1.43.4 (31-Jan-2017).

Kernel is 4.10.2-00128-gebfcca29-dirty. which includes

ebfcca29 ext4: propagate error values from ext4_inline_data_truncate()
47cfbb61 ext4: avoid calling ext4_mark_inode_dirty() under unneeded semaphores
842ea5ea ext4: add debug_want_extra_isize mount option

Line 1950 is the "BUG_ON(is.s.not_found);"

Unfortunately, I have to keep working, and the inode did get unlinked
(although with a missing dtime), so fsck will clean it up on reboot.
