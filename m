From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: ext4 metadata corruption bug bites again
Date: Mon, 14 Sep 2015 10:05:52 +0200
Message-ID: <20150914080552.GE1883@dot.dmz.freshdot.net>
References: <20150821094534.GD20572@dot.dmz.freshdot.net>
 <20150824131406.GE20572@dot.dmz.freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:51833 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbINIWS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Sep 2015 04:22:18 -0400
Content-Disposition: inline
In-Reply-To: <20150824131406.GE20572@dot.dmz.freshdot.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quoting Sander Smeenk (ssmeenk@freshdot.net):

> I'm now running 3.19.8-ckt4 with WARN_ON(1); inserted in the above
> mentioned error situations.


And today the system went RO again. Now i have the WARN_ON(1) output:
| EXT4-fs (vdb): pa ffff880016544888: logic 982168, phys. 2469410748, len 104
| EXT4-fs error (device vdb): ext4_mb_release_inode_pa:3773: group 75360, free 38, pa_free 36
| Aborting journal on device vdb-8.
| EXT4-fs (vdb): Remounting filesystem read-only
| ------------[ cut here ]------------
| WARNING: CPU: 1 PID: 1706 at fs/ext4/mballoc.c:3774 ext4_mb_release_inode_pa.isra.27+0x1cb/0x2c0()
| Modules linked in: nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter xt_tcpudp ip6_tables
|     nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables
|     x_tables cirrus ttm drm_kms_helper drm kvm_intel kvm ppdev syscopyarea sysfillrect
|     8250_fintek serio_raw i2c_piix4 sysimgblt pvpanic parport_pc mac_hid nfsd auth_rpcgss nfs_acl
|     lockd grace sunrpc lp parport autofs4 psmouse floppy pata_acpi
| CPU: 1 PID: 1706 Comm: deluged Not tainted 3.19.8-ckt4 #1
| Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
|  ffffffff81ab4fef ffff8800da1bb978 ffffffff817c3760 0000000000000007
|  0000000000000000 ffff8800da1bb9b8 ffffffff8107696a ffff8800da1bb9a8
|  0000000000000026 0000000000003825 0000000000003824 ffff880016544888
| Call Trace:
|  [<ffffffff817c3760>] dump_stack+0x45/0x57
|  [<ffffffff8107696a>] warn_slowpath_common+0x8a/0xc0
|  [<ffffffff81076a5a>] warn_slowpath_null+0x1a/0x20
|  [<ffffffff812b01bb>] ext4_mb_release_inode_pa.isra.27+0x1cb/0x2c0
|  [<ffffffff812739df>] ? ext4_read_block_bitmap_nowait+0x26f/0x5f0
|  [<ffffffff812b3c6a>] ext4_discard_preallocations+0x30a/0x490
|  [<ffffffff8127b578>] ext4_da_update_reserve_space+0x178/0x1b0
|  [<ffffffff812a9129>] ext4_ext_map_blocks+0xcd9/0xe50
|  [<ffffffff8127b6d9>] ext4_map_blocks+0x129/0x570
|  [<ffffffff8127e89d>] ? ext4_writepages+0x35d/0xca0
|  [<ffffffff812ab3a9>] ? __ext4_journal_start_sb+0x69/0xe0
|  [<ffffffff8127eac2>] ext4_writepages+0x582/0xca0
|  [<ffffffff81187a4e>] do_writepages+0x1e/0x30
|  [<ffffffff8117bbe9>] __filemap_fdatawrite_range+0x59/0x60
|  [<ffffffff8117bc4c>] filemap_write_and_wait+0x2c/0x60
|  [<ffffffff8120903d>] do_vfs_ioctl+0x3fd/0x4e0
|  [<ffffffff812091a1>] SyS_ioctl+0x81/0xa0
|  [<ffffffff817ca84d>] system_call_fastpath+0x16/0x1b
| ---[ end trace c7de4d0d78cb95b6 ]---
| EXT4-fs error (device vdb) in ext4_writepages:2412: IO failure
| EXT4-fs (vdb): ext4_writepages: jbd2_start: 9223372036854775751 pages, ino 84149503; err -30


After this, the system started logging:
| EXT4-fs error (device vdb): ext4_find_extent:900: inode #84149503: comm deluged: 
|    pblk 225181822 bad header/extent: invalid magic - magic 53fd, entries 37907, max 27407(0), depth 50401(0)


Ran e2fsck and got:
| Pass 5: Checking group summary information
| Block bitmap differences:   +(1431556444--1431556445) +(2469410748-2469410749)
| Free blocks count wrong (134030133, counted=57970467).
| Free inodes count wrong (670746893, counted=670746452).


All fixed and system is running again.


HTH,
-Sander.
-- 
| Why does your nose run, and your feet smell?
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
