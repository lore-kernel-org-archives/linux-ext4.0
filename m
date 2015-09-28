From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 104571] ext4_mb_generate_buddy block bitmap and bg descriptor
 inconsistent
Date: Mon, 28 Sep 2015 08:04:48 +0000
Message-ID: <bug-104571-13602-WqohDu3A4u@https.bugzilla.kernel.org/>
References: <bug-104571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38761 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469AbbI1IEv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 04:04:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 88AB6206D6
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 08:04:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0763E206CD
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 08:04:49 +0000 (UTC)
In-Reply-To: <bug-104571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=104571

--- Comment #1 from Sander Smeenk <linux-ext4@freshdot.net> ---
Hit by this bug again:

| EXT4-fs error (device vdb): ext4_mb_generate_buddy:757: group 76916,
|    block bitmap and bg descriptor inconsistent: 959 vs 957 free
|    clusters
| Aborting journal on device vdb-8.
| EXT4-fs (vdb): Remounting filesystem read-only
| ------------[ cut here ]------------
| WARNING: CPU: 0 PID: 5000 at fs/ext4/mballoc.c:758
|    ext4_mb_generate_buddy+0x1fa/0x340()
| Modules linked in: btrfs xor raid6_pq ufs qnx4 hfsplus hfs minix ntfs
|    msdos jfs xfs libcrc32c xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
|    ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
|    nf_conntrack iptable_filter ip_tables x_tables cirrus ttm drm_kms_helper
|    drm kvm_intel kvm ppdev syscopyarea sysfillrect serio_raw pvpanic
|    sysimgblt 8250_fintek parport_pc i2c_piix4 mac_hid nfsd auth_rpcgss
|    nfs_acl lockd grace sunrpc lp parport autofs4 psmouse floppy pata_acpi
| CPU: 0 PID: 5000 Comm: deluged Not tainted 3.19.8-ckt4 #1
| Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
|  ffffffff81ab4fef ffff8800db637858 ffffffff817c3760 ffff88011fc0fdb8
|  0000000000000000 ffff8800db637898 ffffffff8107696a 0000000000000001
|  00000000000003bf ffff8800d98e4000 0000000000008000 ffff8800084c1000
| Call Trace:
|  [<ffffffff817c3760>] dump_stack+0x45/0x57
|  [<ffffffff8107696a>] warn_slowpath_common+0x8a/0xc0
|  [<ffffffff81076a5a>] warn_slowpath_null+0x1a/0x20
|  [<ffffffff812ae6ea>] ext4_mb_generate_buddy+0x1fa/0x340
|  [<ffffffff812aed00>] ext4_mb_init_cache+0x390/0x700
|  [<ffffffff812af5cd>] ext4_mb_load_buddy+0x1ad/0x360
|  [<ffffffff812b25d7>] ext4_mb_regular_allocator+0x1b7/0x450
|  [<ffffffff812b41f1>] ext4_mb_new_blocks+0x401/0x550
|  [<ffffffff812a4120>] ? ext4_find_extent+0x140/0x330
|  [<ffffffff812a8a87>] ext4_ext_map_blocks+0x637/0xe50
|  [<ffffffff8127b6d9>] ext4_map_blocks+0x129/0x570
|  [<ffffffff8127eac2>] ext4_writepages+0x582/0xca0
|  [<ffffffff810f0700>] ? get_futex_key+0x1c0/0x2b0
|  [<ffffffff810a71c8>] ? __enqueue_entity+0x78/0x80
|  [<ffffffff81187a4e>] do_writepages+0x1e/0x30
|  [<ffffffff8117bbe9>] __filemap_fdatawrite_range+0x59/0x60
|  [<ffffffff8117bc4c>] filemap_write_and_wait+0x2c/0x60
|  [<ffffffff8120903d>] do_vfs_ioctl+0x3fd/0x4e0
|  [<ffffffff812091a1>] SyS_ioctl+0x81/0xa0
|  [<ffffffff817ca84d>] system_call_fastpath+0x16/0x1b
| ---[ end trace 860c733f0437c9b7 ]---

After which the kernel starts logging in rapid succession:
| EXT4-fs error (device vdb): ext4_find_extent:900: inode #84410502:
|    comm deluged: pblk 223281469 bad header/extent: invalid magic - magic
|    80da, entries 13942, max 3979(0), depth 42746(0)
| EXT4-fs error: 40 callbacks suppressed

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
