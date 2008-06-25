From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Wed, 25 Jun 2008 09:09:24 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806250856160.16081@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <20080619155645.GA8582@mit.edu> <485A8C2D.1090806@redhat.com>
 <20080619174211.GB9119@mit.edu>  <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de>
  <20080620085922.GH9119@mit.edu>  <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de>
  <20080623174508.GA7216@skywalker>  <1214267492.27507.285.camel@BVR-FS.beaverton.ibm.com>
  <20080624030721.GB10469@skywalker> <20080624033349.GD10469@skywalker>
 <Pine.LNX.4.64.0806242103370.14795@diagnostix.dwd.de>
 <1214348318.27507.330.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:60023 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbYFYJJ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2008 05:09:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by node3.dwd.de (Postfix) with ESMTP id BD8E26B8455
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2008 09:09:27 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node3.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 22103-58 for <linux-ext4@vger.kernel.org>;
	Wed, 25 Jun 2008 09:09:27 +0000 (UTC)
In-Reply-To: <1214348318.27507.330.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 24 Jun 2008, Mingming wrote:

>
> On Tue, 2008-06-24 at 21:12 +0000, Holger Kiehl wrote:
>> Yes, with this patch applied on top of latest patch queue I no longer
>> get truncated files, after running a short test. Tomorrow I will do some
>> more thorough testing and use the patch you have send to me in a separate
>> mail. The above patch did not apply but it was easy to apply by hand.
>
>
> Thanks for quick response and test. I have updated the patch queue with
> above patch merged. Please let me know if you still see apply issue and
> file size update issue with current patch queue.
>
Thanks, it applies without any problems. However I still hit an oops. What
I find strange is that I got the oops just as the benchmark is done and
all process where shutting down. The same behaviour I reported here:
http://www.ussg.iu.edu/hypermail/linux/kernel/0806.2/2113.html
Only this time I got just one oops. This is on x86_64 system (4 Opteron CPU's
and SW Raid 1+0). I have not seen this on my home system x86 (1 Dual Core
and HW Raid). Anyway, here the dmesg output:

kjournald2 starting.  Commit interval 15 seconds
EXT4 FS on md7, internal journal
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
JBD: barrier-based sync failed on md7 - disabling barriers
------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:1667!
invalid opcode: 0000 [1] SMP 
CPU 3 
Modules linked in: w83627hf lm85 hwmon_vid bonding nf_conntrack_ftp ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables binfmt_misc sg floppy k8temp ohci_hcd i2c_amd756 i2c_core button usbcore
Pid: 2661, comm: kjournald2 Not tainted 2.6.26-rc6 #1
RIP: 0010:[<ffffffff802dd314>]  [<ffffffff802dd314>] ext4_da_writepage+0x30/0xf4
RSP: 0018:ffff81027d737c10  EFLAGS: 00010246
RAX: 010000000001002d RBX: ffffe200017e9218 RCX: 00000000ffffffe8
RDX: 0000000000004278 RSI: ffff81027d737e00 RDI: ffffe200017e9218
RBP: ffff81021dad66e8 R08: ffff81027ff05440 R09: ffff81027d737b50
R10: ffff81020fe54480 R11: ffff81020fe54400 R12: ffff81027d737e00
R13: 0000000000000001 R14: 0000000000000000 R15: ffff8101ff0b8120
FS:  00007f53ed10b6f0(0000) GS:ffff81027ff13000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000081a000 CR3: 0000000166f03000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald2 (pid: 2661, threadinfo ffff81027d736000, task ffff81027ed93210)
Stack:  ffff81021dad67f8 ffff81027d737e00 0000000000000000 ffffffff80261816
  ffffe200017e9218 ffffffff80261f8c ffff81021dad67f8 ffffffff8026180c
  ffff81021dad67f8 0000000280224f0c 0000000000000004 000000007d737fd8
Call Trace:
  [<ffffffff80261816>] ? __writepage+0xa/0x27
  [<ffffffff80261f8c>] ? write_cache_pages+0x174/0x2be
  [<ffffffff8026180c>] ? __writepage+0x0/0x27
  [<ffffffff802ff1ed>] ? jbd2_journal_commit_transaction+0x343/0xe6a
  [<ffffffff802411a8>] ? hrtimer_start+0x100/0x122
  [<ffffffff802357ba>] ? try_to_del_timer_sync+0x52/0x5b
  [<ffffffff80302972>] ? kjournald2+0xdf/0x202
  [<ffffffff8023e74a>] ? autoremove_wake_function+0x0/0x2e
  [<ffffffff80302893>] ? kjournald2+0x0/0x202
  [<ffffffff8023e43b>] ? kthread+0x47/0x73
  [<ffffffff8020bf78>] ? child_rip+0xa/0x12
  [<ffffffff8023e3f4>] ? kthread+0x0/0x73
  [<ffffffff8020bf6e>] ? child_rip+0x0/0x12


Code: 55 53 48 8b 47 18 48 89 fb 48 8b 28 65 48 8b 04 25 00 00 00 00 48 83 b8 d0 04 00 00 00 75 5f 48 8b 07 48 8b 55 68 f6 c4 08 75 04 <0f> 0b eb fe 48 89 d0 81 e2 ff 0f 00 00 48 8b 77 10 48 c1 f8 0c 
RIP  [<ffffffff802dd314>] ext4_da_writepage+0x30/0xf4
  RSP <ffff81027d737c10>
---[ end trace efaf3891d582feb1 ]---
SysRq : Show Blocked State
   task                        PC stack   pid father
pdflush       D 00000000ffffffff     0   242      2
  ffff81007f319bb8 0000000000000046 ffffffff8031682e 000000000000000e
  ffffffff80600cc0 000000000000000e ffff81007f319bf0 ffff81007fbbbd30
  ffff8101fff33210 ffff81007fbbbf68 00000002802aa2a6 ffff81007fbbbf68
Call Trace:
  [<ffffffff8031682e>] submit_bio+0xc4/0xcb
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fde7f>] jbd2_journal_stop+0x191/0x19d
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dd7e8>] ext4_da_writepages+0x75/0x173
  [<ffffffff80262112>] do_writepages+0x20/0x2d
  [<ffffffff8029f6da>] __writeback_single_inode+0x16f/0x35e
  [<ffffffff8029fcf7>] sync_sb_inodes+0x283/0x3b8
  [<ffffffff802a0080>] writeback_inodes+0x89/0xde
  [<ffffffff80262252>] wb_kupdate+0x9f/0x116
  [<ffffffff80262ca0>] pdflush+0x122/0x1c9
  [<ffffffff802621b3>] wb_kupdate+0x0/0x116
  [<ffffffff80262b7e>] pdflush+0x0/0x1c9
  [<ffffffff8023e43b>] kthread+0x47/0x73
  [<ffffffff8022ae6a>] schedule_tail+0x27/0x5c
  [<ffffffff8020bf78>] child_rip+0xa/0x12
  [<ffffffff8023e3f4>] kthread+0x0/0x73
  [<ffffffff8020bf6e>] child_rip+0x0/0x12

init_afd      D 00000000ffffffff     0  7974      1
  ffff8101050d3b30 0000000000000082 ffff810055f08230 0000000000080768
  ffffffff80600cc0 ffff8101ff8509c0 ffffffff802a38d5 ffff8101050aac80
  ffff8101fff342c0 ffff8101050aaeb8 000000038023e66b ffff8101050aaeb8
Call Trace:
  [<ffffffff802a38d5>] __find_get_block_slow+0xcf/0xdb
  [<ffffffff802fe4bb>] do_get_write_access+0x3ab/0x3ed
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80224a97>] __wake_up+0x38/0x4f
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8022a72f>] hrtick_set+0x8b/0x10a
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff80242fdc>] getnstimeofday+0x38/0x92
  [<ffffffff80240fcb>] lock_hrtimer_base+0x1b/0x3c
  [<ffffffff80241089>] hrtimer_try_to_cancel+0x61/0x6a
  [<ffffffff8024109e>] hrtimer_cancel+0xc/0x16
  [<ffffffff8046687e>] do_nanosleep+0x6c/0xa6
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

system_log    D 00000000ffffffff     0  7975   7974
  ffff81002d533ad0 0000000000000086 ffffffff8028fce8 ffff81007ed55e90
  ffffffff80600cc0 0000000000000100 ffff81027d7cae40 ffff81007ed55e90
  ffff8101fff342c0 ffff81007ed560c8 000000032d533f50 ffff81007ed560c8
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802dc663>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8026f499>] mmap_region+0x41a/0x505
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

receive_log   D 00000000ffffffff     0  7977   7974
  ffff81002d4ffad0 0000000000000082 ffffffff8028fce8 ffff81007ed55900
  ffffffff80600cc0 0000000000000100 ffff81007e86ed80 ffff81007ed55900
  ffffffff8054d350 ffff81007ed55b38 000000002d4fff50 ffff81007ed55b38
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802ec6a2>] __ext4_journal_dirty_metadata+0x1e/0x46
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff8028ad96>] do_lookup+0x63/0x1a1
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

archive_watch D 00000000ffffffff     0  7980   7974
  ffff81007ecabce0 0000000000000082 ffffffff802de7cd ffff810000000001
  ffffffff80600cc0 ffff810000000001 ffffffff8027ce42 ffff81007ed537a0
  ffff8101fff33210 ffff81007ed539d8 00000002802d9b7a ffff81007ed539d8
Call Trace:
  [<ffffffff802de7cd>] ext4_getblk+0xb4/0x170
  [<ffffffff8027ce42>] get_partial_node+0x15/0x78
  [<ffffffff80294b15>] __d_lookup+0xbd/0x107
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8028c917>] __link_path_walk+0x6e0/0xdd4
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e3350>] ext4_unlink+0x3f/0x1fe
  [<ffffffff8028b364>] may_delete+0x5e/0x135
  [<ffffffff8028b9af>] vfs_unlink+0x5e/0xa3
  [<ffffffff8028d985>] do_unlinkat+0xc1/0x142
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8020b26e>] tracesys+0x71/0xda
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

amg           D ffff81007e8b3cf8     0  7986   7974
  ffff81002d50bb60 0000000000000086 0000000000000000 0000000000000100
  ffffffff80600cc0 0000000000000000 0000000000000000 ffff81007ed50000
  ffff8101050acde0 ffff81007ed50238 0000000100000000 ffff81007ed50238
Call Trace:
  [<ffffffff80224f1d>] default_wake_function+0x0/0xe
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8028a28d>] pipe_write+0x4bc/0x4ce
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff8028d0ba>] path_walk+0xaf/0xb9
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     D ffff81007e8b1690     0  7988   7986
  ffff81002d625d70 0000000000000082 ffff81002d625d38 ffff81007edfcb00
  ffffffff80600cc0 0000000000000101 ffffffff80293dd5 ffff81007ed542c0
  ffff81007ed574d0 ffff81007ed544f8 000000028028c917 ffff81007ed544f8
Call Trace:
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff8028cee0>] __link_path_walk+0xca9/0xdd4
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028ac53>] lock_rename+0x35/0xc5
  [<ffffffff8028d545>] do_rename+0x98/0x1b2
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

afd_stat      D 00000000ffffffff     0  7989   7974
  ffff81002d461b30 0000000000000082 ffff81002d461da8 ffff81002d461da8
  ffffffff80600cc0 ffff81002d461da8 ffffffff802a38d5 ffff81007ed57a60
  ffffffff8054d350 ffff81007ed57c98 000000008023e66b ffff81007ed57c98
Call Trace:
  [<ffffffff802a38d5>] __find_get_block_slow+0xcf/0xdb
  [<ffffffff80290dfd>] __pollwait+0x0/0xe3
  [<ffffffff802fe4bb>] do_get_write_access+0x3ab/0x3ed
  [<ffffffff80242fdc>] getnstimeofday+0x38/0x92
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80262dda>] pdflush_operation+0x93/0x9d
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff8020ac45>] do_notify_resume+0x81f/0x840
  [<ffffffff802411a8>] hrtimer_start+0x100/0x122
  [<ffffffff802258bb>] hrtick_start_fair+0x139/0x18a
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

init_afd      D ffff81007e8b3cf8     0  7997      1
  ffff81027ee41b30 0000000000000086 ffff81027ee41dd0 ffff81027ee41da8
  ffffffff80600cc0 ffff81027ee41db8 0000000000000010 ffff81027ecca160
  ffff8101bbec1640 ffff81027ecca398 0000000000000000 ffff81027ecca398
Call Trace:
  [<ffffffff80290dfd>] __pollwait+0x0/0xe3
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

transfer_log  D 00000000ffffffff     0  8001   7997
  ffff81002d681ad0 0000000000000082 ffffffff8028fce8 ffff81007fb8f4d0
  ffffffff80600cc0 0000000000000100 ffff8101b1362540 ffff81007fb8f4d0
  ffff8101fff33210 ffff81007fb8f708 000000022d681f50 ffff81007fb8f708
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

archive_watch D 00000000ffffffff     0  8003   7997
  ffff81002d49dce0 0000000000000086 ffffffff802de7cd ffff810000000001
  ffffffff80600cc0 ffff810000000001 ffffffff8027ce42 ffff81007fb8ef40
  ffff8101fff32160 ffff81007fb8f178 00000001802d9b7a ffff81007fb8f178
Call Trace:
  [<ffffffff802de7cd>] ext4_getblk+0xb4/0x170
  [<ffffffff8027ce42>] get_partial_node+0x15/0x78
  [<ffffffff80294b15>] __d_lookup+0xbd/0x107
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8028c917>] __link_path_walk+0x6e0/0xdd4
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e3350>] ext4_unlink+0x3f/0x1fe
  [<ffffffff8028b364>] may_delete+0x5e/0x135
  [<ffffffff8028b9af>] vfs_unlink+0x5e/0xa3
  [<ffffffff8028d985>] do_unlinkat+0xc1/0x142
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8020b26e>] tracesys+0x71/0xda
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

input_log     D 00000000ffffffff     0  8004   7997
  ffff81002d419ad0 0000000000000086 ffffffff8028fce8 ffff81007fb8de90
  ffffffff80600cc0 0000000000000100 ffff81027f76aa80 ffff81007fb8de90
  ffff8101fff32160 ffff81007fb8e0c8 000000012d419f50 ffff81007fb8e0c8
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802dc663>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

output_log    D ffff81007e8b3cf8     0  8005   7997
  ffff81002d4fdad0 0000000000000086 ffffffff8028fce8 ffff81007fbbc2c0
  ffffffff80600cc0 0000000000000100 ffff81017ff649c0 ffff81007fbbc2c0
  ffff81001ce46420 ffff81007fbbc4f8 000000012d4fdf50 ffff81007fbbc4f8
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802dc663>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

production_lo D ffff81007e8b3cf8     0  8007   7997
  ffff81002d615ad0 0000000000000082 ffffffff8028fce8 ffff81007d939bd0
  ffffffff80600cc0 0000000000000100 ffff81027f76a3c0 ffff81007d939bd0
  ffff81007ed50590 ffff81007d939e08 000000012d615f50 ffff81007d939e08
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802dc663>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8026f499>] mmap_region+0x41a/0x505
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

distribution_ D 00000000ffffffff     0  8008   7997
  ffff81002d53fad0 0000000000000086 ffffffff8028fce8 ffff81007d93ac80
  ffffffff80600cc0 0000000000000100 ffff81007f300600 ffff81007d93ac80
  ffff8101fff33210 ffff81007d93aeb8 000000022d53ff50 ffff81007d93aeb8
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     D ffff81007e8b1690     0  8011   8009
  ffff8101e1359d70 0000000000000082 ffff8101e1359d38 ffff81007edfcb00
  ffffffff80600cc0 0000000000000101 ffffffff80293dd5 ffff8101bbec10b0
  ffff81007fb8de90 ffff8101bbec12e8 000000018028c917 ffff8101bbec12e8
Call Trace:
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff8028cee0>] __link_path_walk+0xca9/0xdd4
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028ac53>] lock_rename+0x35/0xc5
  [<ffffffff8028d545>] do_rename+0x98/0x1b2
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

afd_stat      D ffff81007e8b3cf8     0  8012   7997
  ffff81002d69bb30 0000000000000082 ffff81002d69bda8 ffff81002d69bda8
  ffffffff80600cc0 ffff81002d69bda8 ffffffff802a38d5 ffff81007d93c2c0
  ffff81027eccd900 ffff81007d93c4f8 000000008023e66b ffff81007d93c4f8
Call Trace:
  [<ffffffff802a38d5>] __find_get_block_slow+0xcf/0xdb
  [<ffffffff80290dfd>] __pollwait+0x0/0xe3
  [<ffffffff802fe4bb>] do_get_write_access+0x3ab/0x3ed
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80224a97>] __wake_up+0x38/0x4f
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff8020ac45>] do_notify_resume+0x81f/0x840
  [<ffffffff802411a8>] hrtimer_start+0x100/0x122
  [<ffffffff802258bb>] hrtick_start_fair+0x139/0x18a
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

init_afd      D 00000000ffffffff     0  8020      1
  ffff8101bbdd5b30 0000000000000086 ffff8101bbdd5dd0 ffff8101bbdd5da8
  ffffffff80600cc0 ffff8101bbdd5db8 0000000000000010 ffff8101bbec1640
  ffffffff8054d350 ffff8101bbec1878 0000000000000000 ffff8101bbec1878
Call Trace:
  [<ffffffff80290dfd>] __pollwait+0x0/0xe3
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

receive_log   D 00000000ffffffff     0  8023   8020
  ffff81027ee1bad0 0000000000000086 ffffffff8028fce8 ffff81027eccc2c0
  ffffffff80600cc0 0000000000000100 ffff81007f300000 ffff81027eccc2c0
  ffff8101fff33210 ffff81027eccc4f8 000000027ee1bf50 ffff81027eccc4f8
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802ec6a2>] __ext4_journal_dirty_metadata+0x1e/0x46
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff8028ad96>] do_lookup+0x63/0x1a1
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

transfer_log  D 00000000ffffffff     0  8024   8020
  ffff81027f799ad0 0000000000000086 ffffffff8028fce8 ffff81027eccc850
  ffffffff80600cc0 0000000000000100 ffff81027d7443c0 ffff81027eccc850
  ffffffff8054d350 ffff81027eccca88 000000007f799f50 ffff81027eccca88
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802dc663>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

archive_watch D 00000000ffffffff     0  8026   8020
  ffff81027f7ddce0 0000000000000082 ffffffff802de7cd ffff810200000001
  ffffffff80600cc0 ffff810000000001 ffffffff8027ce42 ffff81027ecc90b0
  ffff8101fff33210 ffff81027ecc92e8 00000002802d9b7a ffff81027ecc92e8
Call Trace:
  [<ffffffff802de7cd>] ext4_getblk+0xb4/0x170
  [<ffffffff8027ce42>] get_partial_node+0x15/0x78
  [<ffffffff80294b15>] __d_lookup+0xbd/0x107
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8028c917>] __link_path_walk+0x6e0/0xdd4
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e3350>] ext4_unlink+0x3f/0x1fe
  [<ffffffff8028b364>] may_delete+0x5e/0x135
  [<ffffffff8028b9af>] vfs_unlink+0x5e/0xa3
  [<ffffffff8028d985>] do_unlinkat+0xc1/0x142
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8020b26e>] tracesys+0x71/0xda
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

input_log     D ffff81007e8b3cf8     0  8027   8020
  ffff81027eed1ad0 0000000000000082 ffffffff8028fce8 ffff81027ecca6f0
  ffffffff80600cc0 0000000000000100 ffff81027d744e40 ffff81027ecca6f0
  ffff81007fb8de90 ffff81027ecca928 000000017eed1f50 ffff81027ecca928
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

output_log    D ffff81007e8b3cf8     0  8028   8020
  ffff81027d64dad0 0000000000000086 ffffffff8028fce8 ffff81027eccac80
  ffffffff80600cc0 0000000000000100 ffff81010508c840 ffff81027eccac80
  ffff81007ed574d0 ffff81027eccaeb8 000000027d64df50 ffff81027eccaeb8
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

distribution_ D 00000000ffffffff     0  8031   8020
  ffff81027ee1dad0 0000000000000086 ffffffff8028fce8 ffff81027ecc8590
  ffffffff80600cc0 0000000000000100 ffff810105128a80 ffff81027ecc8590
  ffff8101fff33210 ffff81027ecc87c8 000000027ee1df50 ffff81027ecc87c8
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8025c7ae>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802dc663>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a76>] touch_atime+0x12/0xfa
  [<ffffffff80224b5b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     D 00000000ffffffff     0  8034   8032
  ffff81027ec01d70 0000000000000082 ffff81027ec01d38 ffff81007edfcb00
  ffffffff80600cc0 0000000000000101 ffffffff80293dd5 ffff81027eccb210
  ffff8101fff33210 ffff81027eccb448 000000028028c917 ffff81027eccb448
Call Trace:
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff8028cee0>] __link_path_walk+0xca9/0xdd4
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028ac53>] lock_rename+0x35/0xc5
  [<ffffffff8028d545>] do_rename+0x98/0x1b2
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

afd_stat      D ffff81007e8b3cf8     0  8035   8020
  ffff81027edebb30 0000000000000082 ffff81027edebda8 ffff81027edebda8
  ffffffff80600cc0 ffff81027edebda8 ffffffff802a38d5 ffff81027eccd900
  ffff81007ed57a60 ffff81027eccdb38 000000008023e66b ffff81027eccdb38
Call Trace:
  [<ffffffff802a38d5>] __find_get_block_slow+0xcf/0xdb
  [<ffffffff80290dfd>] __pollwait+0x0/0xe3
  [<ffffffff802fe4bb>] do_get_write_access+0x3ab/0x3ed
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80224a97>] __wake_up+0x38/0x4f
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff8020ac45>] do_notify_resume+0x81f/0x840
  [<ffffffff802411a8>] hrtimer_start+0x100/0x122
  [<ffffffff802258bb>] hrtick_start_fair+0x139/0x18a
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

fd            D ffff81007e8b3cf8     0  8037   8020
  ffff81027ededb30 0000000000000086 ffff81027ededdd0 ffff81027ededda8
  ffffffff80600cc0 ffff81027ededdb8 00000000000007e0 ffff81027eccde90
  ffff81027ed937a0 ffff81027ecce0c8 0000000200000000 ffff81027ecce0c8
Call Trace:
  [<ffffffff80290dfd>] __pollwait+0x0/0xe3
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff8022f67f>] release_task+0x2cb/0x2dd
  [<ffffffff80230175>] do_wait+0xae4/0xb88
  [<ffffffff80286e19>] vfs_stat_fd+0x1b/0x4a
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

afd           D 00000000ffffffff     0 25970   2891
  ffff81017fae7ad0 0000000000000086 ffffffff8028fce8 0000000000000246
  ffffffff80600cc0 0000000000000100 ffff81020fe5dc00 ffff8101050ab210
  ffff8101fff342c0 ffff8101050ab448 000000037fae7f50 ffff8101050ab448
Call Trace:
  [<ffffffff8028fce8>] poll_freewait+0x36/0x87
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80268f85>] __do_fault+0x321/0x369
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80237d9a>] group_send_sig_info+0x62/0x6f
  [<ffffffff80237dd8>] kill_pid_info+0x31/0x3b
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b3cf8     0 26537   8037
  ffff8101ff7b1b70 0000000000000086 ffffffff802411a8 000000000000148d
  ffffffff80600cc0 0000000000000286 00000000ffffffff ffff8101bbec26f0
  ffff81027eccb210 ffff8101bbec2928 00000002ffffffff ffff8101bbec2928
Call Trace:
  [<ffffffff802411a8>] hrtimer_start+0x100/0x122
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff80466148>] thread_return+0x63/0xbb
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e2b08>] ext4_rename+0x4d/0x64a
  [<ffffffff804082ac>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8028bc5c>] vfs_rename+0x1fd/0x376
  [<ffffffff8028d5fe>] do_rename+0x151/0x1b2
  [<ffffffff802921db>] __posix_lock_file+0x43d/0x44e
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b1690     0 26543   8037
  ffff8101ddec3d70 0000000000000086 ffff8101ddec3d38 ffff81007edfcb00
  ffffffff80600cc0 0000000000000101 ffffffff80293dd5 ffff8101bbec3210
  ffff81007ed542c0 ffff8101bbec3448 000000028028c917 ffff8101bbec3448
Call Trace:
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff804082ac>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028ac53>] lock_rename+0x35/0xc5
  [<ffffffff8028d545>] do_rename+0x98/0x1b2
  [<ffffffff802921db>] __posix_lock_file+0x43d/0x44e
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b3cf8     0 26559   8037
  ffff8101b11ddb60 0000000000000086 ffff8101bfc0b4d0 0000000000000202
  ffffffff80600cc0 ffff8101bfc0b4d0 00007f1ea612f000 ffff8101bbec74d0
  ffff81007ed574d0 ffff8101bbec7708 0000000200000000 ffff8101bbec7708
Call Trace:
  [<ffffffff80224f1d>] default_wake_function+0x0/0xe
  [<ffffffff8042e751>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80467779>] error_exit+0x0/0x51
  [<ffffffff8025bae5>] find_lock_page+0x29/0x87
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8028a28d>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80273714>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d535>] unmap_region+0x10f/0x125
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 26569   8013
  ffff8101f40c1b60 0000000000000082 ffff81013b896b00 0000000000000206
  ffffffff80600cc0 ffff81013b896b00 00007f31838c7000 ffff8101bbec6f40
  ffff8101fff32160 ffff8101bbec7178 0000000100000000 ffff8101bbec7178
Call Trace:
  [<ffffffff80224f1d>] default_wake_function+0x0/0xe
  [<ffffffff8042e751>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80467779>] error_exit+0x0/0x51
  [<ffffffff8025bae5>] find_lock_page+0x29/0x87
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8028a28d>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80273714>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d535>] unmap_region+0x10f/0x125
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b3cf8     0 26583   8013
  ffff8101bbf9fb60 0000000000000086 ffff81010c703160 0000000000000202
  ffffffff80600cc0 ffff81010c703160 00007ffac6bd2000 ffff8101bbec6420
  ffff81007d93fa60 ffff8101bbec6658 0000000100000000 ffff8101bbec6658
Call Trace:
  [<ffffffff80224f1d>] default_wake_function+0x0/0xe
  [<ffffffff80411b14>] dev_queue_xmit+0x21a/0x232
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80467779>] error_exit+0x0/0x51
  [<ffffffff8025bae5>] find_lock_page+0x29/0x87
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8028a28d>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80273714>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d535>] unmap_region+0x10f/0x125
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D ffff810208bf59f8     0 26589  26567
  ffff810208bf59d8 0000000000000082 ffff810163233090 ffffffff802e9b05
  ffffffff80600cc0 ffffffff00058011 ffff810208bf5af8 ffff81027ecce420
  ffff81001ce40000 ffff81027ecce658 0000000208bf5b58 ffff81027ecce658
Call Trace:
  [<ffffffff802e9b05>] ext4_ext_find_extent+0x67/0x26f
  [<ffffffff80224a97>] __wake_up+0x38/0x4f
  [<ffffffff803023b0>] jbd2_log_wait_commit+0xb6/0x108
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80300c3c>] jbd2_log_do_checkpoint+0x12d/0x3bd
  [<ffffffff802a38d5>] __find_get_block_slow+0xcf/0xdb
  [<ffffffff802a3c4d>] __find_get_block+0x14c/0x15c
  [<ffffffff802a3c7b>] __getblk+0x1e/0x28d
  [<ffffffff802de7cd>] ext4_getblk+0xb4/0x170
  [<ffffffff802e6fb3>] ext4fs_dirhash+0x10d/0x1d2
  [<ffffffff802e04cf>] dx_probe+0xa1/0x29e
  [<ffffffff802e1b3a>] ext4_find_entry+0x293/0x592
  [<ffffffff80300f53>] __jbd2_log_wait_for_space+0x87/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8029535a>] d_alloc+0x1f/0x189
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e24bd>] ext4_create+0x4c/0x105
  [<ffffffff802e27c3>] ext4_lookup+0x97/0xc1
  [<ffffffff8028b805>] vfs_create+0x7d/0xed
  [<ffffffff8028e3ac>] do_filp_open+0x1ed/0x832
  [<ffffffff8028290c>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D ffff81007e8b3cf8     0 26595  26584
  ffff8101b1307ad0 0000000000000086 ffffffff8042530e ffff81014256f5d0
  ffffffff80600cc0 ffff81017fa8fa00 ffffffff80242fdc ffff8101ff6d8b20
  ffff81001ce46420 ffff8101ff6d8d58 000000018024153d ffff8101ff6d8d58
Call Trace:
  [<ffffffff8042530e>] nf_iterate+0x41/0x7d
  [<ffffffff80242fdc>] getnstimeofday+0x38/0x92
  [<ffffffff8039d0b6>] loopback_xmit+0x80/0x86
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D ffff81007e8b3cf8     0 26602  26590
  ffff81025dcf1c60 0000000000000082 ffffffff802e6fb3 0000000000000020
  ffffffff80600cc0 ffff81014256f090 00000000000300aa ffff81027ed942c0
  ffff81007d93e420 ffff81027ed944f8 000000017ae2b000 ffff81027ed944f8
Call Trace:
  [<ffffffff802e6fb3>] ext4fs_dirhash+0x10d/0x1d2
  [<ffffffff802e04cf>] dx_probe+0xa1/0x29e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e24bd>] ext4_create+0x4c/0x105
  [<ffffffff802e27c3>] ext4_lookup+0x97/0xc1
  [<ffffffff8028b805>] vfs_create+0x7d/0xed
  [<ffffffff8028e3ac>] do_filp_open+0x1ed/0x832
  [<ffffffff8028290c>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 26605   8013
  ffff81001cdc9b60 0000000000000086 ffff8101bfc0b4d0 0000000000000216
  ffffffff80600cc0 ffff8101bfc0b4d0 00007f628a734000 ffff81001ce43d30
  ffff8101fff33210 ffff81001ce43f68 0000000200000000 ffff81001ce43f68
Call Trace:
  [<ffffffff80224f1d>] default_wake_function+0x0/0xe
  [<ffffffff8042e751>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80467779>] error_exit+0x0/0x51
  [<ffffffff8025bae5>] find_lock_page+0x29/0x87
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8028a28d>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80273714>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d535>] unmap_region+0x10f/0x125
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b1690     0 26608   8013
  ffff81003eb4fd70 0000000000000082 ffff81003eb4fd38 ffff81007edfcb00
  ffffffff80600cc0 0000000000000101 ffffffff80293dd5 ffff81001ce43210
  ffff81001ce410b0 ffff81001ce43448 000000018028c917 ffff81001ce43448
Call Trace:
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff804082ac>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028ac53>] lock_rename+0x35/0xc5
  [<ffffffff8028d545>] do_rename+0x98/0x1b2
  [<ffffffff802921db>] __posix_lock_file+0x43d/0x44e
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b1690     0 26609   8013
  ffff81003eb63d70 0000000000000082 ffff81003eb63d38 ffff81007edfcb00
  ffffffff80600cc0 0000000000000101 ffffffff80293dd5 ffff81001ce442c0
  ffff81017faea160 ffff81001ce444f8 000000008028c917 ffff81001ce444f8
Call Trace:
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff804082ac>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028ac53>] lock_rename+0x35/0xc5
  [<ffffffff8028d545>] do_rename+0x98/0x1b2
  [<ffffffff802921db>] __posix_lock_file+0x43d/0x44e
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b1690     0 26610   8013
  ffff81003e98dd70 0000000000000082 ffff81003e98dd38 ffff81007edfcb00
  ffffffff80600cc0 0000000000000101 ffffffff80293dd5 ffff81001ce42c80
  ffff81017fae8590 ffff81001ce42eb8 000000028028c917 ffff81001ce42eb8
Call Trace:
  [<ffffffff80293dd5>] dput+0x21/0x10a
  [<ffffffff804082ac>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028ac53>] lock_rename+0x35/0xc5
  [<ffffffff8028d545>] do_rename+0x98/0x1b2
  [<ffffffff802921db>] __posix_lock_file+0x43d/0x44e
  [<ffffffff8027ce42>] get_partial_node+0x15/0x78
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 26611   8013
  ffff81001ced3b60 0000000000000082 ffff81002d7fa0d0 ffff81002d7fa0d0
  ffffffff80600cc0 00000000486202ae 0000000210e7c865 ffff81001ce41640
  ffffffff8054d350 ffff81001ce41878 0000000000000003 ffff81001ce41878
Call Trace:
  [<ffffffff80411b14>] dev_queue_xmit+0x21a/0x232
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8028a28d>] pipe_write+0x4bc/0x4ce
  [<ffffffff8028d0ba>] path_walk+0xaf/0xb9
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff80282afc>] __dentry_open+0x141/0x226
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 26613   8013
  ffff8101e1321b30 0000000000000082 0000000000000296 00000000662df001
  ffffffff80600cc0 ffff8101d40c9e90 ffffffff80242fdc ffff8101ff6dc850
  ffff8101fff33210 ffff8101ff6dca88 000000028024153d ffff8101ff6dca88
Call Trace:
  [<ffffffff80242fdc>] getnstimeofday+0x38/0x92
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffffa0070d34>] :nf_conntrack:nf_ct_deliver_cached_events+0x4d/0x7d
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff80269428>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aaed>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff80286f41>] cp_new_stat+0xe9/0xfc
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467779>] error_exit+0x0/0x51

vsftpd        D ffff81007e8b3cf8     0 26614  26606
  ffff8100588b1c90 0000000000000086 ffffffff802411a8 000000000000148d
  ffffffff80600cc0 0000000000000286 00000000ffffffff ffff81001ce40000
  ffff8101ff6dd900 ffff81001ce40238 00000002ffffffff ffff81001ce40238
Call Trace:
  [<ffffffff802411a8>] hrtimer_start+0x100/0x122
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff80466148>] thread_return+0x63/0xbb
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80296e64>] inode_setattr+0x103/0x10a
  [<ffffffff802dc9b0>] ext4_setattr+0x1eb/0x244
  [<ffffffff80296fbb>] notify_change+0x150/0x26d
  [<ffffffff80283568>] do_truncate+0x5e/0x79
  [<ffffffff80256c42>] audit_syscall_entry+0x11f/0x152
  [<ffffffff80283664>] sys_ftruncate+0xe1/0xfd
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

bzip2         D 00000000ffffffff     0 26616  26615
  ffff8102043d9ad0 0000000000000082 ffffffff80278233 ffff810256ebc660
  ffffffff80600cc0 00007f5eba717000 0000000000000002 ffff81027ed91640
  ffff8101fff342c0 ffff81027ed91878 000000038026a789 ffff81027ed91878
Call Trace:
  [<ffffffff80278233>] alloc_page_vma+0x154/0x221
  [<ffffffff802a3c7b>] __getblk+0x1e/0x28d
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80260c63>] rmqueue_bulk+0x42/0x8a
  [<ffffffff80266f91>] zone_statistics+0x3c/0x90
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80268f85>] __do_fault+0x321/0x369
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a745>] hrtick_set+0xa1/0x10a
  [<ffffffff80466148>] thread_return+0x63/0xbb
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff81007e8b3cf8     0 26621   8037
  ffff8101b1103b60 0000000000000082 ffff81013b896b00 0000000000000206
  ffffffff80600cc0 ffff81013b896b00 00007f4f1e28e000 ffff8101ff6df4d0
  ffff8101bbec6f40 ffff8101ff6df708 0000000100000000 ffff8101ff6df708
Call Trace:
  [<ffffffff80224f1d>] default_wake_function+0x0/0xe
  [<ffffffff8042e751>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80467779>] error_exit+0x0/0x51
  [<ffffffff8025bae5>] find_lock_page+0x29/0x87
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8028a28d>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80273714>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d535>] unmap_region+0x10f/0x125
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D ffff81007e8b3cf8     0 26625  26617
  ffff810039cf9b70 0000000000000082 ffff810270718a80 ffff81022646e2a0
  ffffffff80600cc0 ffff810039cf9d44 0000000000000000 ffff81001ce469b0
  ffff81001ce41640 ffff81001ce46be8 00000000802a3c7b ffff81001ce46be8
Call Trace:
  [<ffffffff802de7cd>] ext4_getblk+0xb4/0x170
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80294b15>] __d_lookup+0xbd/0x107
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e2b08>] ext4_rename+0x4d/0x64a
  [<ffffffff804082ac>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8028bc5c>] vfs_rename+0x1fd/0x376
  [<ffffffff8028d5fe>] do_rename+0x151/0x1b2
  [<ffffffff802614c3>] __alloc_pages_internal+0xd2/0x40c
  [<ffffffff80256944>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d6ab>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 00000000ffffffff     0 26632  26626
  ffff8101dddc3c60 0000000000000082 ffffffff802e6fb3 0000000000000020
  ffffffff80600cc0 ffff8101d40c8610 0000000000031014 ffff8101ff6dd900
  ffff8101fff33210 ffff8101ff6ddb38 000000021d4e6000 ffff8101ff6ddb38
Call Trace:
  [<ffffffff802e6fb3>] ext4fs_dirhash+0x10d/0x1d2
  [<ffffffff802e04cf>] dx_probe+0xa1/0x29e
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff8029925e>] mntput_no_expire+0x27/0x11e
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e24bd>] ext4_create+0x4c/0x105
  [<ffffffff802e27c3>] ext4_lookup+0x97/0xc1
  [<ffffffff8028b805>] vfs_create+0x7d/0xed
  [<ffffffff8028e3ac>] do_filp_open+0x1ed/0x832
  [<ffffffff8028290c>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 00000000ffffffff     0 26635  26633
  ffff8100066c9dd0 0000000000000086 ffffffff804082ac ffff8100066c9d34
  ffffffff80600cc0 0000000e9aa3566f ffff81007edfcbc8 ffff81007d93e420
  ffff8101fff32160 ffff81007d93e658 0000000100000000 ffff81007d93e658
Call Trace:
  [<ffffffff804082ac>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8028d0ba>] path_walk+0xaf/0xb9
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff8028e2cb>] do_filp_open+0x10c/0x832
  [<ffffffff80282837>] get_unused_fd_flags+0x7f/0x10e
  [<ffffffff8028290c>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

bzip2         D 00000000ffffffff     0 26638  26637
  ffff8101427cdad0 0000000000000082 ffffffff80278233 ffff8101f6fa70c0
  ffffffff80600cc0 00007f0c65f4e000 0000000000000002 ffff81017faec850
  ffffffff8054d350 ffff81017faeca88 000000008026a789 ffff81017faeca88
Call Trace:
  [<ffffffff80278233>] alloc_page_vma+0x154/0x221
  [<ffffffff802a3c7b>] __getblk+0x1e/0x28d
  [<ffffffff804666c5>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466561>] mutex_lock+0xa/0xb
  [<ffffffff80300f1e>] __jbd2_log_wait_for_space+0x52/0xac
  [<ffffffff802feac7>] start_this_handle+0x2eb/0x370
  [<ffffffff80260c63>] rmqueue_bulk+0x42/0x8a
  [<ffffffff802fecae>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dc772>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a00fe>] __mark_inode_dirty+0x29/0x187
  [<ffffffff80295a1f>] file_update_time+0xaf/0xf4
  [<ffffffff8025d031>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80268f85>] __do_fault+0x321/0x369
  [<ffffffff8025d815>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9d8c>] ext4_file_write+0x96/0x11a
  [<ffffffff80283eb3>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e74a>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a72f>] hrtick_set+0x8b/0x10a
  [<ffffffff80466148>] thread_return+0x63/0xbb
  [<ffffffff802846d8>] vfs_write+0xad/0x136
  [<ffffffff8028481d>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

I used ext4-patch-queue-b5db22ef52ed53d8e3fa978a5a29e1609c9333aa.tar.gz and
a clean linux-2.6.26-rc6 with no other patches.

Holger

