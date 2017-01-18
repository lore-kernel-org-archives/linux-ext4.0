From: "George Spelvin" <linux@sciencehorizons.net>
Subject: kernel BUG at fs/ext4/inline.c:1943!
Date: 18 Jan 2017 03:21:28 -0500
Message-ID: <20170118082128.2402.qmail@ns.sciencehorizons.net>
References: <20170112144657.p33nf3u3ev27ixjq@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@sciencehorizons.net, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:43385 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750830AbdARIsv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jan 2017 03:48:51 -0500
In-Reply-To: <20170112144657.p33nf3u3ev27ixjq@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was trying to rmdir an empty directory in lost+found that accumulated
during my recent problems.

EXT4-fs (md3): mounted filesystem with writeback data mode. Opts: data=writeback,delalloc

$ cd /mountpoint/lost+found
$ rmdir \#1625089/

------------[ cut here ]------------
kernel BUG at fs/ext4/inline.c:1943!
invalid opcode: 0000 [#1] SMP
Modules linked in: nfsd lockd grace sunrpc ablk_helper via_velocity x86_pkg_temp_thermal crc32_pclmul crc32c_intel [last unloaded: twofish_common]
CPU: 0 PID: 16879 Comm: rmdir Not tainted 4.10.0-rc3-00322-g1aa1df43-dirty #591
Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F7 03/19/2014
task: ffff88040e4cab00 task.stack: ffffc9000dd5c000
RIP: 0010:ext4_inline_data_truncate+0x3db/0x400
RSP: 0018:ffffc9000dd5dcd8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88042d287ea0 RCX: 0000021810000000
RDX: 00000000ffffffc3 RSI: ffffc9000dd5dcf8 RDI: ffff8801a41771f0
RBP: ffffc9000dd5dd80 R08: ffff88006123e9c0 R09: ffff8803fe3d60a0
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801a41771f0
R13: ffff8801a4177058 R14: ffff8801a41770f0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88042f200000(0063) knlGS:00000000f7787800
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f765fbe0 CR3: 0000000179a5e000 CR4: 00000000001406f0
Call Trace:
 ext4_truncate+0x1ea/0x300
 ext4_evict_inode+0x2c7/0x3d0
 evict+0xc0/0x190
 iput+0x14c/0x1e0
 dentry_unlink_inode+0xbe/0x160
 d_delete+0x9c/0xb0
 vfs_rmdir+0x102/0x130
 do_rmdir+0x1a3/0x1e0
 SyS_rmdir+0x11/0x20
 do_fast_syscall_32+0x94/0x210
 entry_SYSENTER_compat+0x51/0x60
RIP: 0023:0xf778aaf9
RSP: 002b:00000000ffda9e0c EFLAGS: 00000292 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00000000ffdab332 RCX: 0000000000000000
RDX: 00000000565f4000 RSI: 00000000565efb38 RDI: 00000000ffdab332
RBP: 00000000ffda9e68 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Code: ff ff 89 c1 48 89 d7 48 c7 44 0a f8 00 00 00 00 8d 48 ff 31 c0 c1 e9 03 f3 48 ab e9 31 fe ff ff 41 bf f4 ff ff ff e9 3c fe ff ff <0f> 0b 89 c0 c7 02 00 00 00 00 c7 44 02 fc 00 00 00 00 e9 0f fe 
RIP: ext4_inline_data_truncate+0x3db/0x400 RSP: ffffc9000dd5dcd8
---[ end trace caa17f858299cde5 ]---


That's the "BUG_ON(is.s.not_found);"

debugfs says the directory entry is gone, but I can:

debugfs:  stat <1625089>
Inode: 1625089   Type: directory    Mode:  0775   Flags: 0x10000000
Generation: 927350643    Version: 0x00000000:00000004
User:  1000   Group:   161   Project:     0   Size: 132
File ACL: 1664090185    Directory ACL: 0
Links: 0   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x587f2034:472c74ec -- Wed Jan 18 02:58:44 2017
 atime: 0x56b9e2f8:b68a7658 -- Tue Feb  9 08:00:40 2016
 mtime: 0x56c1bc4b:a7765de8 -- Mon Feb 15 06:53:47 2016
crtime: 0x56ba9eb4:a51d90ac -- Tue Feb  9 21:21:40 2016
Size of extra inode fields: 32
Extended attributes:
  system.data (72)
Inode checksum: 0xe2f12fc5
Size of inline data: 132
debugfs:  dump <1625089> /tmp/inode
$ xxd /tmp/inode
00000000: 0b00 0000 0000 0000 3800 0000 0000 0000  ........8.......
00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000040: 4800 3101 xxxx xxxx xxxx xxxx xxxx xxxx  H.1.xxxxxxxxxxxx
00000050: xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx  xxxxxxxxxxxxxxxx
00000060: xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx  xxxxxxxxxxxxxxxx
00000070: xx2e 7064 6600 0000 0000 0000 0000 0000  x.pdf...........
00000080: 0000 0000                                ....
debugfs:  ea_get -f /tmp/ea <1625089> system.data
$ xxd /tmp/ea
00000000: 0000 0000 4800 3101 xxxx xxxx xxxx xxxx  ....H.1.xxxxxxxx
00000010: xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx  xxxxxxxxxxxxxxxx
00000020: xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx  xxxxxxxxxxxxxxxx
00000030: xxxx xxxx xx2e 7064 6600 0000 0000 0000  xxxxx.pdf.......
00000040: 0000 0000 0000 0000                      ........
