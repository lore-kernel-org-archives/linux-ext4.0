From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4.2 kernel trace when hot unplug a mounted USB/SATA/MMC devices
 with ext2/ext3/ext4 file system
Date: Thu, 13 Aug 2015 09:01:28 -0700
Message-ID: <20150813160128.GG10037@birch.djwong.org>
References: <CADaLNDk7NNqe=839ro7KnwpfRAOLO3evX=JL12bMZR8vm2xYMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	patches <patches-qTEPVZfXA3Y@public.gmane.org>
To: Duc Dang <dhdang-qTEPVZfXA3Y@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADaLNDk7NNqe=839ro7KnwpfRAOLO3evX=JL12bMZR8vm2xYMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 12, 2015 at 08:17:28PM -0700, Duc Dang wrote:
> Hi Theodore, Andreas, Jan, Andrew and All,
> 
> We are seeing kernel trace when we disconnect an USB/SATA/MMC devices
> that has its ext2/ext3/ext4 partition currently mounted. These traces
> are seen with kernel 4.2-rc5 on APM Arm64 X-Gene platforms. Similar
> issue also happens on an x86 machine (Lenovo T420s running Fedora Core
> 22 (Linux 4.1.x))

Sounds like this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=101011

--D

> 
> We also tested with xfs kernel and kernel complains with some error
> message but there is no trace:
> 
> usb 1-1: USB disconnect, device number 3
> XFS (sda1): Unmounting Filesystem
> XFS (sda1): metadata I/O error: block 0x1ddc12 ("xlog_iodone") error 19 numblks
> 64
> XFS (sda1): xfs_do_force_shutdown(0x2) called from line 1180 of file
> /projects/svdc/P4wsIPCSW/buildsw_shadowcat_2_03/shadowcat/linux/fs/xfs/xfs_log.c.
>  Return address = 0xffffffc0003aa8d8
> XFS (sda1): Log I/O Error Detected.  Shutting down filesystem
> XFS (sda1): Unable to update superblock counters. Freespace may not be correct
> on next mount.
> XFS (sda1): xfs_log_force: error -5 returned.
> XFS (sda1): Please umount the filesystem and rectify the problem(s)
> 
> Below are traces for each case. Do you aware of this issue and is
> there a fix for it?
> 
> CASE 1: SATA with ext2 partition:
> 
> EXT2-fs (sda1): previous I/O error to superblock detected
> 
> Unable to handle kernel paging request at virtual address 1ff256000
> pgd = ffffffc0e784b000
> [1ff256000] *pgd=0000000000000000, *pud=0000000000000000
> Internal error: Oops: 96000005 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 4 PID: 1484 Comm: umount Not tainted 4.1.0-xgene_sw_2.03.05-beta_rc_pm #1
> Hardware name: APM X-Gene Mustang board (DT)
> task: ffffffc1ed5d3840 ti: ffffffc0e79dc000 task.ti: ffffffc0e79dc000
> PC is at __percpu_counter_add+0x2c/0x10c
> LR is at account_page_dirtied+0x78/0x12c
> pc : [<ffffffc00043666c>] lr : [<ffffffc000147180>] pstate: 800001c5
> sp : ffffffc0e79dfc40
> x29: ffffffc0e79dfc40 x28: ffffffc0e79dc000
> x27: ffffffc000927000 x26: 0000000000000027
> x25: 000000000000011a x24: 0000000000000015
> x23: 0000000080000000 x22: 0000000000000140
> x21: ffffffc000d33000 x20: ffffffc1f6440fb8
> x19: ffffffbec7b3e500 x18: 0000000000000000
> x17: 0000007f8d95bfd0 x16: ffffffc0001dfad0
> x15: 003b9aca00000000 x14: 0ffffffffffffffe
> x13: 0000000000000020 x12: 0101010101010101
> x11: 0000000000000174 x10: 0000000000000006
> x9 : ffffffc1fff1e35c x8 : 746564206b636f6c
> x7 : ffffffc000d33618 x6 : 00000001ff256000
> x5 : ffffffc0e79dfc40 x4 : ffffffc0e79dc000
> x3 : 0000000000000000 x2 : 0000000000000020
> x1 : 0000000000000001 x0 : 00000001ff256000
> 
> Process umount (pid: 1484, stack limit = 0xffffffc0e79dc020)
> Stack: (0xffffffc0e79dfc40 to 0xffffffc0e79e0000)
> fc40: e79dfc70 ffffffc0 00147180 ffffffc0 c7b3e500 ffffffbe f6440f78 ffffffc1
> fc60: e79dfc70 ffffffc0 0014716c ffffffc0 e79dfcb0 ffffffc0 001ccd7c ffffffc0
> fc80: c7b3e500 ffffffbe f6b28f48 ffffffc1 f6b28f60 ffffffc1 e79dfca0 ffffffc0
> fca0: 00000000 00000000 f6b28f48 ffffffc1 e79dfd00 ffffffc0 001cdfd4 ffffffc0
> fcc0: c7b3e500 ffffffbe ecf94400 ffffffc1 ee6022d8 ffffffc0 00000000 00000000
> fce0: 80000000 00000000 00226674 ffffffc0 e79dfd20 ffffffc0 00000000 00000000
> fd00: e79dfd20 ffffffc0 0022ac84 ffffffc0 f6ff7000 ffffffc1 ecf94400 ffffffc1
> fd20: e79dfd50 ffffffc0 0022ad0c ffffffc0 f677e380 ffffffc1 ecf94400 ffffffc1
> fd40: f6ff7000 ffffffc1 ed5d3840 ffffffc1 e79dfd90 ffffffc0 001cb0c4 ffffffc0
> fd60: f6ff7000 ffffffc1 f6ff70a8 ffffffc1 00946080 ffffffc0 001b5ff0 ffffffc0
> fd80: f6ff7000 ffffffc1 00000000 00000000 e79dfdb0 ffffffc0 001a05e0 ffffffc0
> fda0: f6ff7000 ffffffc1 00000083 00000000 e79dfde0 ffffffc0 001a0958 ffffffc0
> fdc0: f6b28d00 ffffffc1 00000083 00000000 00db9000 ffffffc0 00000015 00000000
> fde0: e79dfe10 ffffffc0 001a0c68 ffffffc0 f6ff7000 ffffffc1 00d511e8 ffffffc0
> fe00: 00db9000 ffffffc0 00d511e8 ffffffc0 e79dfe30 ffffffc0 001a1168 ffffffc0
> fe20: f6ff7000 ffffffc1 00000000 00000000 e79dfe50 ffffffc0 001bcef0 ffffffc0
> fe40: f6c8b080 ffffffc1 00000015 00000000 e79dfe70 ffffffc0 001bcf94 ffffffc0
> fe60: ed5d4190 ffffffc1 90a791c8 0000007f e79dfe80 ffffffc0 000ce47c ffffffc0
> fe80: e79dfeb0 ffffffc0 00089800 ffffffc0 0000000c 00000000 79a5e4f0 00000055
> fea0: ffffffff ffffffff 90a791c8 0000007f dc5d82a0 0000007f 00085b54 ffffffc0
> fec0: 00000000 00000000 e79dfec0 ffffffc0 00000000 00000000 00000000 00000000
> fee0: 00000000 00000000 00000000 00000000 80000000 80808080 00000000 00000000
> ff00: 80808080 00000080 ff2f6172 fefefefe 00000027 00000000 00000004 00000000
> ff20: 01010101 01010101 00000030 00000000 00000006 00000000 6974616f 6e2c656d
> ff40: 00000000 00000000 0000578b 00000000 90a79180 0000007f 756f8ed0 00000055
> ff60: 00000000 00000000 79a5e4f0 00000055 79a5e4f0 00000055 00000002 00000000
> ff80: 00000002 00000000 79a5e550 00000055 00000000 00000000 dc5d8410 0000007f
> ffa0: 79a5e530 00000055 756f5df1 00000055 00000000 00000000 dc5d82a0 0000007f
> ffc0: 756a2ae0 00000055 dc5d8150 0000007f 90a791c8 0000007f 80000000 00000000
> ffe0: 79a5e530 00000055 00000027 00000000 00000000 00000000 00000000 00000000
> Call trace:
> [<ffffffc00043666c>] __percpu_counter_add+0x2c/0x10c
> [<ffffffc00014717c>] account_page_dirtied+0x74/0x12c
> [<ffffffc0001ccd78>] __set_page_dirty+0x48/0xd0
> [<ffffffc0001cdfd0>] mark_buffer_dirty+0x74/0xa8
> [<ffffffc00022ac80>] ext2_sync_super+0x98/0xbc
> [<ffffffc00022ad08>] ext2_sync_fs+0x64/0x7c
> [<ffffffc0001cb0c0>] sync_filesystem+0x50/0xb0
> [<ffffffc0001a05dc>] generic_shutdown_super+0x2c/0xd8
> [<ffffffc0001a0954>] kill_block_super+0x1c/0x70
> [<ffffffc0001a0c64>] deactivate_locked_super+0x54/0x84
> [<ffffffc0001a1164>] deactivate_super+0x8c/0x9c
> [<ffffffc0001bceec>] cleanup_mnt+0x38/0x84
> [<ffffffc0001bcf90>] __cleanup_mnt+0xc/0x18
> [<ffffffc0000ce478>] task_work_run+0x98/0xec
> [<ffffffc0000897fc>] do_notify_resume+0x54/0x68
> Code: 11000400 b9001880 f9401283 d538d080 (b8a36813)
> ---[ end trace 1cc4dbc7f8fabff6 ]---
> note: umount[1484] exited with preempt_count 2
> 
> 
> CASE 2: SATA with ext3 partition:
> 
> Unable to handle kernel paging request at virtual address 1ff223000
> pgd = ffffffc0e7a0b000
> [1ff223000] *pgd=0000000000000000, *pud=0000000000000000
> Internal error: Oops: 96000005 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 1 PID: 1481 Comm: umount Not tainted 4.1.0-xgene_sw_2.03.05-beta_rc_pm #1
> Hardware name: APM X-Gene Mustang board (DT)
> task: ffffffc1ec556540 ti: ffffffc0e7b8c000 task.ti: ffffffc0e7b8c000
> PC is at __percpu_counter_add+0x2c/0x10c
> LR is at account_page_dirtied+0x78/0x12c
> pc : [<ffffffc00043666c>] lr : [<ffffffc000147180>] pstate: 800001c5
> sp : ffffffc0e7b8fc80
> x29: ffffffc0e7b8fc80 x28: ffffffc0e7b8c000
> x27: ffffffc000927000 x26: 0000000000000027
> x25: 000000000000011a x24: 0000000000000015
> x23: 0000000080000000 x22: 0000000000000140
> x21: ffffffc000d33000 x20: ffffffc1f6100fb8
> x19: ffffffbec0102680 x18: 0000000000000001
> x17: 0000000000000007 x16: 000000000000000e
> x15: 0000000000000013 x14: 000000000000001a
> x13: 000000006234d2b5 x12: 00000000f4033c40
> x11: 0000000000000007 x10: 000000000000001f
> x9 : ffffffc0e7b8fc20 x8 : ffffffc1ec556ac0
> x7 : 0000000000000000 x6 : 00000001ff223000
> x5 : ffffffc0e7b8fc80 x4 : ffffffc0e7b8c000
> x3 : 0000000000000000 x2 : 0000000000000020
> x1 : 0000000000000001 x0 : 00000001ff223000
> 
> Process umount (pid: 1481, stack limit = 0xffffffc0e7b8c020)
> Stack: (0xffffffc0e7b8fc80 to 0xffffffc0e7b90000)
> fc80: e7b8fcb0 ffffffc0 00147180 ffffffc0 c0102680 ffffffbe f6100f78 ffffffc1
> fca0: e7b8fcb0 ffffffc0 0014716c ffffffc0 e7b8fcf0 ffffffc0 001ccd7c ffffffc0
> fcc0: c0102680 ffffffbe f6b38c08 ffffffc1 f6b38c20 ffffffc1 00000015 00000000
> fce0: 0000011a 00000000 f6b38c08 ffffffc1 e7b8fd40 ffffffc0 001cdfd4 ffffffc0
> fd00: c0102680 ffffffbe e79b2800 ffffffc0 f6ff5000 ffffffc1 ec556540 ffffffc1
> fd20: 80000000 00000000 f6ff4f98 ffffffc1 f6ff50a8 ffffffc1 00000000 00000000
> fd40: e7b8fd70 ffffffc0 0021f508 ffffffc0 0409a400 ffffffc0 e79b2800 ffffffc0
> fd60: e7b8fdb0 ffffffc0 001a05fc ffffffc0 e7b8fdb0 ffffffc0 001a061c ffffffc0
> fd80: f6ff5000 ffffffc1 f6ff50a8 ffffffc1 00945068 ffffffc0 ec556540 ffffffc1
> fda0: 80000000 00000000 00000015 00000000 e7b8fde0 ffffffc0 001a0958 ffffffc0
> fdc0: f6b389c0 ffffffc1 00000083 00000000 00db9000 ffffffc0 00000015 00000000
> fde0: e7b8fe10 ffffffc0 001a0c68 ffffffc0 f6ff5000 ffffffc1 00d511a8 ffffffc0
> fe00: 00db9000 ffffffc0 00d511a8 ffffffc0 e7b8fe30 ffffffc0 001a1168 ffffffc0
> fe20: f6ff5000 ffffffc1 00000000 00000000 e7b8fe50 ffffffc0 001bcef0 ffffffc0
> fe40: f6484480 ffffffc1 00000015 00000000 e7b8fe70 ffffffc0 001bcf94 ffffffc0
> fe60: ec556e90 ffffffc1 a5a711c8 0000007f e7b8fe80 ffffffc0 000ce47c ffffffc0
> fe80: e7b8feb0 ffffffc0 00089800 ffffffc0 0000000c 00000000 63b9a4f0 00000055
> fea0: ffffffff ffffffff a5a711c8 0000007f c8834260 0000007f 00085b54 ffffffc0
> fec0: 00000000 00000000 e7b8fec0 ffffffc0 00000000 00000000 00000000 00000000
> fee0: 00000000 00000000 00000000 00000000 80000000 80808080 00000000 00000000
> ff00: 80808080 00000080 ff2f6172 fefefefe 00000027 00000000 00000004 00000000
> ff20: 01010101 01010101 00000030 00000000 00000006 00000000 756e6974 61622c65
> ff40: 00000000 00000000 0000578b 00000000 a5a71180 0000007f 58bd4ed0 00000055
> ff60: 00000000 00000000 63b9a4f0 00000055 63b9a4f0 00000055 00000002 00000000
> ff80: 00000002 00000000 63b9a550 00000055 00000000 00000000 c88343d0 0000007f
> ffa0: 63b9a530 00000055 58bd1df1 00000055 00000000 00000000 c8834260 0000007f
> ffc0: 58b7eae0 00000055 c8834110 0000007f a5a711c8 0000007f 80000000 00000000
> ffe0: 63b9a530 00000055 00000027 00000000 00000000 00000000 00000000 00000000
> Call trace:
> [<ffffffc00043666c>] __percpu_counter_add+0x2c/0x10c
> [<ffffffc00014717c>] account_page_dirtied+0x74/0x12c
> [<ffffffc0001ccd78>] __set_page_dirty+0x48/0xd0
> [<ffffffc0001cdfd0>] mark_buffer_dirty+0x74/0xa8
> [<ffffffc00021f504>] ext3_put_super+0x1ec/0x250
> [<ffffffc0001a0618>] generic_shutdown_super+0x68/0xd8
> [<ffffffc0001a0954>] kill_block_super+0x1c/0x70
> [<ffffffc0001a0c64>] deactivate_locked_super+0x54/0x84
> [<ffffffc0001a1164>] deactivate_super+0x8c/0x9c
> [<ffffffc0001bceec>] cleanup_mnt+0x38/0x84
> [<ffffffc0001bcf90>] __cleanup_mnt+0xc/0x18
> [<ffffffc0000ce478>] task_work_run+0x98/0xec
> [<ffffffc0000897fc>] do_notify_resume+0x54/0x68
> Code: 11000400 b9001880 f9401283 d538d080 (b8a36813)
> ---[ end trace 2ca8304c40f82d27 ]---
> note: umount[1481] exited with preempt_count 2
> 
> [root@dhcp-10-38-7-195 ~]#
> 
> CASE 3: SATA with ext4 partition:
> 
> Unable to handle kernel paging request at virtual address 1ff234000
> pgd = ffffffc0df2de000
> [1ff234000] *pgd=0000000000000000, *pud=0000000000000000
> Internal error: Oops: 96000005 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 2 PID: 1427 Comm: umount Not tainted 4.1.0-xgene_sw_2.03.05-beta_rc_pm #1
> Hardware name: APM X-Gene Mustang board (DT)
> task: ffffffc0e7bdda00 ti: ffffffc0e4198000 task.ti: ffffffc0e4198000
> PC is at __percpu_counter_add+0x2c/0x10c
> LR is at account_page_dirtied+0x78/0x12c
> pc : [<ffffffc00043666c>] lr : [<ffffffc000147180>] pstate: 800001c5
> sp : ffffffc0e419bba0
> x29: ffffffc0e419bba0 x28: ffffffc0e4198000
> x27: ffffffc000d33718 x26: ffffffc1f6ff7000
> x25: fffffffffffbd6a8 x24: 7ffffffffffffd9c
> x23: 0000000000000001 x22: 0000000000000140
> x21: ffffffc000d33000 x20: ffffffc1ed660fb8
> x19: ffffffbec39e6440 x18: 0000000000000001
> x17: 0000000000000007 x16: 000000000000000e
> x15: 0000000000000013 x14: 000000000000001a
> x13: 00000000c6edf8a0 x12: 0000000009ffffff
> x11: 0000000000000000 x10: 7f7f7f7f7f7f7f7f
> x9 : 0000000000000000 x8 : 0000000000000001
> x7 : 0000000000000000 x6 : 00000001ff234000
> x5 : ffffffc0e419bba0 x4 : ffffffc0e4198000
> x3 : 0000000000000000 x2 : 0000000000000020
> x1 : 0000000000000001 x0 : 00000001ff234000
> 
> Process umount (pid: 1427, stack limit = 0xffffffc0e4198020)
> Stack: (0xffffffc0e419bba0 to 0xffffffc0e419c000)
> bba0: e419bbd0 ffffffc0 00147180 ffffffc0 c39e6440 ffffffbe ed660f78 ffffffc1
> bbc0: e419bbd0 ffffffc0 0014716c ffffffc0 e419bc10 ffffffc0 001ccd7c ffffffc0
> bbe0: c39e6440 ffffffbe ee670248 ffffffc0 ee670260 ffffffc0 00000027 00000000
> bc00: e419bc50 ffffffc0 ee670248 ffffffc0 e419bc60 ffffffc0 001cdfd4 ffffffc0
> bc20: c39e6440 ffffffbe 00d33000 ffffffc0 e7142340 ffffffc1 e7991400 ffffffc0
> bc40: 00000001 00000000 002456c4 ffffffc0 e419bc80 ffffffc0 00000000 00000000
> bc60: e419bc80 ffffffc0 002456e0 ffffffc0 00d33628 ffffffc0 00d33000 ffffffc0
> bc80: e419bce0 ffffffc0 00245f24 ffffffc0 f6ff7000 ffffffc1 000002fd 00000000
> bca0: 00948000 ffffffc0 00bc9828 ffffffc0 80000000 00000000 00000015 00000000
> bcc0: 0000011a 00000000 00000027 00000000 00927000 ffffffc0 e419bd60 ffffffc0
> bce0: e419bd70 ffffffc0 002465d8 ffffffc0 f6ff6800 ffffffc1 e7991400 ffffffc0
> bd00: f6ff7000 ffffffc1 e7bdda00 ffffffc0 f6ff6800 ffffffc1 e7991400 ffffffc0
> bd20: f6ff7000 ffffffc1 e7bdda00 ffffffc0 80000000 00000000 000ca368 ffffffc0
> bd40: e419bd70 ffffffc0 00000000 ffffffc0 00000000 00000000 40000000 00000000
> bd60: f6c972a0 ffffffc1 00000000 00000000 e419bdb0 ffffffc0 001a061c ffffffc0
> bd80: f6ff7000 ffffffc1 f6ff70a8 ffffffc1 00948170 ffffffc0 e7bdda00 ffffffc0
> bda0: 80000000 00000000 00000015 00000000 e419bde0 ffffffc0 001a0958 ffffffc0
> bdc0: ee670000 ffffffc0 00000083 00000000 00db9000 ffffffc0 00000015 00000000
> bde0: e419be10 ffffffc0 001a0c68 ffffffc0 f6ff7000 ffffffc1 00d51260 ffffffc0
> be00: 00db9000 ffffffc0 00d51260 ffffffc0 e419be30 ffffffc0 001a1168 ffffffc0
> be20: f6ff7000 ffffffc1 00000000 00000000 e419be50 ffffffc0 001bcef0 ffffffc0
> be40: f6c8b080 ffffffc1 00000015 00000000 e419be70 ffffffc0 001bcf94 ffffffc0
> be60: e7bde350 ffffffc0 917b41c8 0000007f e419be80 ffffffc0 000ce47c ffffffc0
> be80: e419beb0 ffffffc0 00089800 ffffffc0 00000004 00000000 829b3490 00000055
> bea0: ffffffff ffffffff 917b41c8 0000007f c0a37b80 0000007f 00085b54 ffffffc0
> bec0: 00000000 00000000 e419bec0 ffffffc0 00000000 00000000 00000000 00000000
> bee0: 00000000 00000000 00000000 00000000 80000000 80808080 00000000 00000000
> bf00: 80808080 00000080 ff2f6172 fefefefe 00000027 00000000 00000004 00000000
> bf20: 01010101 01010101 00000030 00000000 00000006 00000000 39393d73 38323232
> bf40: 00000000 00000000 0000578b 00000000 917b4180 0000007f 6ef9aed0 00000055
> bf60: 00000000 00000000 829b3490 00000055 829b3490 00000055 00000002 00000000
> bf80: 00000002 00000000 829b34f0 00000055 00000000 00000000 c0a37cf0 0000007f
> bfa0: 829b34d0 00000055 6ef97df1 00000055 00000000 00000000 c0a37b80 0000007f
> bfc0: 6ef44ae0 00000055 c0a37a30 0000007f 917b41c8 0000007f 80000000 00000000
> bfe0: 829b34d0 00000055 00000027 00000000 00000000 00000000 00000000 00000000
> Call trace:
> [<ffffffc00043666c>] __percpu_counter_add+0x2c/0x10c
> [<ffffffc00014717c>] account_page_dirtied+0x74/0x12c
> [<ffffffc0001ccd78>] __set_page_dirty+0x48/0xd0
> [<ffffffc0001cdfd0>] mark_buffer_dirty+0x74/0xa8
> [<ffffffc0002456dc>] ext4_commit_super+0x130/0x1f8
> [<ffffffc000245f20>] __ext4_abort+0x3c/0x13c
> [<ffffffc0002465d4>] ext4_put_super+0x278/0x2f4
> [<ffffffc0001a0618>] generic_shutdown_super+0x68/0xd8
> [<ffffffc0001a0954>] kill_block_super+0x1c/0x70
> [<ffffffc0001a0c64>] deactivate_locked_super+0x54/0x84
> [<ffffffc0001a1164>] deactivate_super+0x8c/0x9c
> [<ffffffc0001bceec>] cleanup_mnt+0x38/0x84
> [<ffffffc0001bcf90>] __cleanup_mnt+0xc/0x18
> [<ffffffc0000ce478>] task_work_run+0x98/0xec
> [<ffffffc0000897fc>] do_notify_resume+0x54/0x68
> Code: 11000400 b9001880 f9401283 d538d080 (b8a36813)
> ---[ end trace 3ae5dc2cd97a2315 ]---
> note: umount[1427] exited with preempt_count 2
> 
> CASE 4: MMC with ext4 partition
> 
> [root@dhcp-10-38-7-195 ~]# mmc0: card 0002 removed
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1461 at
> /projects/svdc/P4wsIPCSW/buildsw_shadowcat_2_03/shadowcat/linux/fs/block_dev.c:56
> __blkdev_put+0xe4/0x210()
> Modules linked in:
> CPU: 0 PID: 1461 Comm: umount Not tainted 4.1.0-xgene_sw_2.03.05-beta_rc_pm #1
> Hardware name: APM X-Gene Mustang board (DT)
> Call trace:
> [<ffffffc000089ab8>] dump_backtrace+0x0/0x11c
> [<ffffffc000089be4>] show_stack+0x10/0x1c
> [<ffffffc000917560>] dump_stack+0x84/0xc8
> [<ffffffc0000b4f24>] warn_slowpath_common+0x90/0xc8
> [<ffffffc0000b5020>] warn_slowpath_null+0x14/0x20
> [<ffffffc0001d3360>] __blkdev_put+0xe0/0x210
> [<ffffffc0001d3c78>] blkdev_put+0x4c/0x158
> [<ffffffc0001a096c>] kill_block_super+0x34/0x70
> [<ffffffc0001a0c64>] deactivate_locked_super+0x54/0x84
> [<ffffffc0001a1164>] deactivate_super+0x8c/0x9c
> [<ffffffc0001bceec>] cleanup_mnt+0x38/0x84
> [<ffffffc0001bcf90>] __cleanup_mnt+0xc/0x18
> [<ffffffc0000ce478>] task_work_run+0x98/0xec
> [<ffffffc0000897fc>] do_notify_resume+0x54/0x68
> ---[ end trace 52ed61a627c95f4b ]---
> random: nonblocking pool is initialized
> 
> USB with ext4 partition:
> 
> [root@dhcp-10-38-7-195 ~]# usb 1-1.1: USB disconnect, device number 3
> sd 4:0:0:0: [sda] UNKNOWN(0x2003) Result: hostbyte=0x01 driverbyte=0x00
> sd 4:0:0:0: [sda] CDB: opcode=0x2a 2a 00 00 00 3f f8 00 00 f0 00
> blk_update_request: I/O error, dev sda, sector 16376
> Aborting journal on device sda1-8.
> JBD2: Error -5 detected when updating journal superblock for sda1-8.
> Unable to handle kernel paging request at virtual address 1ff267000
> pgd = ffffffc1ed246000
> [1ff267000] *pgd=0000000000000000, *pud=0000000000000000
> Internal error: Oops: 96000005 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 5 PID: 1470 Comm: umount Not tainted 4.1.0-xgene_sw_2.03.05-beta_rc_pm #1
> Hardware name: APM X-Gene Mustang board (DT)
> task: ffffffc0e7c56540 ti: ffffffc0e7b24000 task.ti: ffffffc0e7b24000
> PC is at __percpu_counter_add+0x2c/0x10c
> LR is at account_page_dirtied+0x78/0x12c
> pc : [<ffffffc00043666c>] lr : [<ffffffc000147180>] pstate: 800001c5
> sp : ffffffc0e7b27ba0
> x29: ffffffc0e7b27ba0 x28: ffffffc0e7b24000
> x27: ffffffc000d33718 x26: ffffffc1ed1d1000
> x25: 0000000000000000 x24: 000000000000825d
> x23: 0000000000000001 x22: 0000000000000140
> x21: ffffffc000d33000 x20: ffffffc1ed2581b8
> x19: ffffffbec7b206c0 x18: 0000000000000001
> x17: 0000000000000007 x16: 000000000000000e
> x15: 0000000000000013 x14: 000000000000001a
> x13: 00000000a3e2cfc2 x12: 00000000277fffff
> x11: 0000000000000000 x10: 7f7f7f7f7f7f7f7f
> x9 : 0000000000000000 x8 : 0000000000000001
> x7 : 0000000000000000 x6 : 00000001ff267000
> x5 : ffffffc0e7b27ba0 x4 : ffffffc0e7b24000
> x3 : 0000000000000000 x2 : 0000000000000020
> x1 : 0000000000000001 x0 : 00000001ff267000
> 
> Process umount (pid: 1470, stack limit = 0xffffffc0e7b24020)
> Stack: (0xffffffc0e7b27ba0 to 0xffffffc0e7b28000)
> 7ba0: e7b27bd0 ffffffc0 00147180 ffffffc0 c7b206c0 ffffffbe ed258178 ffffffc1
> 7bc0: e7b27bd0 ffffffc0 0014716c ffffffc0 e7b27c10 ffffffc0 001ccd7c ffffffc0
> 7be0: c7b206c0 ffffffbe f6a69288 ffffffc1 f6a692a0 ffffffc1 00000027 00000000
> 7c00: e7b27c50 ffffffc0 f6a69288 ffffffc1 e7b27c60 ffffffc0 001cdfd4 ffffffc0
> 7c20: c7b206c0 ffffffbe 00d33000 ffffffc0 ee672340 ffffffc0 ec81b400 ffffffc1
> 7c40: 00000001 00000000 002456c4 ffffffc0 e7b27c80 ffffffc0 00000000 00000000
> 7c60: e7b27c80 ffffffc0 002456e0 ffffffc0 00d33628 ffffffc0 00d33000 ffffffc0
> 7c80: e7b27ce0 ffffffc0 00245f24 ffffffc0 ed1d1000 ffffffc1 000002fd 00000000
> 7ca0: 00948000 ffffffc0 00bc9828 ffffffc0 80000000 00000000 00000015 00000000
> 7cc0: 0000011a 00000000 00000027 00000000 00927000 ffffffc0 e7b27d60 ffffffc0
> 7ce0: e7b27d70 ffffffc0 002465d8 ffffffc0 ed1d5800 ffffffc1 ec81b400 ffffffc1
> 7d00: ed1d1000 ffffffc1 e7c56540 ffffffc0 ed1d5800 ffffffc1 ec81b400 ffffffc1
> 7d20: ed1d1000 ffffffc1 e7c56540 ffffffc0 80000000 00000000 000ca368 ffffffc0
> 7d40: e7b27d70 ffffffc0 00000000 ffffffc0 00000000 00000000 40000000 00000000
> 7d60: f6c972a0 ffffffc1 00000000 00000000 e7b27db0 ffffffc0 001a061c ffffffc0
> 7d80: ed1d1000 ffffffc1 ed1d10a8 ffffffc1 00948170 ffffffc0 e7c56540 ffffffc0
> 7da0: 80000000 00000000 00000015 00000000 e7b27de0 ffffffc0 001a0958 ffffffc0
> 7dc0: f6a69040 ffffffc1 00000083 00000000 00db9000 ffffffc0 00000015 00000000
> 7de0: e7b27e10 ffffffc0 001a0c68 ffffffc0 ed1d1000 ffffffc1 00d51260 ffffffc0
> 7e00: 00db9000 ffffffc0 00d51260 ffffffc0 e7b27e30 ffffffc0 001a1168 ffffffc0
> 7e20: ed1d1000 ffffffc1 00000000 00000000 e7b27e50 ffffffc0 001bcef0 ffffffc0
> 7e40: ed0aed80 ffffffc1 00000015 00000000 e7b27e70 ffffffc0 001bcf94 ffffffc0
> 7e60: e7c56e90 ffffffc0 7f41c1c8 0000007f e7b27e80 ffffffc0 000ce47c ffffffc0
> 7e80: e7b27eb0 ffffffc0 00089800 ffffffc0 00000004 00000000 aca13490 00000055
> 7ea0: ffffffff ffffffff 7f41c1c8 0000007f f88d2650 0000007f 00085b54 ffffffc0
> 7ec0: 00000000 00000000 e7b27ec0 ffffffc0 00000000 00000000 00000000 00000000
> 7ee0: 00000000 00000000 00000000 00000000 80000000 80808080 00000000 00000000
> 7f00: 80808080 00000080 ff2f6172 fefefefe 00000027 00000000 00000004 00000000
> 7f20: 01010101 01010101 00000030 00000000 00000006 00000000 74617269 2c656d69
> 7f40: 00000000 00000000 0000578b 00000000 7f41c180 0000007f 9527ced0 00000055
> 7f60: 00000000 00000000 aca13490 00000055 aca13490 00000055 00000002 00000000
> 7f80: 00000002 00000000 aca134f0 00000055 00000000 00000000 f88d27c0 0000007f
> 7fa0: aca134d0 00000055 95279df1 00000055 00000000 00000000 f88d2650 0000007f
> 7fc0: 95226ae0 00000055 f88d2500 0000007f 7f41c1c8 0000007f 80000000 00000000
> 7fe0: aca134d0 00000055 00000027 00000000 00000000 00000000 00000000 00000000
> Call trace:
> [<ffffffc00043666c>] __percpu_counter_add+0x2c/0x10c
> [<ffffffc00014717c>] account_page_dirtied+0x74/0x12c
> [<ffffffc0001ccd78>] __set_page_dirty+0x48/0xd0
> [<ffffffc0001cdfd0>] mark_buffer_dirty+0x74/0xa8
> [<ffffffc0002456dc>] ext4_commit_super+0x130/0x1f8
> [<ffffffc000245f20>] __ext4_abort+0x3c/0x13c
> [<ffffffc0002465d4>] ext4_put_super+0x278/0x2f4
> [<ffffffc0001a0618>] generic_shutdown_super+0x68/0xd8
> [<ffffffc0001a0954>] kill_block_super+0x1c/0x70
> [<ffffffc0001a0c64>] deactivate_locked_super+0x54/0x84
> [<ffffffc0001a1164>] deactivate_super+0x8c/0x9c
> [<ffffffc0001bceec>] cleanup_mnt+0x38/0x84
> [<ffffffc0001bcf90>] __cleanup_mnt+0xc/0x18
> [<ffffffc0000ce478>] task_work_run+0x98/0xec
> [<ffffffc0000897fc>] do_notify_resume+0x54/0x68
> Code: 11000400 b9001880 f9401283 d538d080 (b8a36813)
> ---[ end trace 3db0dd3586537f6d ]---
> note: umount[1470] exited with preempt_count 2
> 
> CASE 5: Trace on x86 Lenovo T420 machine running Fedora core 22 (Kernel 4.1.x)
> [<ffffffc0000899e4>] dump_backtrace+0x0/0x11c
> [<ffffffc000089b10>]show_stack+0x10/0x1c
> [<ffffffc000573614>] dump_stack+0x80/0xc4
> [<ffffffc0000b1664>] warn_slowpath_common+0x90/0xc8
> [<ffffffc0000b1760>] warn_slowpath_null+0x14/0x20
> [<ffffffc0001ca500>] __blkdev_put+0xe0/0x210
> [<ffffffc0001cae18>] blkdev_put+0x4c/0x158
> [<ffffffc00019853c>] kill_block_super+0x34/0x70
> [<ffffffc000198838>] deactivate_locked_super+0x54/0x84
> [<ffffffc000198d38>] deactivate_super+0x8c/0x9c
> [<ffffffc0001b46d4>] cleanup_mnt+0x38/0x84
> [<ffffffc0001b4778>] __cleanup_mnt+0xc/0x18
> [<ffffffc0000ca4b0>] task_work_run+0x94/0xe8
> [<ffffffc000089728>] do_notify_resume+0x54/0x68
> ---[ end trace 1fa355ac70316ea2 ]---
> 
> 
> -- 
> Regards,
> Duc Dang.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
