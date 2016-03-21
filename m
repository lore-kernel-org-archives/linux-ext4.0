From: Jan Kara <jack@suse.cz>
Subject: Re: Softlockup when doing fallocate on 4.4.1
Date: Mon, 21 Mar 2016 16:38:31 +0100
Message-ID: <20160321153831.GA31415@quack.suse.cz>
References: <56C5D4F9.6050809@kyup.com>
 <56D6B8CC.9010407@siteground.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	SiteGround Operations <operations@siteground.com>
To: Nikolay Borisov <n.borisov@siteground.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbcCUPiG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2016 11:38:06 -0400
Content-Disposition: inline
In-Reply-To: <56D6B8CC.9010407@siteground.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 02-03-16 11:56:28, Nikolay Borisov wrote:
> Ping on that.
> 
> Any pointers will be much appreciated, I know Theodore has been busy
> lately, any one else experienced in ext4 internals to have any ideas?

This looks like the efficiency issue we had in SEEK_HOLE / SEEK_DATA
implementation. Ted has just merged fixes during this merge window that
should fix the issue - look for commits 140a52508a68, facab4d9711e,
e3fb8eb14eafd, 2d90c160e5f1.

								Honza

> On 02/18/2016 04:28 PM, Nikolay Borisov wrote:
> > Hello, 
> > 
> > I've recently migrated some servers to 4.4.1 (from 3.12) and almost 
> > instantly began seeing strange behavior. The workload consists of 
> > running fallocate -d on a sparse file which houses LVM vg with ext4 
> > on top and I got softlockups at various stages of the process. The 
> > first one looks like:
> > 
> > [48778.582537] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [fallocate:24387]
> > [48778.582717] Modules linked in: zfs(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO) zunicode(PO) dm_snapshot dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio xt_multiport xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ext2 ib_ipoib ib_cm ib_sa ses enclosure igb i2c_algo_bit ipmi_devintf ipmi_si ipmi_msghandler x86_pkg_temp_thermal crc32_pclmul sb_edac edac_core i2c_i801 lpc_ich mfd_core ioatdma shpchp ib_qib dca ib_mad ib_core ib_addr ipv6
> > [48778.585741] CPU: 0 PID: 24387 Comm: fallocate Tainted: P           O    4.4.1-clouder2 #69
> > [48778.585918] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
> > [48778.586091] task: ffff8803c4bf1a00 ti: ffff8803e6f60000 task.ti: ffff8803e6f60000
> > [48778.586265] RIP: 0010:[<ffffffff812ae58e>]  [<ffffffff812ae58e>] ext4_es_lookup_extent+0x12e/0x1e0
> > [48778.586610] RSP: 0018:ffff8803e6f63d08  EFLAGS: 00000206
> > [48778.586780] RAX: ffff88004629fdc0 RBX: 000000000247ebfd RCX: ffff88004629fdc0
> > [48778.586954] RDX: 00000000002718c0 RSI: 0000000000272000 RDI: ffff8801e9c84738
> > [48778.587127] RBP: ffff8803e6f63d78 R08: 0000003baef8fee8 R09: 0000000000005f43
> > [48778.587301] R10: 00000002cb7e0000 R11: 0000000000000246 R12: ffff8801e9c844c0
> > [48778.587475] R13: ffff8803e6f63db8 R14: 0000000000d81404 R15: ffff8801e9c84400
> > [48778.587648] FS:  00007f7ee10cb700(0000) GS:ffff88047fc00000(0000) knlGS:0000000000000000
> > [48778.587818] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [48778.587985] CR2: 000000330cb29140 CR3: 0000000410d94000 CR4: 00000000001406f0
> > [48778.588153] Stack:
> > [48778.588313]  0000000000000246 00000002cb7e0000 0000000000005f43 0000003baef8fee8
> > [48778.588673]  ffff880100000000 ffff8801a1b07dc0 0000000000000000 0000000002471eee
> > [48778.589032]  000000000023e940 ffff8803e6f63ea8 ffff8801e9c844c0 0000000000000000
> > [48778.589397] Call Trace:
> > [48778.589571]  [<ffffffff8126c3dc>] ext4_map_blocks+0x4c/0x480
> > [48778.589744]  [<ffffffff812ae707>] ? ext4_es_find_delayed_extent_range+0xc7/0x200
> > [48778.589922]  [<ffffffff8126c394>] ? ext4_map_blocks+0x4/0x480
> > [48778.590095]  [<ffffffff81267786>] ext4_llseek+0x146/0x390
> > [48778.590270]  [<ffffffff811d9364>] ? fsnotify_access+0x64/0x80
> > [48778.590443]  [<ffffffff811d909e>] vfs_llseek+0x2e/0x30
> > [48778.590615]  [<ffffffff811da163>] SyS_lseek+0x93/0xa0
> > [48778.590791]  [<ffffffff8167dad7>] entry_SYSCALL_64_fastpath+0x12/0x6a
> > [48778.590964] Code: a1 57 a2 00 89 45 b0 65 ff 0d 23 c7 d5 7e 85 c0 7f 7f 48 83 c4 48 44 89 f0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 89 d6 03 70 1c 72 25 <ff> ce 39 f3 76 06 48 8b 40 08 eb 8b 49 8b 5c 24 28 48 85 c0 48 
> > [48778.594510] Kernel panic - not syncing: softlockup: hung tasks
> > [48778.594685] CPU: 0 PID: 24387 Comm: fallocate Tainted: P           O L  4.4.1-clouder2 #69
> > [48778.594861] Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
> > [48778.595037]  ffff8803e6f63c58 ffff88047fc03d78 ffffffff81339b7f 0000000000000016
> > [48778.595405]  0000000000000016 0000000000000000 ffffffff81a23506 ffff88047fc03df8
> > [48778.595772]  ffffffff81167979 0000000000000008 ffff88047fc03e08 ffff88047fc03da8
> > [48778.596138] Call Trace:
> > [48778.596307]  <IRQ>  [<ffffffff81339b7f>] dump_stack+0x4f/0x80
> > [48778.596534]  [<ffffffff81167979>] panic+0xc0/0x21a
> > [48778.596709]  [<ffffffff81128c36>] watchdog_timer_fn+0x1e6/0x1f0
> > [48778.596885]  [<ffffffff810fb99d>] __hrtimer_run_queues+0x10d/0x2b0
> > [48778.597060]  [<ffffffff81128a50>] ? watchdog+0x50/0x50
> > [48778.597236]  [<ffffffff81100f62>] ? ktime_get+0x52/0xc0
> > [48778.597409]  [<ffffffff81101f31>] ? ktime_get_update_offsets_now+0x61/0x110
> > [48778.597588]  [<ffffffff810a65b1>] ? __do_softirq+0x1e1/0x320
> > [48778.597762]  [<ffffffff810fbcd2>] hrtimer_interrupt+0xa2/0x1e0
> > [48778.597940]  [<ffffffff81086249>] local_apic_timer_interrupt+0x39/0x60
> > [48778.598115]  [<ffffffff81680075>] smp_apic_timer_interrupt+0x45/0x60
> > [48778.598290]  [<ffffffff8167e7e9>] apic_timer_interrupt+0x89/0x90
> > [48778.598461]  <EOI>  [<ffffffff812ae58e>] ? ext4_es_lookup_extent+0x12e/0x1e0
> > [48778.598687]  [<ffffffff812ae4a4>] ? ext4_es_lookup_extent+0x44/0x1e0
> > [48778.598863]  [<ffffffff8126c3dc>] ext4_map_blocks+0x4c/0x480
> > [48778.599037]  [<ffffffff812ae707>] ? ext4_es_find_delayed_extent_range+0xc7/0x200
> > [48778.599214]  [<ffffffff8126c394>] ? ext4_map_blocks+0x4/0x480
> > [48778.599392]  [<ffffffff81267786>] ext4_llseek+0x146/0x390
> > [48778.599567]  [<ffffffff811d9364>] ? fsnotify_access+0x64/0x80
> > [48778.599740]  [<ffffffff811d909e>] vfs_llseek+0x2e/0x30
> > [48778.599913]  [<ffffffff811da163>] SyS_lseek+0x93/0xa0
> > [48778.600084]  [<ffffffff8167dad7>] entry_SYSCALL_64_fastpath+0x12/0x6a
> > 
> > Doing addr2line on ffffffff812ae58e points to ext4_es_end, which is 
> > called in the while searching the rb tree of extents in 
> > ext4_es_lookup_extent. At first I thought that the tree was VERY large 
> > and that's why it takes forever to search through it, however dumping 
> > it (courtesy of crash utility) it turns out the tree only has 4k 
> > entries - not that many at all. Could something have been corrupted and 
> > that's why the code looped forever? I can provide textual dump of the 
> > RB tree if necessary. 
> > 
> > 
> > The second crash (on a different server, but with the same kernel and 
> > identical workload): 
> > 
> > 
> > [77316.261994] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [fallocate:26230]
> > [77316.262171] Modules linked in: zfs(PO) zcommon(PO) znvpair(PO) spl(O) zavl(PO) zunicode(PO) dm_snapshot dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack xt_multiport ext2 ib_ipoib ib_cm ib_sa ses enclosure igb i2c_algo_bit ipmi_devintf ipmi_si ipmi_msghandler x86_pkg_temp_thermal crc32_pclmul sb_edac edac_core i2c_i801 lpc_ich mfd_core ioatdma shpchp ib_qib dca ib_mad ib_core ib_addr ipv6
> > [77316.265178] CPU: 0 PID: 26230 Comm: fallocate Tainted: P           O    4.4.1-clouder2 #69
> > [77316.265355] Hardware name: Supermicro X9DRD-iF/X9DRD-iF, BIOS 3.0  07/09/2013
> > [77316.265531] task: ffff8803052d6800 ti: ffff8802c14f4000 task.ti: ffff8802c14f4000
> > [77316.265707] RIP: 0010:[<ffffffff81267773>]  [<ffffffff81267773>] ext4_llseek+0x133/0x390
> > [77316.265936] RSP: 0018:ffff8802c14f7e28  EFLAGS: 00000246
> > [77316.266108] RAX: 0000001cb6b8f000 RBX: ffff8801a3de0c00 RCX: 0000000000000000
> > [77316.266281] RDX: ffff8803173bd528 RSI: 0000000001cb6b8e RDI: 0000000000000000
> > [77316.266454] RBP: ffff8802c14f7ef8 R08: 00000033ea18fee8 R09: 0000000000006676
> > [77316.266627] R10: 000000004f3e0000 R11: 0000000000000246 R12: ffff8801c68178c0
> > [77316.266800] R13: 0000000001cb6b8f R14: 00000000008c9472 R15: ffff8802c14f7ea8
> > [77316.266971] FS:  00007f8bec7d0700(0000) GS:ffff88047fc00000(0000) knlGS:0000000000000000
> > [77316.267145] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [77316.267313] CR2: 00005618348e0000 CR3: 000000046abe9000 CR4: 00000000001406f0
> > [77316.267484] Stack:
> > [77316.267647]  ffff8802c14f7ec8 ffffffff0004f3e0 00000ffffffff000 ffff8801c6817968
> > [77316.268009]  0000002580000000 ffff8802c14f7ea8 0000000002580000 0000000000000000
> > [77316.268371]  ffff8801a3de0c00 000000000000000c ffff8801c68178c0 ffff8801a3de0c10
> > [77316.268734] Call Trace:
> > [77316.268903]  [<ffffffff811d9364>] ? fsnotify_access+0x64/0x80
> > [77316.269077]  [<ffffffff811d909e>] vfs_llseek+0x2e/0x30
> > [77316.269249]  [<ffffffff811da163>] SyS_lseek+0x93/0xa0
> > [77316.269422]  [<ffffffff8167dad7>] entry_SYSCALL_64_fastpath+0x12/0x6a
> > [77316.269593] Code: ff c6 45 29 ee eb 20 41 ff c5 0f b6 8d 78 ff ff ff 44 89 e8 41 ff ce 48 d3 e0 44 39 ad 60 ff ff ff 48 89 45 c8 72 75 31 c9 31 ff <44> 89 6d b8 44 89 75 bc 4c 89 fa 4c 89 e6 e8 0a 4c 00 00 85 c0 
> > [77316.273096] Kernel panic - not syncing: softlockup: hung tasks
> > [77316.273268] CPU: 0 PID: 26230 Comm: fallocate Tainted: P           O L  4.4.1-clouder2 #69
> > [77316.273441] Hardware name: Supermicro X9DRD-iF/X9DRD-iF, BIOS 3.0  07/09/2013
> > [77316.273613]  ffff8802c14f7d78 ffff88047fc03d78 ffffffff81339b7f 0000000000000016
> > [77316.273976]  0000000000000016 0000000000000000 ffffffff81a23506 ffff88047fc03df8
> > [77316.274339]  ffffffff81167979 0000000000000008 ffff88047fc03e08 ffff88047fc03da8
> > [77316.274700] Call Trace:
> > [77316.274865]  <IRQ>  [<ffffffff81339b7f>] dump_stack+0x4f/0x80
> > [77316.275088]  [<ffffffff81167979>] panic+0xc0/0x21a
> > [77316.275263]  [<ffffffff81128c36>] watchdog_timer_fn+0x1e6/0x1f0
> > [77316.275440]  [<ffffffff810fb99d>] __hrtimer_run_queues+0x10d/0x2b0
> > [77316.275614]  [<ffffffff81128a50>] ? watchdog+0x50/0x50
> > [77316.275787]  [<ffffffff813198f2>] ? blk_done_softirq+0x82/0xa0
> > [77316.275963]  [<ffffffff810a5edf>] ? __local_bh_enable+0x3f/0x70
> > [77316.276135]  [<ffffffff81101f31>] ? ktime_get_update_offsets_now+0x61/0x110
> > [77316.276309]  [<ffffffff810fbcd2>] hrtimer_interrupt+0xa2/0x1e0
> > [77316.276484]  [<ffffffff81086249>] local_apic_timer_interrupt+0x39/0x60
> > [77316.276657]  [<ffffffff81680075>] smp_apic_timer_interrupt+0x45/0x60
> > [77316.276831]  [<ffffffff8167e7e9>] apic_timer_interrupt+0x89/0x90
> > [77316.277001]  <EOI>  [<ffffffff81267773>] ? ext4_llseek+0x133/0x390
> > [77316.277224]  [<ffffffff812677a6>] ? ext4_llseek+0x166/0x390
> > [77316.277396]  [<ffffffff811d9364>] ? fsnotify_access+0x64/0x80
> > [77316.277570]  [<ffffffff811d909e>] vfs_llseek+0x2e/0x30
> > [77316.277741]  [<ffffffff811da163>] SyS_lseek+0x93/0xa0
> > [77316.277912]  [<ffffffff8167dad7>] entry_SYSCALL_64_fastpath+0x12/0x6a
> > 
> > In this case it seems the kernel was stuck in the do {} while loop 
> > in ext4_seek_data. It seems in this loop most of the time is probably
> > spent in ext4_map_blocks -> ext4_es_lookup_extent, which leads to the 
> > first reported issue. However, in this case the softlockup watchdog 
> > triggered at the beginning of the next iteration on the do {} while 
> > loop.
> > 
> > Any help will be much apreaciated. 
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
