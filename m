From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113041] mbcache NULL pointer dereference
Date: Mon, 11 Apr 2016 13:21:15 +0000
Message-ID: <bug-113041-13602-Z0QLCuu2uY@https.bugzilla.kernel.org/>
References: <bug-113041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40404 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbcDKNV2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Apr 2016 09:21:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4990B201B9
	for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2016 13:21:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5AE5B202F8
	for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2016 13:21:16 +0000 (UTC)
In-Reply-To: <bug-113041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113041

--- Comment #4 from Johnny <johnny+bugzilla@appdata.biz> ---
Another crash today with a similar trace output:

```
[511806.488629] general protection fault: 0000 [#1] SMP
[511806.489335] Modules linked in: xt_conntrack ipt_MASQUERADE
nf_nat_masquerade_ipv4 vxlan ip6_udp_tunnel udp_tunnel iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
br_netfilter nf_nat nf_conntrack bridge stp llc xfs libcrc32c nls_ascii
nls_cp437 vfat fat xenfs xen_privcmd ext4 crc16 mbcache jbd2 crc32c_intel hmac
drbg aesni_intel ata_piix aes_x86_64 glue_helper libata lrw mousedev gf128mul
ablk_helper cryptd xen_blkfront microcode i2c_piix4 firmware_class scsi_mod
psmouse i2c_core ixgbevf evdev acpi_cpufreq button sch_fq_codel ip_tables
autofs4
[511806.520082] CPU: 2 PID: 57829 Comm: java Not tainted 4.2.2-coreos-r2 #2
[511806.529094] Hardware name: Xen HVM domU, BIOS 4.2.amazon 12/07/2015
[511806.529094] task: ffff8801636e0000 ti: ffff88015aaf0000 task.ti:
ffff88015aaf0000
[511806.529094] RIP: 0010:[<ffffffff812c3bf9>]  [<ffffffff812c3bf9>]
strnlen+0x9/0x40
[511806.529094] RSP: 0018:ffff88015aaf3128  EFLAGS: 00010086
[511806.529094] RAX: ffffffff817c48ce RBX: ffffffff8356e003 RCX:
0000000000000000
[511806.529094] RDX: 017fff0000080078 RSI: ffffffffffffffff RDI:
017fff0000080078
[511806.529094] RBP: ffff88015aaf3128 R08: 000000000000ffff R09:
000000000000ffff
[511806.529094] R10: ffff880770658f80 R11: ffff88072d51e888 R12:
017fff0000080078
[511806.529094] R13: ffffffff8356e3a0 R14: 00000000ffffffff R15:
0000000000000000
[511806.529094] FS:  00007ff4a85f8700(0000) GS:ffff880770640000(0000)
knlGS:0000000000000000
[511806.529094] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[511806.529094] CR2: 00007ff65800e000 CR3: 00000006e0ff1000 CR4:
00000000001406e0
[511806.529094] Stack:
[511806.529094]  ffff88015aaf3168 ffffffff812c58ff 0000000000000296
ffffffff8356e003
[511806.529094]  ffffffff8356e3a0 ffff88015aaf32b0 ffffffff817c9288
ffffffff817c9288
[511806.529094]  ffff88015aaf31e8 ffffffff812c73b3 ffff88015aaf31b8
ffffffff81154868
[511806.529094] Call Trace:
[511806.529094]  [<ffffffff812c58ff>] string.isra.4+0x3f/0xd0
[511806.529094]  [<ffffffff812c73b3>] vsnprintf+0x163/0x510
[511806.529094]  [<ffffffff81154868>] ? free_hot_cold_page_list+0x48/0xa0
[511806.529094]  [<ffffffff812c7771>] vscnprintf+0x11/0x40
[511806.529094]  [<ffffffff810bd548>] vprintk_emit+0x128/0x530
[511806.529094]  [<ffffffff810bda9f>] vprintk_default+0x1f/0x30
[511806.529094]  [<ffffffff815250d3>] printk+0x46/0x48
[511806.529094]  [<ffffffff811a318a>] kmem_cache_free+0x13a/0x1f0
[511806.529094]  [<ffffffff810afc01>] ?
__raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[511806.529094]  [<ffffffffa003f0ce>] 0xffffffffa003f0ce
[511806.529094]  [<ffffffffa003ffac>] mb_cache_shrink+0x2bc/0x3a0 [mbcache]
[511806.529094]  [<ffffffff8115ef3d>] shrink_slab+0x1ed/0x370
[511806.529094]  [<ffffffff8109cd00>] ? enqueue_entity+0x3e0/0xdc0
[511806.529094]  [<ffffffff81163283>] shrink_zone+0x283/0x290
[511806.529094]  [<ffffffff811633ec>] do_try_to_free_pages+0x15c/0x430
[511806.529094]  [<ffffffff8116377a>] try_to_free_pages+0xba/0x130
[511806.529094]  [<ffffffff8115658a>] __alloc_pages_nodemask+0x56a/0x970
[511806.529094]  [<ffffffff81199221>] alloc_pages_current+0x91/0x100
[511806.529094]  [<ffffffff811a3d9c>] new_slab+0x34c/0x440
[511806.529094]  [<ffffffff810afc01>] ?
__raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[511806.529094]  [<ffffffff811a4239>] __slab_alloc+0x3a9/0x490
[511806.529094]  [<ffffffffa017aa6f>] ? ext4_orphan_del+0x47ff/0xda20 [ext4]
[511806.529094]  [<ffffffff8126818c>] ? hashtab_search+0x5c/0x80
[511806.529094]  [<ffffffff81274787>] ? mls_level_isvalid+0x57/0x60
[511806.529094]  [<ffffffffa017aa6f>] ? ext4_orphan_del+0x47ff/0xda20 [ext4]
[511806.529094]  [<ffffffff811a44b1>] kmem_cache_alloc+0x191/0x1f0
[511806.529094]  [<ffffffffa017aa6f>] ext4_orphan_del+0x47ff/0xda20 [ext4]
[511806.529094]  [<ffffffff811d7a9d>] alloc_inode+0x1d/0x90
[511806.529094]  [<ffffffff811d98a1>] new_inode_pseudo+0x11/0x60
[511806.529094]  [<ffffffff811d990b>] new_inode+0x1b/0x40
[511806.529094]  [<ffffffffa0163c7f>] __ext4_new_inode+0x7f/0x1190 [ext4]
[511806.529094]  [<ffffffffa017463c>] ext4_insert_dentry+0x188c/0x1900 [ext4]
[511806.529094]  [<ffffffff811c9e2a>] vfs_create+0xca/0x130
[511806.529094]  [<ffffffff8123c748>] ovl_create_real+0xb8/0x230
[511806.529094]  [<ffffffff8123d9ab>] ovl_create_or_link+0x10b/0x500
[511806.529094]  [<ffffffff8123dddd>] ovl_create_object+0x3d/0x60
[511806.529094]  [<ffffffff8125d533>] ? selinux_inode_create+0x13/0x20
[511806.529094]  [<ffffffff8123deb1>] ovl_create+0x21/0x30
[511806.529094]  [<ffffffff811c9e2a>] vfs_create+0xca/0x130
[511806.529094]  [<ffffffff811cc3f1>] path_openat+0xab1/0x13e0
[511806.529094]  [<ffffffff811cce9b>] ? putname+0x5b/0x60
[511806.529094]  [<ffffffff81090f6f>] ? wake_up_q+0x2f/0x70
[511806.529094]  [<ffffffff811a4499>] ? kmem_cache_alloc+0x179/0x1f0
[511806.529094]  [<ffffffff811cdddb>] do_filp_open+0x7b/0xe0
[511806.529094]  [<ffffffff811daeb9>] ? __alloc_fd+0x89/0x110
[511806.529094]  [<ffffffff811bd27c>] do_sys_open+0x12c/0x210
[511806.529094]  [<ffffffff81021b4f>] ? syscall_trace_enter_phase1+0xff/0x150
[511806.529094]  [<ffffffff811bd37e>] SyS_open+0x1e/0x20
[511806.529094]  [<ffffffff8152bbae>] entry_SYSCALL_64_fastpath+0x12/0x71
[511806.529094] Code: 00 00 80 3f 00 55 48 89 e5 74 11 48 89 f8 48 83 c0 01 80
38 00 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 90 55 48 85 f6 48 89 e5 74 2d <80> 3f
00 74 28 48 8d 47 01 48 01 fe eb 0a 48 83 c0 01 80 78 ff
[511806.529094] RIP  [<ffffffff812c3bf9>] strnlen+0x9/0x40
[511806.529094]  RSP <ffff88015aaf3128>
[511806.529094] ---[ end trace 045dada6ce1782d4 ]---
[511806.529094] Kernel panic - not syncing: Fatal exception
[511806.529094] Kernel Offset: disabled
```

It could possibly be related to making backups of the data files of cassandra
at the same time. As there are no logs from cassandra at the moment of the
crash, it's hard to know exactly what it's trying to do.
A general observation is that in both traces there is something mentioning
deleting files on ext4 while the cassandra storage is supposed to use xfs in
our mount table. Also cassandra is doing file compactions moving data around
pretty much all the time but there are no extra ordinary readings from the disk
statistics at the time of the crash.

Additional note is that the version of cassandra is 2.1.11-1, not .12 as
previously mentioned.
Also linux version is higher this time:
Linux version 4.3.6-coreos (buildbot@ip-10-204-3-57) (gcc version 4.9.3 (Gentoo
Hardened 4.9.3 p1.3, pie-0.6.3) ) #2 SMP Tue Apr 5 10:32:16 UTC 2016

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
