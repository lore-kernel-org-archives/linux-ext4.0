From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: FYI: one more way to run xfstest
Date: Thu, 21 Mar 2013 12:25:05 +0400
Message-ID: <87d2utxiqm.fsf@openvz.org>
References: <87txo6xu5u.fsf@openvz.org> <20130320112852.GB13294@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62604 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3CUIZK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2013 04:25:10 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so4654586lab.19
        for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2013 01:25:08 -0700 (PDT)
In-Reply-To: <20130320112852.GB13294@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Wed, 20 Mar 2013 12:28:52 +0100, Jan Kara <jack@suse.cz> wrote:
> On Wed 20-03-13 14:06:05, Dmitry Monakhov wrote:
> > 
> > Today I've run xfstest in parallel with fsfreze/fsthaw like follows
> > # I use dmsetup {suspend,resume} which does fsfreeze/fsthaw and other
> > # dm's speciffic stuff (which is not related in that case)
> > (while true ;do dmsetup suspend $TEST_DEV ;dmsetup resume $TEST_DEV;done)&
> > (while true ;do dmsetup suspend $SCRATCH_DEV ;dmsetup resume $SCRATCH_DEV;done)&
> > # And later as usual
> > ./check -g auto
> > I use origin/dev (current dev HEAD): c902ed2d06a
> > 
> > Quickly it spots a lot of traces from incorrect freeze-api state:
> > ------------[ cut here ]------------
> > WARNING: at fs/ext4/ext4_jbd2.c:50 __ext4_journal_start_sb+0x132/0x240()
>   Heh, funny, Al Viro just found this issue as well yesterday. The problem
> is that ext4_file_dio_write() is missing proper freeze protection. We are
> likely going to somewhat move where freeze protection happens for writes
> due to other issues (discussing that now) so it doesn't make sense to fix
> it just now in ext4.
Ok, Al Viro already has fix for that in his tree.

It is appeared that 068'th test result in interesting bugs because it
use xfs_freeze which call ->freeze_super() (dmsetup suspen usefreeze_bdev() )
I've run in like follows:
(while true ;do dmsetup suspend $TEST_DEV ;dmsetup resume $TEST_DEV;done)&
(while true ;do dmsetup suspend $SCRATCH_DEV ;dmsetup resume $SCRATCH_DEV;done)&
./check  068 068 068 068 068 068 068 068 068 068 068 068

LIST of bugs I know at this moment:
1)

--=-=-=
Content-Disposition: inline; filename=1.txt

=====================================
[ BUG: bad unlock balance detected! ]
3.8.0-rc3+ #99 Not tainted
-------------------------------------
dmsetup/12756 is trying to release lock (
BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1144
in_atomic(): 0, irqs_disabled(): 1, pid: 12756, name: dmsetup
INFO: lockdep is turned off.
irq event stamp: 7035
hardirqs last  enabled at (7035): [<ffffffff818f2422>] _raw_spin_unlock_irq+0x32/0x80
hardirqs last disabled at (7034): [<ffffffff818f2708>] _raw_spin_lock_irq+0x58/0xe0
softirqs last  enabled at (6440): [<ffffffff8107eddf>] __do_softirq+0x3bf/0x400
softirqs last disabled at (6435): [<ffffffff819009fc>] call_softirq+0x1c/0x30
Pid: 12756, comm: dmsetup Not tainted 3.8.0-rc3+ #99
Call Trace:
 [<ffffffff810c990c>] __might_sleep+0x12c/0x1b0
 [<ffffffff818f8e40>] ? __do_page_fault+0x400/0xa00
 [<ffffffff818f9133>] __do_page_fault+0x6f3/0xa00
 [<ffffffff8173a57a>] ? usb_console_write+0x14a/0x230
 [<ffffffff8146e4cd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81247dfa>] ? drop_super+0x1a/0x30
 [<ffffffff818f944e>] do_page_fault+0xe/0x10
 [<ffffffff818f33f8>] page_fault+0x28/0x30
 [<ffffffff81247dfa>] ? drop_super+0x1a/0x30
 [<ffffffff8110039a>] ? print_lockdep_cache+0x1a/0x70
 [<ffffffff81247dfa>] ? drop_super+0x1a/0x30
 [<ffffffff818ec9d4>] ? printk+0x4d/0x4f
 [<ffffffff811029d0>] print_unlock_inbalance_bug+0xa0/0x100
 [<ffffffff8110687f>] lock_release_non_nested+0x24f/0x3a0
 [<ffffffff810ffb3d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810d0a55>] ? local_clock+0x165/0x170
 [<ffffffff81247dfa>] ? drop_super+0x1a/0x30
 [<ffffffff81247dfa>] ? drop_super+0x1a/0x30
 [<ffffffff81106a60>] __lock_release+0x90/0x1f0
 [<ffffffff81247dfa>] ? drop_super+0x1a/0x30
 [<ffffffff81106c52>] lock_release+0x92/0x140
 [<ffffffff810b5ae3>] up_read+0x23/0x40
 [<ffffffff81247dfa>] drop_super+0x1a/0x30
 [<ffffffff8129e543>] freeze_bdev+0x103/0x130
 [<ffffffffa0001498>] lock_fs+0x68/0xf0 [dm_mod]
 [<ffffffffa00033b8>] dm_suspend+0x358/0x460 [dm_mod]
 [<ffffffffa000cef0>] ? do_resume+0x320/0x320 [dm_mod]
 [<ffffffff810b5ae3>] ? up_read+0x23/0x40
 [<ffffffffa000cbab>] do_suspend+0xfb/0x120 [dm_mod]
 [<ffffffffa000cef0>] ? do_resume+0x320/0x320 [dm_mod]
 [<ffffffffa000cf25>] dev_suspend+0x35/0x40 [dm_mod]
 [<ffffffffa000e46e>] ctl_ioctl+0x2ce/0x320 [dm_mod]
 [<ffffffffa000e4d3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
 [<ffffffff812605b4>] vfs_ioctl+0x34/0x80
 [<ffffffff812615d3>] do_vfs_ioctl+0x373/0x400
 [<ffffffff818f3198>] ? retint_swapgs+0x13/0x1b
 [<ffffffff81261751>] sys_ioctl+0xf1/0x100
 [<ffffffff818ff659>] system_call_fastpath+0x16/0x1b

--=-=-=

Patch already available here: http://patchwork.ozlabs.org/patch/229377/
2)

--=-=-=
Content-Disposition: inline; filename=2.txt

WARNING: at fs/ext4/ext4_jbd2.c:50 __ext4_journal_start_sb+0x132/0x240()
Hardware name:         
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
Pid: 2406, comm: fstest Not tainted 3.8.0-rc3+ #101
Call Trace:
 [<ffffffff8106fb0d>] warn_slowpath_common+0xad/0xf0
 [<ffffffff813882a2>] ? ext4_ext_remove_space+0x62/0xb00
 [<ffffffff8106fb6a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8138a222>] __ext4_journal_start_sb+0x132/0x240
 [<ffffffff813882a2>] ext4_ext_remove_space+0x62/0xb00
 [<ffffffff813a5004>] ? ext4_es_remove_extent+0x134/0x150
 [<ffffffff813895cf>] ? ext4_ext_truncate+0x1ef/0x2c0
 [<ffffffff81389621>] ext4_ext_truncate+0x241/0x2c0
 [<ffffffff8133e338>] ext4_truncate+0x238/0x2a0
 [<ffffffff81342ae2>] ext4_setattr+0x232/0x900
 [<ffffffff81270e24>] notify_change+0x434/0x6a0
 [<ffffffff812411de>] do_truncate+0xae/0xe0
 [<ffffffff81259c7d>] do_last+0x80d/0xe20
 [<ffffffff8125b6c6>] path_openat+0x1d6/0x7f0
 [<ffffffff810ffb3d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810d0a55>] ? local_clock+0x165/0x170
 [<ffffffff8125bea9>] do_filp_open+0x49/0x120
 [<ffffffff81272c8e>] ? __alloc_fd+0x20e/0x240
 [<ffffffff81240254>] do_sys_open+0x264/0x320
 [<ffffffff81240351>] sys_open+0x21/0x30
 [<ffffffff818ff6d9>] system_call_fastpath+0x16/0x1b

--=-=-=

Happens because we do do_truncate() but got_write == 0 inside do_last()
I'll send patch soon.

3) This  one look's strange and I dont have fix for that for now.
 
--=-=-=
Content-Disposition: inline; filename=3.txt

BUG: Dentry ffff88022a971bf0{i=60007,n=file1} still in use (1) [unmount of ext4 dm-3]
------------[ cut here ]------------
kernel BUG at fs/dcache.c:943!
invalid opcode: 0000 [#1] SMP 
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
CPU 2 
Pid: 4165, comm: dmsetup Not tainted 3.8.0-rc3+ #104                  /DQ67SW
RIP: 0010:[<ffffffff81269921>]  [<ffffffff81269921>] shrink_dcache_for_umount_subtree+0x2a1/0x2b0
RSP: 0018:ffff8802303fdc18  EFLAGS: 00010292
RAX: 0000000000000055 RBX: ffff88022a971bf0 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000246
RBP: ffff8802303fdc58 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000003 R11: 0000000000000000 R12: ffff88022a9094f0
R13: 0000000000000000 R14: ffffffff8225ea60 R15: ffffffff8225eab0
FS:  00007f65d3b5d7a0(0000) GS:ffff88023d800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f682e6ba000 CR3: 000000022294c000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dmsetup (pid: 4165, threadinfo ffff8802303fc000, task ffff880220e5c680)
Stack:
 ffff88022a323720 0000000000000006 ffff8802303fdc78 ffff88022a323000
 ffffffff81a6d8a0 0000000000000000 ffff88022a2d6988 0000000000000000
 ffff8802303fdc78 ffffffff8126997f 0000000000000001 ffff88022a323000
Call Trace:
 [<ffffffff8126997f>] shrink_dcache_for_umount+0x4f/0x70
 [<ffffffff812477b5>] generic_shutdown_super+0xe5/0x180
 [<ffffffff81247897>] kill_block_super+0x47/0x140
 [<ffffffff81248155>] deactivate_locked_super+0x65/0x90
 [<ffffffff81248234>] thaw_super+0xb4/0x150
 [<ffffffff8129e434>] thaw_bdev+0xc4/0x160
 [<ffffffffa0001413>] unlock_fs+0x53/0xd0 [dm_mod]
 [<ffffffffa0003111>] dm_resume+0x141/0x160 [dm_mod]
 [<ffffffffa000cfc0>] ? do_resume+0x320/0x320 [dm_mod]
 [<ffffffffa000cee8>] do_resume+0x248/0x320 [dm_mod]
 [<ffffffffa000cfc0>] ? do_resume+0x320/0x320 [dm_mod]
 [<ffffffffa000cfea>] dev_suspend+0x2a/0x40 [dm_mod]
 [<ffffffffa000e53e>] ctl_ioctl+0x2ce/0x320 [dm_mod]
 [<ffffffffa000e5a3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
 [<ffffffff81260664>] vfs_ioctl+0x34/0x80
 [<ffffffff81261683>] do_vfs_ioctl+0x373/0x400
 [<ffffffff818f3318>] ? retint_swapgs+0x13/0x1b
 [<ffffffff81261801>] sys_ioctl+0xf1/0x100
 [<ffffffff818ff7d9>] system_call_fastpath+0x16/0x1b
Code: 50 28 4c 8b 0a 31 d2 48 85 f6 74 04 48 8b 56 40 48 05 20 07 00 00 48 89 de 48 c7 c7 b0 93 e3 81 48 89 04 24 31 c0 e8 b6 31 68 00 <0f> 0b eb fe 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 
RIP  [<ffffffff81269921>] shrink_dcache_for_umount_subtree+0x2a1/0x2b0
 RSP <ffff8802303fdc18>
---[ end trace 5307948fdb6a1756 ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff81337501>] find_group_orlov+0x511/0x710
PGD 21e002067 PUD 229b3d067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
CPU 0 
Pid: 4142, comm: fsstress Tainted: G      D      3.8.0-rc3+ #104                  /DQ67SW
RIP: 0010:[<ffffffff81337501>]  [<ffffffff81337501>] find_group_orlov+0x511/0x710
RSP: 0018:ffff88023160dc48  EFLAGS: 00010246
RAX: 0000000000000082 RBX: ffff88022a323000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88022a95d1d0 RDI: ffff88022981f000
RBP: ffff88023160dcf8 R08: ffff88022aa4e430 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000004 R12: 0000000000000050
R13: 0000000000000005 R14: 0000000000002000 R15: 0000000000000010
FS:  00007f86c9435700(0000) GS:ffff88023d400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000030 CR3: 000000022ca5d000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsstress (pid: 4142, threadinfo ffff88023160c000, task ffff880221114400)
Stack:
 0000000000000282 ffff88023160ddc4 000000000007b55b ffff88022a95d040
 0000000000000000 000000000001ff77 ffff8802316041ff 0009fd558148c333
 ffffffff82005680 0000000000000000 ffff88023160dcb8 ffffffff818f251b
Call Trace:
 [<ffffffff818f251b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff8126de27>] ? inode_sb_list_add+0x47/0x50
 [<ffffffff8133972b>] __ext4_new_inode+0xc4b/0x1640
 [<ffffffff810ffb3d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff812d6db0>] ? __dquot_initialize+0x30/0x2e0
 [<BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff81337501>] find_group_orlov+0x511/0x710
PGD 22f204067 PUD 21fc94067 PMD 0 
Oops: 0000 [#4] SMP 
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
CPU 1 
Pid: 4173, coBUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff81337501>] find_group_orlov+0x511/0x710
PGD 2240e0067 PUD 22a6c3067 PMD 0 
Oops: 0000 [#5] SMP 
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
CPU 3 
Pid: 5547, comm: fstest Tainted: G      D      3.8.0-rc3+ #104                  /DQ67SW
RIP: 0010:[<ffffffff81337501>]  [<ffffffff81337501>] find_group_orlov+0x511/0x710
RSP: 0018:ffff88022cd3bc48  EFLAGS: 00010246
RAX: 0000000000000082 RBX: ffff88022a323000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff880229f471d0 RDI: ffff88022981f000
RBP: ffff88022cd3bcf8 R08: ffff88022a9087d0 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000003 R12: 0000000000000050
R13: 0000000000000005 R14: 0000000000002000 R15: 0000000000000010
FS:  00007fc090ad3700(0000) GS:ffff88023da00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000030 CR3: 00000002207b4000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fstest (pid: 5547, threadinfo ffff88022cd3a000, task ffff88022e85c8c0)
Stack:
 0000000000000282 ffff88022cd3bdc4 000000000007b6a3 ffff880229f47040
 0000000000000000 000000000001ff77 ffff88022cd341ed 0009fd558148c333
 ffffffff82005680 0000000000000000 ffff88022cd3bcb8 ffffffff818f251b
Call Trace:
 [<ffffffff818f251b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff8126de27>] ? inode_sb_list_add+0x47/0x50
 [<ffffffff8133972b>] __ext4_new_inode+0xc4b/0x1640
 [<ffffffff810ffb3d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff812d6db0>] ? __dquot_initialize+0x30/0x2e0
 [<ffffffff81223254>] ? cache_free_debugcheck+0x1e4/0x2f0
 [<ffffffff8123d764>] ? delete_object_full+0x44/0x50
 [<ffffffff8135029c>] ext4_mkdir+0x14c/0x460
 [<ffffffff81405101>] ? security_inode_permission+0x61/0x70
 [<ffffffff8125646f>] vfs_mkdir+0x16f/0x1d0
 [<ffffffff8125d69b>] sys_mkdirat+0xdb/0x160
 [<ffffffff8125d739>] sys_mkdir+0x19/0x20
 [<ffffffff818ff7d9>] system_call_fastpath+0x16/0x1b
Code: 02 48 8b 0c d5 68 1c 2b 82 48 83 c1 01 85 c0 48 89 0c d5 68 1c 2b 82 0f 85 0f ff ff ff b8 ff ff ff ff e9 84 fe ff ff 48 8b 53 60 <48> 39 72 30 74 13 48 8b 96 c0 fe ff ff f7 c2 00 00 02 00 0f 84 
RIP  [<ffffffff81337501>] find_group_orlov+0x511/0x710
 RSP <ffff88022cd3bc48>
CR2: 0000000000000030
---[ end trace 5307948fdb6a175a ]---
nr_pdflush_threads exported in /proc is scheduled for removal
sysctl: The scan_unevictable_pages sysctl/node-interface has been disabled for lack of a legitimate use case.  If you have o

--=-=-=--
