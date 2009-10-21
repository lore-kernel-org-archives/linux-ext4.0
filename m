From: Fredrik Andersson <nablaman@gmail.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Wed, 21 Oct 2009 11:08:14 +0200
Message-ID: <a125a870910210208s581dcc4esb2b6ef156f5291ef@mail.gmail.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
	 <4ADB3AEC.8040901@redhat.com>
	 <a125a870910190249l39183927i8f042a9ace39904c@mail.gmail.com>
	 <4ADE6FE2.20807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53027 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZJUJIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2009 05:08:11 -0400
Received: by ewy3 with SMTP id 3so5787211ewy.17
        for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 02:08:14 -0700 (PDT)
In-Reply-To: <4ADE6FE2.20807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alright, here is the complete sysrq w data. I will file a bug report to=
o.

My programs are drdbmake, nodeserv, receptd.

[6130704.521614] SysRq : Show Blocked State
[6130704.521696]   task                        PC stack   pid father
[6130704.521702] pdflush       D ffff8801f4ce9bdc     0   269      2
[6130704.521707]  ffff88021e551960 0000000000000046 ffff88021e5b56e0
ffff8800d3506a80
[6130704.521712]  0000000000010e80 000000000000c748 ffff88021fa24740
ffff88021f843900
[6130704.521717]  ffff88021fa24ab0 0000000100000008 000000025819ca1c
0080001000800013
[6130704.521721] Call Trace:
[6130704.521731]  [<ffffffff813a9639>] schedule+0x9/0x20
[6130704.521735]  [<ffffffff813ab2d5>] __down_read+0x85/0xb7
[6130704.521738]  [<ffffffff813aa565>] down_read+0x25/0x30
[6130704.521743]  [<ffffffff8114e6f2>] ext4_get_blocks_wrap+0x52/0x290
[6130704.521747]  [<ffffffff8114f601>] mpage_da_map_blocks+0xd1/0x7a0
[6130704.521752]  [<ffffffff8109d12c>] ? write_cache_pages+0x2fc/0x470
[6130704.521756]  [<ffffffff81150330>] ? __mpage_da_writepage+0x0/0x180
[6130704.521760]  [<ffffffff8114ffdb>] ext4_da_writepages+0x30b/0x590
[6130704.521764]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6130704.521768]  [<ffffffff8109d2f8>] do_writepages+0x28/0x50
[6130704.521773]  [<ffffffff810e60fb>] __writeback_single_inode+0x9b/0x=
3e0
[6130704.521777]  [<ffffffff8104f830>] ? process_timeout+0x0/0x10
[6130704.521781]  [<ffffffff813a8827>] ? io_schedule_timeout+0x37/0x50
[6130704.521785]  [<ffffffff810e68ec>] generic_sync_sb_inodes+0x36c/0x4=
40
[6130704.521789]  [<ffffffff810e6b8e>] writeback_inodes+0x5e/0x100
[6130704.521792]  [<ffffffff8109d4ac>] wb_kupdate+0xbc/0x140
[6130704.521796]  [<ffffffff8109e6a8>] pdflush+0x118/0x220
[6130704.521799]  [<ffffffff8109d3f0>] ? wb_kupdate+0x0/0x140
[6130704.521802]  [<ffffffff8109e590>] ? pdflush+0x0/0x220
[6130704.521806]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6130704.521811]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6130704.521814]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6130704.521818]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6130704.521821]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6130704.521826] kjournald2    D ffff88021f921e28     0  1334      2
[6130704.521830]  ffff88021f921d10 0000000000000046 ffff88021f48c890
0000000000000000
[6130704.521835]  0000000000010e80 000000000000c748 ffff88021e5d8000
ffff88021f844740
[6130704.521839]  ffff88021e5d8370 0000000100000282 0000000000000000
0000000000000282
[6130704.521844] Call Trace:
[6130704.521847]  [<ffffffff813a9639>] schedule+0x9/0x20
[6130704.521853]  [<ffffffff81178ebe>]
jbd2_journal_commit_transaction+0x1be/0x1810
[6130704.521856]  [<ffffffff81040cd6>] ? dequeue_task_fair+0x256/0x260
[6130704.521860]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6130704.521864]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0=
x40
[6130704.521868]  [<ffffffff8117ea8a>] kjournald2+0x11a/0x370
[6130704.521872]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0=
x40
[6130704.521875]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6130704.521878]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6130704.521881]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6130704.521885]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6130704.521888]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6130704.521892]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6130704.521895]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6130704.521901] receptd       D 000000000000002a     0 28746   2063
[6130704.521905]  ffff8801d1b39c78 0000000000000082 ffff8801d1b39be8
ffffffff81152dd3
[6130704.521910]  0000000000010e80 000000000000c748 ffff88010014ce60
ffffffff81526360
[6130704.521914]  ffff88010014d1d0 00000000810db183 000000025821c45c
0000000000000286
[6130704.521919] Call Trace:
[6130704.521922]  [<ffffffff81152dd3>] ? dx_release+0x23/0x50
[6130704.521926]  [<ffffffff813a9639>] schedule+0x9/0x20
[6130704.521930]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6130704.521934]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0=
x40
[6130704.521937]  [<ffffffff81178306>] jbd2_journal_start+0xa6/0xf0
[6130704.521942]  [<ffffffff811593c5>] ext4_journal_start_sb+0x55/0x90
[6130704.521945]  [<ffffffff81155441>] ext4_create+0x81/0x130
[6130704.521949]  [<ffffffff810d23aa>] vfs_create+0x9a/0xb0
[6130704.521952]  [<ffffffff810d522e>] do_filp_open+0x85e/0x990
[6130704.521956]  [<ffffffff810d1d16>] ? getname+0x36/0x200
[6130704.521960]  [<ffffffff810deada>] ? alloc_fd+0x4a/0x140
[6130704.521964]  [<ffffffff810c5dfb>] do_sys_open+0x7b/0x110
[6130704.521967]  [<ffffffff810c5ebb>] sys_open+0x1b/0x20
[6130704.521971]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.521973] receptd       D 000000000000002a     0 10643   2063
[6130704.521977]  ffff8800155e9c78 0000000000000082 ffff8800155e9be8
ffffffff81152dd3
[6130704.521982]  0000000000010e80 000000000000c748 ffff880100149560
ffffffff81526360
[6130704.521986]  ffff8801001498d0 00000000810db183 000000025adbe421
0000000000000286
[6130704.521991] Call Trace:
[6130704.521994]  [<ffffffff81152dd3>] ? dx_release+0x23/0x50
[6130704.521998]  [<ffffffff813a9639>] schedule+0x9/0x20
[6130704.522002]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6130704.522005]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0=
x40
[6130704.522009]  [<ffffffff81178306>] jbd2_journal_start+0xa6/0xf0
[6130704.522013]  [<ffffffff811593c5>] ext4_journal_start_sb+0x55/0x90
[6130704.522016]  [<ffffffff81155441>] ext4_create+0x81/0x130
[6130704.522020]  [<ffffffff810d23aa>] vfs_create+0x9a/0xb0
[6130704.522023]  [<ffffffff810d522e>] do_filp_open+0x85e/0x990
[6130704.522027]  [<ffffffff810d1d16>] ? getname+0x36/0x200
[6130704.522030]  [<ffffffff810deada>] ? alloc_fd+0x4a/0x140
[6130704.522033]  [<ffffffff810c5dfb>] do_sys_open+0x7b/0x110
[6130704.522037]  [<ffffffff810c5ebb>] sys_open+0x1b/0x20
[6130704.522040]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522043] receptd       D 000000000000002a     0  3658   2063
[6130704.522047]  ffff8801792adc78 0000000000000082 ffff8801792adbe8
ffffffff81152dd3
[6130704.522051]  0000000000010e80 000000000000c748 ffff88010014b900
ffffffff81526360
[6130704.522056]  ffff88010014bc70 00000000810db183 000000025ddc053f
0000000000000286
[6130704.522060] Call Trace:
[6130704.522063]  [<ffffffff81152dd3>] ? dx_release+0x23/0x50
[6130704.522067]  [<ffffffff813a9639>] schedule+0x9/0x20
[6130704.522071]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6130704.522075]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0=
x40
[6130704.522079]  [<ffffffff81178306>] jbd2_journal_start+0xa6/0xf0
[6130704.522083]  [<ffffffff811593c5>] ext4_journal_start_sb+0x55/0x90
[6130704.522086]  [<ffffffff81155441>] ext4_create+0x81/0x130
[6130704.522089]  [<ffffffff810d23aa>] vfs_create+0x9a/0xb0
[6130704.522093]  [<ffffffff810d522e>] do_filp_open+0x85e/0x990
[6130704.522096]  [<ffffffff810d1d16>] ? getname+0x36/0x200
[6130704.522099]  [<ffffffff810deada>] ? alloc_fd+0x4a/0x140
[6130704.522103]  [<ffffffff810c5dfb>] do_sys_open+0x7b/0x110
[6130704.522106]  [<ffffffff810c5ebb>] sys_open+0x1b/0x20
[6130704.522109]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522112] receptd       D ffff8801f4d04ba4     0  4716   2063
[6130704.522116]  ffff880001f43e58 0000000000000082 ffffffff81095e00
ffff880001f43de8
[6130704.522120]  0000000000010e80 000000000000c748 ffff880100149c80
ffffffff81526360
[6130704.522125]  ffff880100149ff0 0000000000060d51 000000025fd791a8
0000000000060d51
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffff81095e00>] ? sync_page+0x0/0x60
[6130704.522128]  [<ffffffff810b9c48>] ? delete_from_swap_cache+0x48/0x=
60
[6130704.522128]  [<ffffffff810ba70b>] ? swap_info_get+0x6b/0xf0
[6130704.522128]  [<ffffffff813a9d7b>] __mutex_lock_killable_slowpath+0=
xeb/0x1c0
[6130704.522128]  [<ffffffff810d6c90>] ? filldir+0x0/0xe0
[6130704.522128]  [<ffffffff813a9ea8>] mutex_lock_killable+0x58/0x70
[6130704.522128]  [<ffffffff810d6ed2>] vfs_readdir+0x72/0xc0
[6130704.522128]  [<ffffffff810d707b>] sys_getdents+0x8b/0xf0
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] receptd       D ffff8801f4d04ba4     0 18596   2063
[6130704.522128]  ffff88015a003e58 0000000000000082 ffff88021c9cb540
000000012905b025
[6130704.522128]  0000000000010e80 000000000000c748 ffff8801fb166ae0
ffff88021f843900
[6130704.522128]  ffff8801fb166e50 0000000101c0ba80 000000026291bdc0
ffffe20006bcac40
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffff813a9d7b>] __mutex_lock_killable_slowpath+0=
xeb/0x1c0
[6130704.522128]  [<ffffffff810d6c90>] ? filldir+0x0/0xe0
[6130704.522128]  [<ffffffff813a9ea8>] mutex_lock_killable+0x58/0x70
[6130704.522128]  [<ffffffff810d6ed2>] vfs_readdir+0x72/0xc0
[6130704.522128]  [<ffffffff810d707b>] sys_getdents+0x8b/0xf0
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] receptd       D ffff8801f4d04ba4     0   569   2063
[6130704.522128]  ffff8801c5705e58 0000000000000082 0000000000000000
ffff88021e7a1150
[6130704.522128]  0000000000010e80 000000000000c748 ffff8801fb161560
ffffffff81526360
[6130704.522128]  ffff8801fb1618d0 0000000081580a80 00000002654bd5e6
0000000000000001
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffff810b68b4>] ? anon_vma_prepare+0x34/0xf0
[6130704.522128]  [<ffffffff813a9d7b>] __mutex_lock_killable_slowpath+0=
xeb/0x1c0
[6130704.522128]  [<ffffffff810d6c90>] ? filldir+0x0/0xe0
[6130704.522128]  [<ffffffff813a9ea8>] mutex_lock_killable+0x58/0x70
[6130704.522128]  [<ffffffff810d6ed2>] vfs_readdir+0x72/0xc0
[6130704.522128]  [<ffffffff810d707b>] sys_getdents+0x8b/0xf0
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] receptd       D ffff8801f4d04ba4     0 15225   2063
[6130704.522128]  ffff880013545e58 0000000000000082 0000000000000000
ffff88021e7a1150
[6130704.522128]  0000000000010e80 000000000000c748 ffff8801fb165ca0
ffffffff81526360
[6130704.522128]  ffff8801fb166010 0000000081580a80 000000026805edc6
0000000000000001
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffff810b68b4>] ? anon_vma_prepare+0x34/0xf0
[6130704.522128]  [<ffffffff813a9d7b>] __mutex_lock_killable_slowpath+0=
xeb/0x1c0
[6130704.522128]  [<ffffffff810d6c90>] ? filldir+0x0/0xe0
[6130704.522128]  [<ffffffff813a9ea8>] mutex_lock_killable+0x58/0x70
[6130704.522128]  [<ffffffff810d6ed2>] vfs_readdir+0x72/0xc0
[6130704.522128]  [<ffffffff810d707b>] sys_getdents+0x8b/0xf0
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] receptd       D ffff8801f4d04ba4     0 29613   2063
[6130704.522128]  ffff88004071de58 0000000000000082 0000000000000000
ffff88021e7a1150
[6130704.522128]  0000000000010e80 000000000000c748 ffff8801fb1663c0
ffffffff81526360
[6130704.522128]  ffff8801fb166730 0000000081580a80 000000026ac00606
0000000000000001
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffff810b68b4>] ? anon_vma_prepare+0x34/0xf0
[6130704.522128]  [<ffffffff813a9d7b>] __mutex_lock_killable_slowpath+0=
xeb/0x1c0
[6130704.522128]  [<ffffffff810d6c90>] ? filldir+0x0/0xe0
[6130704.522128]  [<ffffffff813a9ea8>] mutex_lock_killable+0x58/0x70
[6130704.522128]  [<ffffffff810d6ed2>] vfs_readdir+0x72/0xc0
[6130704.522128]  [<ffffffff810d707b>] sys_getdents+0x8b/0xf0
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] receptd       D ffff8801f4d04ba4     0  4444   2063
[6130704.522128]  ffff8800404e5e58 0000000000000082 0000000000000000
ffff88021e7a1150
[6130704.522128]  0000000000010e80 000000000000c748 ffff880040494020
ffffffff81526360
[6130704.522128]  ffff880040494390 0000000081580a80 000000026b2c0f52
0000000000000001
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffff810b68b4>] ? anon_vma_prepare+0x34/0xf0
[6130704.522128]  [<ffffffff813a9d7b>] __mutex_lock_killable_slowpath+0=
xeb/0x1c0
[6130704.522128]  [<ffffffff810d6c90>] ? filldir+0x0/0xe0
[6130704.522128]  [<ffffffff813a9ea8>] mutex_lock_killable+0x58/0x70
[6130704.522128]  [<ffffffff810d6ed2>] vfs_readdir+0x72/0xc0
[6130704.522128]  [<ffffffff810d707b>] sys_getdents+0x8b/0xf0
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] drdbmake      D ffff88021e4c7800     0 27019  13796
[6130704.522128]  ffff8801d1bcda88 0000000000000082 ffff8801f4ce9bf0
ffff8801678b1380
[6130704.522128]  0000000000010e80 000000000000c748 ffff8800404963c0
ffffffff81526360
[6130704.522128]  ffff880040496730 00000000f4ce9bf0 000000025819cebe
0000000000000282
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffff813a9639>] schedule+0x9/0x20
[6130704.522128]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6130704.522128]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0=
x40
[6130704.522128]  [<ffffffff811781ce>] jbd2_journal_restart+0xbe/0x150
[6130704.522128]  [<ffffffff8116243d>] ext4_ext_truncate+0x6dd/0xa20
[6130704.522128]  [<ffffffff81095b3b>] ? find_get_pages+0x3b/0xf0
[6130704.522128]  [<ffffffff81150a78>] ext4_truncate+0x198/0x680
[6130704.522128]  [<ffffffff810ac984>] ? unmap_mapping_range+0x74/0x280
[6130704.522128]  [<ffffffff811772c0>] ? jbd2_journal_stop+0x1e0/0x360
[6130704.522128]  [<ffffffff810acd25>] vmtruncate+0xa5/0x110
[6130704.522128]  [<ffffffff810dda10>] inode_setattr+0x30/0x180
[6130704.522128]  [<ffffffff8114d073>] ext4_setattr+0x173/0x310
[6130704.522128]  [<ffffffff810ddc79>] notify_change+0x119/0x330
[6130704.522128]  [<ffffffff810c6df3>] do_truncate+0x63/0x90
[6130704.522128]  [<ffffffff810d0cc3>] ? get_write_access+0x23/0x60
[6130704.522128]  [<ffffffff810c70cb>] sys_truncate+0x17b/0x180
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] nodeserv      D ffff88021eaedca8     0 17888  13796
[6130704.522128]  ffff88021eaedbf8 0000000000000082 ffff8800280261e8
ffff88021e5b56e0
[6130704.522128]  0000000000010e80 000000000000c748 ffff880100148e40
ffffffff81526360
[6130704.522128]  ffff8801001491b0 000000008119bd17 000000026d668c1b
0000000000000002
[6130704.522128] Call Trace:
[6130704.522128]  [<ffffffffa0039291>] ? raid0_unplug+0x51/0x70 [raid0]
[6130704.522128]  [<ffffffff813a9639>] schedule+0x9/0x20
[6130704.522128]  [<ffffffff813a9687>] io_schedule+0x37/0x50
[6130704.522128]  [<ffffffff81095e35>] sync_page+0x35/0x60
[6130704.522128]  [<ffffffff81095e69>] sync_page_killable+0x9/0x50
[6130704.522128]  [<ffffffff813a99d2>] __wait_on_bit_lock+0x52/0xb0
[6130704.522128]  [<ffffffff81095e60>] ? sync_page_killable+0x0/0x50
[6130704.522128]  [<ffffffff81095d74>] __lock_page_killable+0x64/0x70
[6130704.522128]  [<ffffffff8105b940>] ? wake_bit_function+0x0/0x40
[6130704.522128]  [<ffffffff81095c0b>] ? find_get_page+0x1b/0xb0
[6130704.522128]  [<ffffffff81097908>] generic_file_aio_read+0x3b8/0x6b=
0
[6130704.522128]  [<ffffffff810c7dc1>] do_sync_read+0xf1/0x140
[6130704.522128]  [<ffffffff8106a5e8>] ? do_futex+0xb8/0xb20
[6130704.522128]  [<ffffffff813ab78f>] ? _spin_unlock_irqrestore+0x2f/0=
x40
[6130704.522128]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0=
x40
[6130704.522128]  [<ffffffff8105bc73>] ? add_wait_queue+0x43/0x60
[6130704.522128]  [<ffffffff81062a6c>] ? getnstimeofday+0x5c/0xf0
[6130704.522128]  [<ffffffff8105f049>] ? ktime_get_ts+0x59/0x60
[6130704.522128]  [<ffffffff810c85b8>] vfs_read+0xc8/0x170
[6130704.522128]  [<ffffffff810c86fa>] sys_pread64+0x9a/0xa0
[6130704.522128]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6130704.522128] Sched Debug Version: v0.09, 2.6.30.4 #1
[6130704.522128] now at 6130704522.576956 msecs
[6130704.522128]   .jiffies                                 : 104253718=
17
[6130704.522128]   .sysctl_sched_latency                    : 40.000000
[6130704.522128]   .sysctl_sched_min_granularity            : 8.000000
[6130704.522128]   .sysctl_sched_wakeup_granularity         : 10.000000
[6130704.522128]   .sysctl_sched_child_runs_first           : 0.000001
[6130704.522128]   .sysctl_sched_features                   : 113917
[6130704.522128]
[6130704.522128] cpu#0, 1866.760 MHz
[6130704.522128]   .nr_running                    : 0
[6130704.522128]   .load                          : 0
[6130704.522128]   .nr_switches                   : 1088197559
[6130704.522128]   .nr_load_updates               : 1494088224
[6130704.522128]   .nr_uninterruptible            : -10143689
[6130704.522128]   .next_balance                  : 10425.371927
[6130704.522128]   .curr->pid                     : 0
[6130704.522128]   .clock                         : 6130704522.001795
[6130704.522128]   .cpu_load[0]                   : 0
[6130704.522128]   .cpu_load[1]                   : 732
[6130704.522128]   .cpu_load[2]                   : 1307
[6130704.522128]   .cpu_load[3]                   : 1628
[6130704.522128]   .cpu_load[4]                   : 2055
[6130704.522128]   .yld_count                     : 62066
[6130704.522128]   .sched_switch                  : 0
[6130704.522128]   .sched_count                   : 1162815210
[6130704.522128]   .sched_goidle                  : 486300434
[6130704.522128]   .ttwu_count                    : 639575934
[6130704.522128]   .ttwu_local                    : 567060963
[6130704.522128]   .bkl_count                     : 643
[6130704.522128]
[6130704.522128] cfs_rq[0]:
[6130704.522128]   .exec_clock                    : 1105652808.029192
[6130704.522128]   .MIN_vruntime                  : 0.000001
[6130704.522128]   .min_vruntime                  : 7063664391.526226
[6130704.522128]   .max_vruntime                  : 0.000001
[6130704.522128]   .spread                        : 0.000000
[6130704.522128]   .spread0                       : 0.000000
[6130704.522128]   .nr_running                    : 0
[6130704.522128]   .load                          : 0
[6130704.522128]   .nr_spread_over                : 8978
[6130704.522128]
[6130704.522128] rt_rq[0]:
[6130704.522128]   .rt_nr_running                 : 0
[6130704.522128]   .rt_throttled                  : 0
[6130704.522128]   .rt_time                       : 0.000000
[6130704.522128]   .rt_runtime                    : 950.000000
[6130704.522128]
[6130704.522128] runnable tasks:
[6130704.522128]             task   PID         tree-key  switches
prio     exec-runtime         sum-exec        sum-sleep
[6130704.522128]
-----------------------------------------------------------------------=
-----------------------------------
[6130704.522128]
[6130704.522128] cpu#1, 1866.760 MHz
[6130704.522128]   .nr_running                    : 1
[6130704.522128]   .load                          : 1024
[6130704.522128]   .nr_switches                   : 818082742
[6130704.522128]   .nr_load_updates               : 1586872071
[6130704.522128]   .nr_uninterruptible            : 10143702
[6130704.522128]   .next_balance                  : 10425.371857
[6130704.522128]   .curr->pid                     : 11137
[6130704.522128]   .clock                         : 6130704521.459918
[6130704.522128]   .cpu_load[0]                   : 1024
[6130704.522128]   .cpu_load[1]                   : 514
[6130704.522128]   .cpu_load[2]                   : 318
[6130704.522128]   .cpu_load[3]                   : 299
[6130704.522128]   .cpu_load[4]                   : 261
[6130704.522128]   .yld_count                     : 283011
[6130704.522128]   .sched_switch                  : 0
[6130704.522128]   .sched_count                   : 947252346
[6130704.522128]   .sched_goidle                  : 479113257
[6130704.522128]   .ttwu_count                    : 422473135
[6130704.522128]   .ttwu_local                    : 316765436
[6130704.522128]   .bkl_count                     : 10
[6130704.522128]
[6130704.522128] cfs_rq[1]:
[6130704.522128]   .exec_clock                    : 478641403.088793
[6130704.522128]   .MIN_vruntime                  : 0.000001
[6130704.522128]   .min_vruntime                  : 8051549362.514115
[6130704.522128]   .max_vruntime                  : 0.000001
[6130704.522128]   .spread                        : 0.000000
[6130704.522128]   .spread0                       : 987884970.987889
[6130704.522128]   .nr_running                    : 1
[6130704.522128]   .load                          : 1024
[6130704.522128]   .nr_spread_over                : 11703
[6130704.522128]
[6130704.522128] rt_rq[1]:
[6130704.522128]   .rt_nr_running                 : 0
[6130704.522128]   .rt_throttled                  : 0
[6130704.522128]   .rt_time                       : 0.000000
[6130704.522128]   .rt_runtime                    : 950.000000
[6130704.522128]
[6130704.522128] runnable tasks:
[6130704.522128]             task   PID         tree-key  switches
prio     exec-runtime         sum-exec        sum-sleep
[6130704.522128]
-----------------------------------------------------------------------=
-----------------------------------
[6130704.522128] R           bash 11137 8051549322.514115       272
120 8051549322.514115        35.937180 689280132.211960
[6130704.522128]


Thanks,
=46redrik

On Wed, Oct 21, 2009 at 4:20 AM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Fredrik Andersson wrote:
>>
>> Hi, here is the data for this process:
>
> Including all of the processes in D state (everything reported by sys=
rq-w)
> would probably be most helpful.
>
> Feel free to file an ext4 bug on bugzilla.kernel.org w/ this informat=
ion,
> too, so it doesn't get lost in busy schedules ...
>
> Thanks,
> -Eric
>
>> 5958816.744013] drdbmake =A0 =A0 =A0D ffff88021e4c7800 =A0 =A0 0 270=
19 =A013796
>> [5958816.744013] =A0ffff8801d1bcda88 0000000000000082 ffff8801f4ce9b=
f0
>> ffff8801678b1380
>> [5958816.744013] =A00000000000010e80 000000000000c748 ffff8800404963=
c0
>> ffffffff81526360
>> [5958816.744013] =A0ffff880040496730 00000000f4ce9bf0 000000025819ce=
be
>> 0000000000000282
>> [5958816.744013] Call Trace:
>> [5958816.744013] =A0[<ffffffff813a9639>] schedule+0x9/0x20
>> [5958816.744013] =A0[<ffffffff81177ea5>] start_this_handle+0x365/0x5=
d0
>> [5958816.744013] =A0[<ffffffff8105b900>] ? autoremove_wake_function+=
0x0/
>> 0x40
>> [5958816.744013] =A0[<ffffffff811781ce>] jbd2_journal_restart+0xbe/0=
x150
>> [5958816.744013] =A0[<ffffffff8116243d>] ext4_ext_truncate+0x6dd/0xa=
20
>> [5958816.744013] =A0[<ffffffff81095b3b>] ? find_get_pages+0x3b/0xf0
>> [5958816.744013] =A0[<ffffffff81150a78>] ext4_truncate+0x198/0x680
>> [5958816.744013] =A0[<ffffffff810ac984>] ? unmap_mapping_range+0x74/=
0x280
>> [5958816.744013] =A0[<ffffffff811772c0>] ? jbd2_journal_stop+0x1e0/0=
x360
>> [5958816.744013] =A0[<ffffffff810acd25>] vmtruncate+0xa5/0x110
>> [5958816.744013] =A0[<ffffffff810dda10>] inode_setattr+0x30/0x180
>> [5958816.744013] =A0[<ffffffff8114d073>] ext4_setattr+0x173/0x310
>> [5958816.744013] =A0[<ffffffff810ddc79>] notify_change+0x119/0x330
>> [5958816.744013] =A0[<ffffffff810c6df3>] do_truncate+0x63/0x90
>> [5958816.744013] =A0[<ffffffff810d0cc3>] ? get_write_access+0x23/0x6=
0
>> [5958816.744013] =A0[<ffffffff810c70cb>] sys_truncate+0x17b/0x180
>> [5958816.744013] =A0[<ffffffff8100bfab>] system_call_fastpath+0x16/0=
x1b
>>
>> Don't know if this has anything to do with it, but =A0I also noticed
>> that another process of mine,
>> which is working just fine, is executing a suspicious looking functi=
on
>> called raid0_unplug.
>> It operates on the same raid0/ext4 filesystem as the hung process. I
>> include the calltrace for it here too:
>>
>> [5958816.744013] nodeserv =A0 =A0 =A0D ffff880167bd7ca8 =A0 =A0 0 17=
900 =A013796
>> [5958816.744013] =A0ffff880167bd7bf8 0000000000000082 ffff88002800a5=
88
>> ffff88021e5b56e0
>> [5958816.744013] =A00000000000010e80 000000000000c748 ffff8801006640=
20
>> ffffffff81526360
>> [5958816.744013] =A0ffff880100664390 000000008119bd17 000000026327bf=
a9
>> 0000000000000002
>> [5958816.744013] Call Trace:
>> [5958816.744013] =A0[<ffffffffa0039291>] ? raid0_unplug+0x51/0x70 [r=
aid0]
>> [5958816.744013] =A0[<ffffffff813a9639>] schedule+0x9/0x20
>> [5958816.744013] =A0[<ffffffff813a9687>] io_schedule+0x37/0x50
>> [5958816.744013] =A0[<ffffffff81095e35>] sync_page+0x35/0x60
>> [5958816.744013] =A0[<ffffffff81095e69>] sync_page_killable+0x9/0x50
>> [5958816.744013] =A0[<ffffffff813a99d2>] __wait_on_bit_lock+0x52/0xb=
0
>> [5958816.744013] =A0[<ffffffff81095e60>] ? sync_page_killable+0x0/0x=
50
>> [5958816.744013] =A0[<ffffffff81095d74>] __lock_page_killable+0x64/0=
x70
>> [5958816.744013] =A0[<ffffffff8105b940>] ? wake_bit_function+0x0/0x4=
0
>> [5958816.744013] =A0[<ffffffff81095c0b>] ? find_get_page+0x1b/0xb0
>> [5958816.744013] =A0[<ffffffff81097908>] generic_file_aio_read+0x3b8=
/0x6b0
>> [5958816.744013] =A0[<ffffffff810c7dc1>] do_sync_read+0xf1/0x140
>> [5958816.744013] =A0[<ffffffff8106a5e8>] ? do_futex+0xb8/0xb20
>> [5958816.744013] =A0[<ffffffff813ab78f>] ? _spin_unlock_irqrestore+0=
x2f/0x40
>> [5958816.744013] =A0[<ffffffff8105b900>] ? autoremove_wake_function+=
0x0/0x40
>> [5958816.744013] =A0[<ffffffff8105bc73>] ? add_wait_queue+0x43/0x60
>> [5958816.744013] =A0[<ffffffff81062a6c>] ? getnstimeofday+0x5c/0xf0
>> [5958816.744013] =A0[<ffffffff810c85b8>] vfs_read+0xc8/0x170
>> [5958816.744013] =A0[<ffffffff810c86fa>] sys_pread64+0x9a/0xa0
>> [5958816.744013] =A0[<ffffffff8100bfab>] system_call_fastpath+0x16/0=
x1b
>>
>> Hope this makes sense to anyone, and please let me know if there is
>> more info I can provide.
>>
>> /Fredrik
>>
>> On Sun, Oct 18, 2009 at 5:57 PM, Eric Sandeen <sandeen@redhat.com> w=
rote:
>>>
>>> Fredrik Andersson wrote:
>>>>
>>>> Hi, I'd like to report what I'm fairly certain is an ext4 bug. I h=
ope
>>>> this is the right place to do so.
>>>>
>>>> My program creates a big file (around 30 GB) with posix_fallocate =
(to
>>>> utilize extents), fills it with data and uses ftruncate to crop it=
 to
>>>> its final size (usually somewhere between 20 and 25 GB).
>>>> The problem is that in around 5% of the cases, the program locks u=
p
>>>> completely in a syscall. The process can thus not be killed even w=
ith
>>>> kill -9, and a reboot is all that will do.
>>>
>>> does echo w > /proc/sysrq-trigger (this does sleeping processes; or=
 use
>>> echo t for all processes) show you where the stuck threads are?
>>>
>>> -Eric
>>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
