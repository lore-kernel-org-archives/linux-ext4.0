From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 104571] New: ext4_mb_generate_buddy block bitmap and bg
 descriptor inconsistent
Date: Tue, 15 Sep 2015 08:10:58 +0000
Message-ID: <bug-104571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48077 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbbIOILD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Sep 2015 04:11:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2912F2064E
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2015 08:11:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D7562205FA
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2015 08:10:59 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=104571

            Bug ID: 104571
           Summary: ext4_mb_generate_buddy block bitmap and bg descriptor
                    inconsistent
           Product: File System
           Version: 2.5
    Kernel Version: 3.19.8-ckt4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: linux-ext4@freshdot.net
        Regression: No

This bug report is about ext4 metadata corruption on large (>=10TB) ext4
volumes.
This was also reported in 2014 [
http://marc.info/?l=linux-ext4&m=139878494527370&w=2 ]

I'm getting sporadic FS errors like this one:
(More of these i've pasted at https://8n1.org/10745/cc34)

|  EXT4-fs error (device vdb): ext4_mb_generate_buddy:757:
|   group 79842, block bitmap and bg descriptor inconsistent: 10073 vs 10071
|   free clusters
| Aborting journal on device vdb-8.

An e2fsck run then shows:
| Pass 5: Checking group summary information
| Block bitmap differences:  +(2616281446--2616281447)
| Free blocks count wrong (170942497, counted=129906218).
| Free inodes count wrong (670863012, counted=670860975).

I've patched my kernel with WARN_ON(1); inserted in tactical places and caught
one such situation:

| EXT4-fs (vdb): pa ffff880016544888: logic 982168, phys. 2469410748, len 104
| EXT4-fs error (device vdb): ext4_mb_release_inode_pa:3773: group 75360, free
38, pa_free 36
| Aborting journal on device vdb-8.
| EXT4-fs (vdb): Remounting filesystem read-only
| ------------[ cut here ]------------
| WARNING: CPU: 1 PID: 1706 at fs/ext4/mballoc.c:3774
ext4_mb_release_inode_pa.isra.27+0x1cb/0x2c0()
| Modules linked in: nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter xt_tcpudp
ip6_tables
|     nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter
ip_tables
|     x_tables cirrus ttm drm_kms_helper drm kvm_intel kvm ppdev syscopyarea
sysfillrect
|     8250_fintek serio_raw i2c_piix4 sysimgblt pvpanic parport_pc mac_hid nfsd
auth_rpcgss nfs_acl
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
| EXT4-fs (vdb): ext4_writepages: jbd2_start: 9223372036854775751 pages, ino
84149503; err -30

After this, the system started logging a lot of this same message:
| EXT4-fs error (device vdb): ext4_find_extent:900: inode #84149503: comm
deluged: 
|    pblk 225181822 bad header/extent: invalid magic - magic 53fd, entries
37907,
|    max 27407(0), depth 50401(0)

Ran e2fsck and got:
| Pass 5: Checking group summary information
| Block bitmap differences:   +(1431556444--1431556445)
+(2469410748-2469410749)
| Free blocks count wrong (134030133, counted=57970467).
| Free inodes count wrong (670746893, counted=670746452).

Which is usually the same output for fsck in these situations.

This server is a QEMU KVM virtual machine running on Intel x64 hardware.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
