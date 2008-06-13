From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Fri, 13 Jun 2008 08:05:12 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
 <20080611105945.GB9008@skywalker> <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
 <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
 <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
 <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu>
 <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker>
 <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:49244 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbYFMIFW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2008 04:05:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by node6.dwd.de (Postfix) with ESMTP id 1E792C58409
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 08:05:19 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node6.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 24692-27 for <linux-ext4@vger.kernel.org>;
	Fri, 13 Jun 2008 08:05:18 +0000 (UTC)
In-Reply-To: <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 Jun 2008, Holger Kiehl wrote:

> On Thu, 12 Jun 2008, Aneesh Kumar K.V wrote:
>
>> On Thu, Jun 12, 2008 at 02:07:30PM +0000, Holger Kiehl wrote:
>>> This time there is no OOPS and system is still up running without any
>>> problem (except any process wanting to write something to this filesystem
>>> gets stuck forever).
>>> 
>>> What can I do to help find the problem? The system is still up with all 
>>> those
>>> process hanging in D-state.
>>> 
>> 
>> if you can login to the system get the dmesg output after
>> 
>> echo t > /proc/sysrq-trigger
>> 
> Unfortunately I have not set CONFIG_MAGIC_SYSRQ. Tomorrow I will try to
> reproduce this with a kernel that has CONFIG_MAGIC_SYSRQ set.
>
After recompiling, rebooting and run afdbench first I got an OOPS and the
system hanged up solid. The only thing I was able to catch is this:

   RIP [<ffffffff803019f9>] jbd2_journal_release_jbd_inode+0xcb/0x100
   RSP <ffff8101fe259c18>

This was copied by hand. And this I cut 'cut and past' from my terminal:

kernel: Code: c3 e8 31 ce f3 ff 41 fe 04 24 e8 fe 3f 16 00 4c 89 fe 48 89 df e8 5f cd f3 ff eb 82 48 83 7d 00 00 74 27 48 8b 55 10 48 8b 45 18 <48> 89 42 08 48 89 10 48 c7 45 18 00 02 20 00 48 c7 45 10 00 01

So I rebooted run bonnie and then afdbench and I get the same problem as
yesterday. All process trying to write something to this filesystem hang
in D-state. But now I was able to do the echo t > /proc/sysrq-trigger.
Here the dmesg output:

node_dirty+0x134/0x147
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8025cfb5>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a4e>] touch_atime+0x12/0xfa
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d799>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9ed8>] ext4_file_write+0x96/0x11a
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a715>] hrtick_set+0xa1/0x10a
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

trans_db_log  S 00000000ffffffff     0  8010   8005
  ffff81016f58d9e8 0000000000000082 0000000000000002 0000000000000000
  ffffffff80600cc0 ffff810180001600 0000000000000000 ffff81017f6c1640
  ffff81007fb43210 ffff81017f6c1878 0000000280266f65 ffff81017f6c1878
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802dca1c>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802ec6aa>] __ext4_journal_dirty_metadata+0x1e/0x46
  [<ffffffff8023e617>] bit_waitqueue+0x10/0xa0
  [<ffffffff802fe4d7>] do_get_write_access+0x3ab/0x3ed
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff8025ba69>] find_lock_page+0x29/0x87
  [<ffffffff8025c094>] filemap_fault+0x1cb/0x329
  [<ffffffff80268f59>] __do_fault+0x321/0x369
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff8026a7dc>] handle_mm_fault+0x348/0x6a3
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8028e58a>] do_filp_open+0x3f2/0x832
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

archive_watch S 00000000ffffffff     0  8011   8005
  ffff81017f79b9e8 0000000000000086 ffff810000002618 0000000100000000
  ffffffff80600cc0 0000000000000000 ffff810000002608 ffff81017f6c10b0
  ffffffff8054d350 ffff81017f6c12e8 0000000000001580 ffff81017f6c12e8
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802a3be1>] __find_get_block+0x14c/0x15c
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff802de7f2>] ext4_getblk+0xb4/0x170
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff80294aed>] __d_lookup+0xbd/0x107
  [<ffffffff802e6fbf>] ext4fs_dirhash+0x10d/0x1d2
  [<ffffffff802d9d81>] ext4_htree_store_dirent+0xe6/0xf1
  [<ffffffff802e3745>] htree_dirblock_to_tree+0x12c/0x13e
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff8028f91c>] filldir+0x68/0xb7
  [<ffffffff8028f8b4>] filldir+0x0/0xb7
  [<ffffffff802d9938>] ext4_readdir+0x1c1/0x524
  [<ffffffff8028f8b4>] filldir+0x0/0xb7
  [<ffffffff8028e572>] do_filp_open+0x3da/0x832
  [<ffffffff80286f15>] cp_new_stat+0xe9/0xfc
  [<ffffffff802985f0>] mnt_want_write+0x25/0x77
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

input_log     D 00000000ffffffff     0  8012   8005
  ffff81017f79db58 0000000000000086 0000000000000008 0000000000000000
  ffffffff80600cc0 0000000000000008 0000000000000000 ffff81017f6c5370
  ffff81007fb442c0 ffff81017f6c55a8 0000000380290dd5 ffff81017f6c55a8
Call Trace:
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802dca1c>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8025cfb5>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a4e>] touch_atime+0x12/0xfa
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d799>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9ed8>] ext4_file_write+0x96/0x11a
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a715>] hrtick_set+0xa1/0x10a
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

output_log    D 00000000ffffffff     0  8013   8005
  ffff81016f7b9b58 0000000000000086 0000000000000008 0000000000000000
  ffffffff80600cc0 0000000000000008 0000000000000000 ffff81017f6c4de0
  ffff81007fb42160 ffff81017f6c5018 0000000180290dd5 ffff81017f6c5018
Call Trace:
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802dca1c>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8025cfb5>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff80295a4e>] touch_atime+0x12/0xfa
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8025d799>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9ed8>] ext4_file_write+0x96/0x11a
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a715>] hrtick_set+0xa1/0x10a
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

delete_log    S 0000000000000000     0  8014   8005
  ffff81017f7099e8 0000000000000086 0000000000000002 0000000000000000
  ffffffff80600cc0 ffff810000002600 0000000000000000 ffff81017f6c26f0
  ffff81017f784850 ffff81017f6c2928 0000000080266f65 ffff81017f6c2928
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802dca1c>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802ec6aa>] __ext4_journal_dirty_metadata+0x1e/0x46
  [<ffffffff80266f65>] zone_statistics+0x3c/0x90
  [<ffffffff8026112c>] get_page_from_freelist+0x461/0x5d5
  [<ffffffff80266f65>] zone_statistics+0x3c/0x90
  [<ffffffff8026112c>] get_page_from_freelist+0x461/0x5d5
  [<ffffffff80261447>] __alloc_pages_internal+0xd2/0x40c
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff8026a75d>] handle_mm_fault+0x2c9/0x6a3
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8026f46b>] mmap_region+0x41a/0x505
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

production_lo S 00000000ffffffff     0  8015   8005
  ffff81017f70b9e8 0000000000000082 0000000000000002 0000000000000000
  ffffffff80600cc0 ffff810200001600 0000000000000000 ffff81017f6c42c0
  ffff81007fb43210 ffff81017f6c44f8 00000002794b5d20 ffff81017f6c44f8
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802e6dc1>] __ext4_journal_stop+0x1f/0x3d
  [<ffffffff802a0156>] __mark_inode_dirty+0xed/0x187
  [<ffffffff8025c732>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802a0156>] __mark_inode_dirty+0xed/0x187
  [<ffffffff8025d09a>] __generic_file_aio_write_nolock+0x34a/0x37e
  [<ffffffff80268f59>] __do_fault+0x321/0x369
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8026f46b>] mmap_region+0x41a/0x505
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

distribution_ S 00000000ffffffff     0  8016   8005
  ffff81016f5959e8 0000000000000086 0000000000080780 ffffe20008ba3f98
  ffffffff80600cc0 ffffffff802a3869 0000fee20000011d ffff81017f6c3d30
  ffff81007fb442c0 ffff81017f6c3f68 00000003794b5d20 ffff81017f6c3f68
Call Trace:
  [<ffffffff802a3869>] __find_get_block_slow+0xcf/0xdb
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802e6dc1>] __ext4_journal_stop+0x1f/0x3d
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff8025c732>] generic_file_buffered_write+0x22c/0x658
  [<ffffffff802dca1c>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff8023136c>] current_fs_time+0x1e/0x24
  [<ffffffff8025b358>] remove_suid+0x18/0x4b
  [<ffffffff8025d09a>] __generic_file_aio_write_nolock+0x34a/0x37e
  [<ffffffff80295a4e>] touch_atime+0x12/0xfa
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022a715>] hrtick_set+0xa1/0x10a
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

amg           S 00000000ffffffff     0  8017   8005
  ffff81016f5e59e8 0000000000000082 ffff81023ec9a070 0000000000000282
  ffffffff80600cc0 ffff81007f2e4ac0 0000000000011210 ffff81017f6c37a0
  ffffffff8054d350 ffff81017f6c39d8 0000000000000040 ffff81017f6c39d8
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff80266f65>] zone_statistics+0x3c/0x90
  [<ffffffff80294aed>] __d_lookup+0xbd/0x107
  [<ffffffff8028ad6a>] do_lookup+0x63/0x1a1
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff80294aed>] __d_lookup+0xbd/0x107
  [<ffffffff8028ad6a>] do_lookup+0x63/0x1a1
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff8028cebc>] __link_path_walk+0xcb1/0xdd9
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff8028c1a9>] getname+0x13e/0x1a0
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff8023e876>] remove_wait_queue+0x12/0x41
  [<ffffffff80230135>] do_wait+0xae4/0xb88
  [<ffffffff80286f15>] cp_new_stat+0xe9/0xfc
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

afdd          S 00000000ffffffff     0  8018   8005
  ffff81016f5e79e8 0000000000000086 ffff810200001618 0000000200000000
  ffffffff80600cc0 0000000000000000 ffff810200001608 ffff81017f6c0000
  ffff81007fb442c0 ffff81017f6c0238 0000000300000b00 ffff81017f6c0238
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff8036750a>] extract_buf+0x84/0xfc
  [<ffffffff80367166>] mix_pool_bytes_extract+0x58/0x148
  [<ffffffff8036750a>] extract_buf+0x84/0xfc
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff80367476>] account+0xd6/0xe6
  [<ffffffff80224a67>] __wake_up+0x38/0x4f
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     D ffff810027160690     0  8019   8017
  ffff81007e8b1d70 0000000000000086 ffff81007e8b1d38 ffff81007e8a0e00
  ffffffff80600cc0 0000000000000000 ffffffff80293dad ffff8100707910b0
  ffff8100469a2160 ffff8100707912e8 000000028028c8f9 ffff8100707912e8
Call Trace:
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff8028cebc>] __link_path_walk+0xcb1/0xdd9
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028ac27>] lock_rename+0x35/0xc5
  [<ffffffff8028d51e>] do_rename+0x98/0x1b2
  [<ffffffff80286f15>] cp_new_stat+0xe9/0xfc
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d684>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

afd_stat      S 00000000ffffffff     0  8020   8005
  ffff81016f7fd9e8 0000000000000086 0000000000000000 000000000009829c
  ffffffff80600cc0 ffffffff80323d50 ffff810201e124a0 ffff81017f6c0590
  ffff81007fb442c0 ffff81017f6c07c8 0000000300000000 ffff81017f6c07c8
Call Trace:
  [<ffffffff80323d50>] rb_insert_color+0x66/0xe2
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff8023e617>] bit_waitqueue+0x10/0xa0
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff802fe4d7>] do_get_write_access+0x3ab/0x3ed
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff8023e724>] wake_bit_function+0x0/0x23
  [<ffffffff802ec6aa>] __ext4_journal_dirty_metadata+0x1e/0x46
  [<ffffffff802dbbee>] ext4_mark_iloc_dirty+0x415/0x47e
  [<ffffffff802dca1c>] ext4_mark_inode_dirty+0x134/0x147
  [<ffffffff802db3e9>] walk_page_buffers+0x65/0x8b
  [<ffffffff802db568>] ext4_bh_unmapped+0x0/0xe
  [<ffffffff80324411>] __up_read+0x13/0x8a
  [<ffffffff80322db6>] __prop_inc_single+0x1d/0x36
  [<ffffffff8026941e>] do_wp_page+0x47d/0x4ba
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff8026aac1>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8022a715>] hrtick_set+0xa1/0x10a
  [<ffffffff80324411>] __up_read+0x13/0x8a
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8020ac45>] do_notify_resume+0x81f/0x840
  [<ffffffff80286f15>] cp_new_stat+0xe9/0xfc
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

fd            S 00000000ffffffff     0  8021   8005
  ffff81016f5139e8 0000000000000082 0000000000000000 0000000000000000
  ffffffff80600cc0 0000000000000001 0000000180001608 ffff81017f6c3210
  ffff81007fb442c0 ffff81017f6c3448 0000000300000b00 ffff81017f6c3448
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff80294aed>] __d_lookup+0xbd/0x107
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff8028cfc6>] __link_path_walk+0xdbb/0xdd9
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff8028c1a9>] getname+0x13e/0x1a0
  [<ffffffff8028de4c>] __user_walk_fd+0x41/0x4c
  [<ffffffff80286ded>] vfs_stat_fd+0x1b/0x4a
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

show_bench_st S 00000000ffffffff     0  8043   2879
  ffff810023a77ea8 0000000000000082 00007fff24bbfe80 00007f631cabd000
  ffffffff80600cc0 ffffffff80242f85 ffff810023a77ed8 ffff810070793d30
  ffff81007fb43210 ffff810070793f68 0000000200000000 ffff810070793f68
Call Trace:
  [<ffffffff80242f85>] getnstimeofday+0x38/0x84
  [<ffffffff80241154>] hrtimer_start+0x100/0x122
  [<ffffffff80241035>] hrtimer_try_to_cancel+0x61/0x6a
  [<ffffffff80466799>] do_nanosleep+0x64/0xa6
  [<ffffffff802411ca>] hrtimer_nanosleep+0x54/0xbf
  [<ffffffff80240ab2>] hrtimer_wakeup+0x0/0x22
  [<ffffffff80241281>] sys_nanosleep+0x4c/0x62
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

tee           D 0000000000000000     0  8044   2879
  ffff810046939b58 0000000000000086 ffff81001af65240 ffff810049075630
  ffffffff80600cc0 ffffffff80324411 ffff810049075630 ffff8100707942c0
  ffff81007e84de90 ffff8100707944f8 00000000ff8254a0 ffff8100707944f8
Call Trace:
  [<ffffffff80324411>] __up_read+0x13/0x8a
  [<ffffffff80268f59>] __do_fault+0x321/0x369
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8025cfb5>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff8025d799>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9ed8>] ext4_file_write+0x96/0x11a
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8036a969>] tty_write+0x200/0x21b
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     ? ffff810070796518     0  8413   8019
  ffff81003453bef8 0000000000000046 ffff810070462908 0000000000000056
  ffffffff80600cc0 ffffffff80237be4 0000000000000011 ffff810070796420
  ffff81017f6c42c0 ffff810070796658 0000000200000000 ffff810070796658
Call Trace:
  [<ffffffff80237be4>] do_notify_parent+0x18c/0x199
  [<ffffffff8023096d>] do_exit+0x661/0x665
  [<ffffffff802309d7>] do_group_exit+0x66/0x93
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     ? ffff810070796aa8     0  8415   8019
  ffff8100492c9ef8 0000000000000046 ffff810070462908 0000000000000056
  ffffffff80600cc0 ffffffff80237be4 0000000000000011 ffff8100707969b0
  ffff8101ff6fbd30 ffff810070796be8 0000000000000000 ffff810070796be8
Call Trace:
  [<ffffffff80237be4>] do_notify_parent+0x18c/0x199
  [<ffffffff8023096d>] do_exit+0x661/0x665
  [<ffffffff802309d7>] do_group_exit+0x66/0x93
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     ? ffff81016f416aa8     0  8460   7996
  ffff81016f6c1ef8 0000000000000046 ffff810070461048 0000000000000056
  ffffffff80600cc0 ffffffff80237be4 0000000000000011 ffff81016f4169b0
  ffff81017f7826f0 ffff81016f416be8 0000000100000000 ffff81016f416be8
Call Trace:
  [<ffffffff80237be4>] do_notify_parent+0x18c/0x199
  [<ffffffff8023096d>] do_exit+0x661/0x665
  [<ffffffff802309d7>] do_group_exit+0x66/0x93
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     ? ffff81016f417038     0  8463   7996
  ffff81016f429ef8 0000000000000046 ffff810070461048 0000000000000056
  ffffffff80600cc0 ffffffff80237be4 0000000000000011 ffff81016f416f40
  ffff81027759d370 ffff81016f417178 0000000100000003 ffff81016f417178
Call Trace:
  [<ffffffff80237be4>] do_notify_parent+0x18c/0x199
  [<ffffffff8023096d>] do_exit+0x661/0x665
  [<ffffffff802309d7>] do_group_exit+0x66/0x93
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     ? ffff810070790c18     0  8492   7973
  ffff81002382def8 0000000000000046 ffff8101ff70fb88 0000000000000056
  ffffffff80600cc0 ffffffff80237be4 0000000000000011 ffff810070790b20
  ffff81027f148000 ffff810070790d58 0000000100000000 ffff810070790d58
Call Trace:
  [<ffffffff80237be4>] do_notify_parent+0x18c/0x199
  [<ffffffff8023096d>] do_exit+0x661/0x665
  [<ffffffff802309d7>] do_group_exit+0x66/0x93
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

dir_check     ? 00000000ffffffff     0  8515   7973
  ffff81006e4a7ef8 0000000000000046 ffff8101ff70fb88 0000000000000056
  ffffffff80600cc0 ffffffff80237be4 0000000000000011 ffff810070791640
  ffff81007fb43210 ffff810070791878 0000000200000000 ffff810070791878
Call Trace:
  [<ffffffff80237be4>] do_notify_parent+0x18c/0x199
  [<ffffffff8023096d>] do_exit+0x661/0x665
  [<ffffffff802309d7>] do_group_exit+0x66/0x93
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 0000000000000000     0  9928   8021
  ffff81027851fbe8 0000000000000086 ffff81017f72de90 0000000300000000
  ffffffff80600cc0 0000000000000000 0000000000000000 ffff81027f2bcde0
  ffff81017f6c1bd0 ffff81027f2bd018 0000000100000000 ffff81027f2bd018
Call Trace:
  [<ffffffffa0068801>] :nf_conntrack:nf_conntrack_in+0x455/0x508
  [<ffffffff804674e1>] _read_lock_bh+0x9/0x19
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8028a261>] pipe_write+0x4bc/0x4ce
  [<ffffffff8028d093>] path_walk+0xaf/0xb9
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff80282ad0>] __dentry_open+0x141/0x226
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff810052a38000     0  9929   2487
  ffff810046a57bc8 0000000000000086 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff8100469a37a0
  ffff8101b97f8590 ffff8100469a39d8 0000000100000001 ffff8100469a39d8
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 00000000ffffffff     0  9937   9929
  ffff8101f8e99dd0 0000000000000086 ffffffff8040820c ffff8101f8e99d34
  ffffffff80600cc0 0000000ed348224f ffff81007e8a0ec8 ffff8101b97f8590
  ffff81007fb42160 ffff8101b97f87c8 0000000100000000 ffff8101b97f87c8
Call Trace:
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8028d093>] path_walk+0xaf/0xb9
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028e2a4>] do_filp_open+0x10c/0x832
  [<ffffffff8028280b>] get_unused_fd_flags+0x7f/0x10e
  [<ffffffff802828e0>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 0000000000000000     0  9945   8021
  ffff81027f295be8 0000000000000082 ffff81007e856290 ffffffff8042e6b5
  ffffffff80600cc0 ffff81027f295b90 ffff8100370343f0 ffff81027f2bd900
  ffff81027f2ba160 ffff81027f2bdb38 0000000037008438 ffff81027f2bdb38
Call Trace:
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022595b>] check_preempt_wakeup+0x7f/0xbc
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8028a261>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802736e8>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d509>] unmap_region+0x10f/0x125
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff81016f680000     0  9946   2487
  ffff8100706ddbc8 0000000000000082 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff8100469a5900
  ffff81016f4137a0 ffff8100469a5b38 0000000000000001 ffff8100469a5b38
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 00000000ffffffff     0  9949   9946
  ffff810147d79dd0 0000000000000082 ffffffff8040820c ffff810147d79d34
  ffffffff80600cc0 0000000ed34681af ffff81007e8a0ec8 ffff81016f4137a0
  ffffffff8054d350 ffff81016f4139d8 0000000000000000 ffff81016f4139d8
Call Trace:
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8028d093>] path_walk+0xaf/0xb9
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028e2a4>] do_filp_open+0x10c/0x832
  [<ffffffff8028280b>] get_unused_fd_flags+0x7f/0x10e
  [<ffffffff802828e0>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff8101ff703c80     0  9959   2487
  ffff8101865c7bc8 0000000000000086 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff8101b97ff4d0
  ffff81016f4137a0 ffff8101b97ff708 0000000000000001 ffff8101b97ff708
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D ffff81007e85a400     0  9961   9959
  ffff8101b9793c08 0000000000000082 000000000002842a ffff8101b9793d84
  ffffffff80600cc0 0000000000000000 ffff81027a138ea0 ffff8101b97f90b0
  ffff8101b97ff4d0 ffff8101b97f92e8 0000000000000001 ffff8101b97f92e8
Call Trace:
  [<ffffffff802e6fbf>] ext4fs_dirhash+0x10d/0x1d2
  [<ffffffff803019dd>] jbd2_journal_release_jbd_inode+0xaf/0x100
  [<ffffffff8023e724>] wake_bit_function+0x0/0x23
  [<ffffffff802d7d9b>] ext4_discard_reservation+0x1e/0x5a
  [<ffffffff80296488>] clear_inode+0x69/0xc0
  [<ffffffff80296afd>] generic_drop_inode+0x13a/0x157
  [<ffffffff802db069>] ext4_new_inode+0xc46/0xcac
  [<ffffffff802feabf>] start_this_handle+0x2c7/0x370
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff802e251d>] ext4_create+0x88/0x105
  [<ffffffff802e27e7>] ext4_lookup+0x97/0xc1
  [<ffffffff8028b7d9>] vfs_create+0x7d/0xed
  [<ffffffff8028e385>] do_filp_open+0x1ed/0x832
  [<ffffffff802828e0>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 0000000000000000     0  9969   8021
  ffff8102785bfbe8 0000000000000082 ffff81017f72dcd0 ffffffff8042e6b5
  ffffffff80600cc0 0000000000000000 0000000000000000 ffff81027f2bbd30
  ffff81017f6c1bd0 ffff81027f2bbf68 000000019740516a ffff81027f2bbf68
Call Trace:
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022595b>] check_preempt_wakeup+0x7f/0xbc
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8028a261>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802736e8>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d509>] unmap_region+0x10f/0x125
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S 00000000ffffffff     0  9970   2487
  ffff810224881bc8 0000000000000082 00000000008db1fc ffffffff80241310
  ffffffff80600cc0 0000000000000001 ffffffff80266f65 ffff81027f2bb7a0
  ffff81007fb442c0 ffff81027f2bb9d8 000000037f2bc888 ffff81027f2bb9d8
Call Trace:
  [<ffffffff80241310>] ktime_get_ts+0x21/0x4a
  [<ffffffff80266f65>] zone_statistics+0x3c/0x90
  [<ffffffff80266f65>] zone_statistics+0x3c/0x90
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8021eee3>] do_page_fault+0x60c/0x825
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff80467699>] error_exit+0x0/0x51
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D ffff81027a138f60     0  9973   9970
  ffff81022cadfdd0 0000000000000086 0000000000000000 ffff810200000000
  ffffffff80600cc0 0000000f13fc4c86 ffff81007e8a0ec8 ffff81027f2bf4d0
  ffff81027f2bb7a0 ffff81027f2bf708 0000000300000000 ffff81027f2bf708
Call Trace:
  [<ffffffff8028d093>] path_walk+0xaf/0xb9
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028e2a4>] do_filp_open+0x10c/0x832
  [<ffffffff8028280b>] get_unused_fd_flags+0x7f/0x10e
  [<ffffffff802828e0>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff810027160690     0  9979   8021
  ffff81022e071d70 0000000000000086 ffff81022e071d38 ffff81007e8a0e00
  ffffffff80600cc0 0000000000000000 ffffffff80293dad ffff81027f2bc850
  ffff81016f416420 ffff81027f2bca88 000000018028c8f9 ffff81027f2bca88
Call Trace:
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028ac27>] lock_rename+0x35/0xc5
  [<ffffffff8028d51e>] do_rename+0x98/0x1b2
  [<ffffffff802921b3>] __posix_lock_file+0x43d/0x44e
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d684>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff81016f683c80     0  9981   2487
  ffff81016f4f9bc8 0000000000000082 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff81016f416420
  ffff81017f6c4de0 ffff81016f416658 0000000100000001 ffff81016f416658
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S 00007f17790fc000     0  9984   9981
  ffff81016f555b68 0000000000000086 ffff81017f72de90 ffffffff802414e9
  ffffffff80600cc0 000000000f4c63de 0000000000000046 ffff81016f417a60
  ffff81027f2bc850 ffff81016f417c98 000000017f72de90 ffff81016f417c98
Call Trace:
  [<ffffffff802414e9>] ktime_get_real+0xc/0x43
  [<ffffffff80231c26>] local_bh_enable+0x6a/0x7c
  [<ffffffff80411a78>] dev_queue_xmit+0x21a/0x232
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff804674fa>] _spin_lock_bh+0x9/0x1f
  [<ffffffff80408cba>] release_sock+0x13/0x95
  [<ffffffff80409265>] sk_wait_data+0x83/0xc6
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80434547>] tcp_recvmsg+0x3b3/0x7d2
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80406a49>] sock_recvmsg+0xd5/0xed
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80242f85>] getnstimeofday+0x38/0x84
  [<ffffffff80406509>] sockfd_lookup_light+0x1a/0x52
  [<ffffffff80407a7d>] sys_recvfrom+0xc3/0x122
  [<ffffffff80241154>] hrtimer_start+0x100/0x122
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff810027160690     0 10194   7998
  ffff810186669d70 0000000000000086 ffff810186669d38 ffff81007e8a0e00
  ffffffff80600cc0 0000000000000000 ffffffff80293dad ffff8101b97fb210
  ffff81027f149bd0 ffff8101b97fb448 000000028028c8f9 ffff8101b97fb448
Call Trace:
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028ac27>] lock_rename+0x35/0xc5
  [<ffffffff8028d51e>] do_rename+0x98/0x1b2
  [<ffffffff802921b3>] __posix_lock_file+0x43d/0x44e
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d684>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff8101fff33700     0 10195   2487
  ffff81016f625bc8 0000000000000086 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff81016f414850
  ffff8101b97fef40 ffff81016f414a88 0000000200000001 ffff81016f414a88
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S 00007f17790fc000     0 10197  10195
  ffff8101ff7f1b68 0000000000000086 ffff8101867b4450 ffffffff802414e9
  ffffffff80600cc0 000000000f5245fe 0000000000000046 ffff8101b97fd900
  ffff8101b97fb210 ffff8101b97fdb38 00000002867b4450 ffff8101b97fdb38
Call Trace:
  [<ffffffff802414e9>] ktime_get_real+0xc/0x43
  [<ffffffff80231c26>] local_bh_enable+0x6a/0x7c
  [<ffffffff80411a78>] dev_queue_xmit+0x21a/0x232
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff804674fa>] _spin_lock_bh+0x9/0x1f
  [<ffffffff80408cba>] release_sock+0x13/0x95
  [<ffffffff80409265>] sk_wait_data+0x83/0xc6
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80434547>] tcp_recvmsg+0x3b3/0x7d2
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80406a49>] sock_recvmsg+0xd5/0xed
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80242f85>] getnstimeofday+0x38/0x84
  [<ffffffff80406509>] sockfd_lookup_light+0x1a/0x52
  [<ffffffff80407a7d>] sys_recvfrom+0xc3/0x122
  [<ffffffff80241154>] hrtimer_start+0x100/0x122
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        S 0000000000000000     0 10198   7975
  ffff81007054f9e8 0000000000000086 ffff8101f8f1e310 9c9ba13000000834
  ffffffff80600cc0 000000038023e617 ffff8101db55d930 ffff8100469a5370
  ffff8100469a10b0 ffff8100469a55a8 00000002867b5cd0 ffff8100469a55a8
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80411a78>] dev_queue_xmit+0x21a/0x232
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffffa0068801>] :nf_conntrack:nf_conntrack_in+0x455/0x508
  [<ffffffff804674e1>] _read_lock_bh+0x9/0x19
  [<ffffffffa00634f5>] :ip_tables:ipt_do_table+0x2e9/0x30c
  [<ffffffffa006bd34>] :nf_conntrack:nf_ct_deliver_cached_events+0x4d/0x7d
  [<ffffffffa007937e>] :nf_conntrack_ipv4:ipv4_confirm+0xcc/0xd7
  [<ffffffff80425272>] nf_iterate+0x41/0x7d
  [<ffffffff80242f85>] getnstimeofday+0x38/0x84
  [<ffffffff8042ea4b>] ip_finish_output+0x0/0x239
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff80231c26>] local_bh_enable+0x6a/0x7c
  [<ffffffff802985f0>] mnt_want_write+0x25/0x77
  [<ffffffff80295a4e>] touch_atime+0x12/0xfa
  [<ffffffff80408dd6>] lock_sock_nested+0x9a/0xa5
  [<ffffffff804674fa>] _spin_lock_bh+0x9/0x1f
  [<ffffffff80408cba>] release_sock+0x13/0x95
  [<ffffffff8023e617>] bit_waitqueue+0x10/0xa0
  [<ffffffff8023e6e5>] wake_up_bit+0x11/0x22
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff810052a3b700     0 10199   2487
  ffff810147c4fbc8 0000000000000082 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 ffff810181e11cc0 ffff81016f412160
  ffff8100469a10b0 ffff81016f412398 0000000200000001 ffff81016f412398
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 00000000ffffffff     0 10201  10199
  ffff810046851b58 0000000000000082 ffff8101fff7b200 0000000000000292
  ffffffff80600cc0 ffffffff80411a78 ffff81018670386c ffff8100469a10b0
  ffff81007fb43210 ffff8100469a12e8 0000000200000246 ffff8100469a12e8
Call Trace:
  [<ffffffff80411a78>] dev_queue_xmit+0x21a/0x232
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80409110>] sk_reset_timer+0xf/0x19
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8025cfb5>] __generic_file_aio_write_nolock+0x265/0x37e
  [<ffffffff8025d799>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9ed8>] ext4_file_write+0x96/0x11a
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D ffff810027160690     0 10202   7998
  ffff8101b9727d70 0000000000000082 ffff8101b9727d38 ffff81007e8a0e00
  ffffffff80600cc0 0000000000000000 ffffffff80293dad ffff8101b97fc2c0
  ffff81016f4126f0 ffff8101b97fc4f8 000000038028c8f9 ffff8101b97fc4f8
Call Trace:
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028ac27>] lock_rename+0x35/0xc5
  [<ffffffff8028d51e>] do_rename+0x98/0x1b2
  [<ffffffff802921b3>] __posix_lock_file+0x43d/0x44e
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d684>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff810052a3a3c0     0 10203   2487
  ffff810147c47bc8 0000000000000082 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff81016f4126f0
  ffff81027f2b8b20 ffff81016f412928 0000000300000001 ffff81016f412928
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 10205   7998
  ffff8101f8f71d70 0000000000000082 ffff8101f8f71d38 ffff81007e8a0e00
  ffffffff80600cc0 0000000000000000 ffffffff80293dad ffff8101b97f8000
  ffffffff8054d350 ffff8101b97f8238 000000008028c8f9 ffff8101b97f8238
Call Trace:
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028ac27>] lock_rename+0x35/0xc5
  [<ffffffff8028d51e>] do_rename+0x98/0x1b2
  [<ffffffff802921b3>] __posix_lock_file+0x43d/0x44e
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d684>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff81016f681b80     0 10206   2487
  ffff81017f769bc8 0000000000000082 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 ffff810001006cc0 ffff81016f410b20
  ffff8101b97fd370 ffff81016f410d58 0000000300000001 ffff81016f410d58
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S 00007f17790fc000     0 10208  10203
  ffff810034705b68 0000000000000086 ffff810246fa5410 ffffffff802414e9
  ffffffff80600cc0 000000000f5342a7 0000000000000046 ffff8100469a5e90
  ffff8101b97fc2c0 ffff8100469a60c8 0000000346fa5410 ffff8100469a60c8
Call Trace:
  [<ffffffff802414e9>] ktime_get_real+0xc/0x43
  [<ffffffff80231c26>] local_bh_enable+0x6a/0x7c
  [<ffffffff80411a78>] dev_queue_xmit+0x21a/0x232
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff804674fa>] _spin_lock_bh+0x9/0x1f
  [<ffffffff80408cba>] release_sock+0x13/0x95
  [<ffffffff80409265>] sk_wait_data+0x83/0xc6
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80434547>] tcp_recvmsg+0x3b3/0x7d2
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80406a49>] sock_recvmsg+0xd5/0xed
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80242f85>] getnstimeofday+0x38/0x84
  [<ffffffff80406509>] sockfd_lookup_light+0x1a/0x52
  [<ffffffff80407a7d>] sys_recvfrom+0xc3/0x122
  [<ffffffff80241154>] hrtimer_start+0x100/0x122
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S 00007f17790fc000     0 10209  10206
  ffff810147d37b68 0000000000000086 ffff81007e857b10 ffffffff802414e9
  ffffffff80600cc0 000000000f1a1bb0 0000000000000046 ffff81016f413210
  ffff8101b97f8000 ffff81016f413448 000000007e857b10 ffff81016f413448
Call Trace:
  [<ffffffff802414e9>] ktime_get_real+0xc/0x43
  [<ffffffff80231c26>] local_bh_enable+0x6a/0x7c
  [<ffffffff80411a78>] dev_queue_xmit+0x21a/0x232
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff804674fa>] _spin_lock_bh+0x9/0x1f
  [<ffffffff80408cba>] release_sock+0x13/0x95
  [<ffffffff80409265>] sk_wait_data+0x83/0xc6
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80434547>] tcp_recvmsg+0x3b3/0x7d2
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80406a49>] sock_recvmsg+0xd5/0xed
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80242f85>] getnstimeofday+0x38/0x84
  [<ffffffff80406509>] sockfd_lookup_light+0x1a/0x52
  [<ffffffff80407a7d>] sys_recvfrom+0xc3/0x122
  [<ffffffff80241154>] hrtimer_start+0x100/0x122
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 10210   7975
  ffff81001ac6fbe8 0000000000000086 ffff8101867b4d10 000000038042e6b5
  ffffffff80600cc0 0000000000000246 ffff81007fbbb000 ffff8100469a2160
  ffff81007fb43210 ffff8100469a2398 0000000200000000 ffff8100469a2398
Call Trace:
  [<ffffffffa0068801>] :nf_conntrack:nf_conntrack_in+0x455/0x508
  [<ffffffff804674e1>] _read_lock_bh+0x9/0x19
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8028a261>] pipe_write+0x4bc/0x4ce
  [<ffffffff8028d093>] path_walk+0xaf/0xb9
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff80282ad0>] __dentry_open+0x141/0x226
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff8101fff32100     0 10211   2487
  ffff8101b960bbc8 0000000000000086 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff8101b97fa160
  ffff8101b97fb210 ffff8101b97fa398 0000000200000001 ffff8101b97fa398
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D ffff8101dbe48f60     0 10213  10211
  ffff8101f8ff3d70 0000000000000082 ffff8101f8ff3d38 ffff81007e8a0e00
  ffffffff80600cc0 0000000000000000 ffffffff80293dad ffff8101b97fef40
  ffff8100469a10b0 ffff8101b97ff178 000000028028c8f9 ffff8101b97ff178
Call Trace:
  [<ffffffff80293dad>] dput+0x21/0x10a
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff804665e8>] __mutex_lock_slowpath+0x6a/0xa0
  [<ffffffff80466484>] mutex_lock+0xa/0xb
  [<ffffffff8028acaf>] lock_rename+0xbd/0xc5
  [<ffffffff8028d51e>] do_rename+0x98/0x1b2
  [<ffffffff80261447>] __alloc_pages_internal+0xd2/0x40c
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d684>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 0000000000000000     0 10214   7975
  ffff810046addbe8 0000000000000082 ffff81017f72cb50 ffffffff8042e6b5
  ffffffff80600cc0 0000000000000246 ffff81007fbbb000 ffff8100469a3d30
  ffff81027f14de90 ffff8100469a3f68 000000017f6a2a6c ffff8100469a3f68
Call Trace:
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8022595b>] check_preempt_wakeup+0x7f/0xbc
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8028a261>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802736e8>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d509>] unmap_region+0x10f/0x125
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff810220725e40     0 10215   2487
  ffff8101866ffbc8 0000000000000086 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff8101b97fe420
  ffff81027f2b90b0 ffff8101b97fe658 0000000100000001 ffff8101b97fe658
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 0000000000000000     0 10217  10215
  ffff810220501bf8 0000000000000086 0000000000000001 0000000000000000
  ffffffff80600cc0 0000000000000000 ffff810220501ba8 ffff81027f2b90b0
  ffff81017f781bd0 ffff81027f2b92e8 0000000100000000 ffff81027f2b92e8
Call Trace:
  [<ffffffff80224a67>] __wake_up+0x38/0x4f
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e2b2c>] ext4_rename+0x4d/0x64a
  [<ffffffff8040820c>] sock_common_recvmsg+0x30/0x45
  [<ffffffff8028bc30>] vfs_rename+0x1fd/0x376
  [<ffffffff8028d5d7>] do_rename+0x151/0x1b2
  [<ffffffff80261447>] __alloc_pages_internal+0xd2/0x40c
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff8028d684>] sys_renameat+0x4c/0x6b
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 10218   7998
  ffff8101866c1be8 0000000000000082 ffff810246fa4610 ffffffff8042e6b5
  ffffffff80600cc0 ffff8101866c1b90 ffff8101db68f7e0 ffff8101b97fc850
  ffff81007fb442c0 ffff8101b97fca88 000000034f9ed590 ffff8101b97fca88
Call Trace:
  [<ffffffff8042e6b5>] ip_queue_xmit+0x2a2/0x2f8
  [<ffffffff802a3c0f>] __getblk+0x1e/0x28d
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8025ba69>] find_lock_page+0x29/0x87
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff8028a261>] pipe_write+0x4bc/0x4ce
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8021ed48>] do_page_fault+0x471/0x825
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802736e8>] free_pages_and_swap_cache+0x70/0x8b
  [<ffffffff8026d509>] unmap_region+0x10f/0x125
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff81016f682100     0 10219   2487
  ffff8101f8ea7bc8 0000000000000082 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 ffff810201e11cc0 ffff8101b97fde90
  ffff81027f2b90b0 ffff8101b97fe0c8 0000000100000001 ffff8101b97fe0c8
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8045567a>] fn_hash_lookup+0x83/0xc1
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        S 0000000000000000     0 10220   7975
  ffff81016f4859e8 0000000000000082 ffff81023b55c8b0 9c34adbf00000834
  ffffffff80600cc0 000000038023e617 ffff8101db55d930 ffff81016f415900
  ffff81027f2b8b20 ffff81016f415b38 0000000346fa5250 ffff81016f415b38
Call Trace:
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffff80235889>] __mod_timer+0xaa/0xb8
  [<ffffffff80466249>] schedule_timeout+0xa6/0xc9
  [<ffffffff80235392>] process_timeout+0x0/0x5
  [<ffffffff80290728>] do_select+0x414/0x482
  [<ffffffff80290dd5>] __pollwait+0x0/0xe3
  [<ffffffff80224eed>] default_wake_function+0x0/0xe
  [<ffffffff80411a78>] dev_queue_xmit+0x21a/0x232
  [<ffffffff802356ef>] lock_timer_base+0x26/0x4b
  [<ffffffffa0068801>] :nf_conntrack:nf_conntrack_in+0x455/0x508
  [<ffffffff804674e1>] _read_lock_bh+0x9/0x19
  [<ffffffffa00634f5>] :ip_tables:ipt_do_table+0x2e9/0x30c
  [<ffffffffa006bd34>] :nf_conntrack:nf_ct_deliver_cached_events+0x4d/0x7d
  [<ffffffffa007937e>] :nf_conntrack_ipv4:ipv4_confirm+0xcc/0xd7
  [<ffffffff80425272>] nf_iterate+0x41/0x7d
  [<ffffffff80242f85>] getnstimeofday+0x38/0x84
  [<ffffffff8042ea4b>] ip_finish_output+0x0/0x239
  [<ffffffff80290941>] core_sys_select+0x1ab/0x253
  [<ffffffff80231c26>] local_bh_enable+0x6a/0x7c
  [<ffffffff802985f0>] mnt_want_write+0x25/0x77
  [<ffffffff80295a4e>] touch_atime+0x12/0xfa
  [<ffffffff80408dd6>] lock_sock_nested+0x9a/0xa5
  [<ffffffff804674fa>] _spin_lock_bh+0x9/0x1f
  [<ffffffff80408cba>] release_sock+0x13/0x95
  [<ffffffff8023e617>] bit_waitqueue+0x10/0xa0
  [<ffffffff8023e6e5>] wake_up_bit+0x11/0x22
  [<ffffffff80290d25>] sys_select+0xb7/0x167
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        S ffff810220726680     0 10221   2487
  ffff810195039bc8 0000000000000082 0000000000000096 ffffffff80224edc
  ffffffff80600cc0 0000000000000001 0000000000000096 ffff8101b97fd370
  ffff81016f410590 ffff8101b97fd5a8 0000000300000001 ffff8101b97fd5a8
Call Trace:
  [<ffffffff80224edc>] try_to_wake_up+0x155/0x166
  [<ffffffff8040da2f>] memcpy_fromiovec+0x34/0x63
  [<ffffffff8040bc6a>] skb_queue_tail+0x17/0x3e
  [<ffffffff80409098>] sock_def_readable+0x10/0x5d
  [<ffffffff80459e5c>] unix_stream_sendmsg+0x293/0x353
  [<ffffffff804661c1>] schedule_timeout+0x1e/0xc9
  [<ffffffff8023e81a>] prepare_to_wait+0x15/0x5f
  [<ffffffff804598c9>] unix_stream_recvmsg+0x282/0x582
  [<ffffffff80224b2b>] __wake_up_sync+0x3a/0x56
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80405f35>] sock_aio_read+0x107/0x112
  [<ffffffff80406daf>] sys_sendmsg+0x217/0x28a
  [<ffffffff80283f9a>] do_sync_read+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802848d7>] vfs_read+0xbd/0x132
  [<ffffffff80284a08>] sys_read+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 0000000000000000     0 10224  10221
  ffff810246ef1a68 0000000000000086 000000003b55c7e0 ffffffff80233c4d
  ffffffff80600cc0 ffffffff802d7ba2 0000000000000003 ffff81027f2b8b20
  ffff8101b97fd370 ffff81027f2b8d58 0000000334b600c0 ffff81027f2b8d58
Call Trace:
  [<ffffffff80233c4d>] __capable+0x9/0x1f
  [<ffffffff802d7ba2>] ext4_has_free_blocks+0x2b/0xad
  [<ffffffff802a3869>] __find_get_block_slow+0xcf/0xdb
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802a4264>] generic_write_end+0x5d/0x68
  [<ffffffff8025c6bc>] generic_file_buffered_write+0x1b6/0x658
  [<ffffffff80409110>] sk_reset_timer+0xf/0x19
  [<ffffffff8043cd07>] tcp_rcv_established+0x908/0xbc5
  [<ffffffff8023136c>] current_fs_time+0x1e/0x24
  [<ffffffff8025b358>] remove_suid+0x18/0x4b
  [<ffffffff8025d09a>] __generic_file_aio_write_nolock+0x34a/0x37e
  [<ffffffff8025d799>] generic_file_aio_write+0x64/0xc4
  [<ffffffff802d9ed8>] ext4_file_write+0x96/0x11a
  [<ffffffff80283e87>] do_sync_write+0xce/0x113
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802846ac>] vfs_write+0xad/0x136
  [<ffffffff802847f1>] sys_write+0x45/0x6e
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

vsftpd        D 00000000ffffffff     0 10225  10219
  ffff810147d55ce8 0000000000000086 ffff8101a2dcadd8 0000000000000006
  ffffffff80600cc0 ffff8102796cabd0 ffff810274479000 ffff81016f410590
  ffff81007fb442c0 ffff81016f4107c8 000000030000000f ffff81016f4107c8
Call Trace:
  [<ffffffff8028ad6a>] do_lookup+0x63/0x1a1
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802e24e1>] ext4_create+0x4c/0x105
  [<ffffffff802e27e7>] ext4_lookup+0x97/0xc1
  [<ffffffff8028b7d9>] vfs_create+0x7d/0xed
  [<ffffffff8028e385>] do_filp_open+0x1ed/0x832
  [<ffffffff802828e0>] do_sys_open+0x46/0xc3
  [<ffffffff8020b2d2>] tracesys+0xd5/0xda

sf_ftp        D 00000000ffffffff     0 10226   8021
  ffff81027f0afbb8 0000000000000082 0000003df881a530 ffff81003726f1c0
  ffffffff80600cc0 ffffffff80260923 0000000000000002 ffff81027f2bfa60
  ffff81007fb42160 ffff81027f2bfc98 000000010000001e ffff81027f2bfc98
Call Trace:
  [<ffffffff80260923>] __rmqueue_smallest+0x9d/0x124
  [<ffffffff802609c7>] __rmqueue+0x1d/0x1fb
  [<ffffffff802feaa5>] start_this_handle+0x2ad/0x370
  [<ffffffff8023e6f6>] autoremove_wake_function+0x0/0x2e
  [<ffffffff802fecca>] jbd2_journal_start+0x9a/0xce
  [<ffffffff802dcb2b>] ext4_dirty_inode+0x28/0x7b
  [<ffffffff802a0092>] __mark_inode_dirty+0x29/0x187
  [<ffffffff802959f7>] file_update_time+0xaf/0xf4
  [<ffffffff802693fc>] do_wp_page+0x45b/0x4ba
  [<ffffffff8026aac1>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff8028f8b4>] filldir+0x0/0xb7
  [<ffffffff802921b3>] __posix_lock_file+0x43d/0x44e
  [<ffffffff8029260e>] fcntl_setlk+0x285/0x296
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467699>] error_exit+0x0/0x51


