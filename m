From: Fredrik Andersson <nablaman@gmail.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Mon, 26 Oct 2009 11:43:07 +0100
Message-ID: <a125a870910260343x6a935240jb611daa8afa8f3d3@mail.gmail.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
	 <4ADB3AEC.8040901@redhat.com>
	 <a125a870910190249l39183927i8f042a9ace39904c@mail.gmail.com>
	 <a125a870910200949v5d9d0318q65b0ff6d5a1181e1@mail.gmail.com>
	 <1256084662.4316.4.camel@mingming-laptop>
	 <a125a870910220037j1ceeb19du73c977b8ce3df2b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:64564 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbZJZKnD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Oct 2009 06:43:03 -0400
Received: by ewy4 with SMTP id 4so3448251ewy.37
        for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2009 03:43:07 -0700 (PDT)
In-Reply-To: <a125a870910220037j1ceeb19du73c977b8ce3df2b7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I had the same error again, on another machine. I'm posting the calls
stacks of these hung processes too.
Hope someone can figure this out..

6515054.873144] INFO: task pdflush:269 blocked for more than 120 seconds.
[6515054.873148] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515054.873151] pdflush       D ffff8801f4cf0ad4     0   269      2
[6515054.873156]  ffff88021e551960 0000000000000046 ffff88021e63d6e0
ffff88007ddd1540
[6515054.873161]  0000000000010e80 000000000000c748 ffff88021fa2c020
ffff88021f843900
[6515054.873166]  ffff88021fa2c390 0000000100000008 00000002844bfcb2
0080001000800013
[6515054.873170] Call Trace:
[6515054.873180]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515054.873184]  [<ffffffff813ab2d5>] __down_read+0x85/0xb7
[6515054.873187]  [<ffffffff813aa565>] down_read+0x25/0x30
[6515054.873192]  [<ffffffff8114e6f2>] ext4_get_blocks_wrap+0x52/0x290
[6515054.873196]  [<ffffffff8114f601>] mpage_da_map_blocks+0xd1/0x7a0
[6515054.873202]  [<ffffffff8109d12c>] ? write_cache_pages+0x2fc/0x470
[6515054.873205]  [<ffffffff81150330>] ? __mpage_da_writepage+0x0/0x180
[6515054.873209]  [<ffffffff8114ffdb>] ext4_da_writepages+0x30b/0x590
[6515054.873213]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6515054.873217]  [<ffffffff8109d2f8>] do_writepages+0x28/0x50
[6515054.873222]  [<ffffffff810e60fb>] __writeback_single_inode+0x9b/0x3e0
[6515054.873226]  [<ffffffff8104f830>] ? process_timeout+0x0/0x10
[6515054.873230]  [<ffffffff813a8827>] ? io_schedule_timeout+0x37/0x50
[6515054.873234]  [<ffffffff810e68ec>] generic_sync_sb_inodes+0x36c/0x440
[6515054.873237]  [<ffffffff810e6b8e>] writeback_inodes+0x5e/0x100
[6515054.873241]  [<ffffffff8109d4ac>] wb_kupdate+0xbc/0x140
[6515054.873244]  [<ffffffff8109e6a8>] pdflush+0x118/0x220
[6515054.873248]  [<ffffffff8109d3f0>] ? wb_kupdate+0x0/0x140
[6515054.873251]  [<ffffffff8109e590>] ? pdflush+0x0/0x220
[6515054.873255]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6515054.873259]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6515054.873263]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6515054.873266]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6515054.873270]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6515054.873275] INFO: task kjournald2:1334 blocked for more than 120 seconds.
[6515054.873277] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515054.873279] kjournald2    D ffff88021e731e28     0  1334      2
[6515054.873283]  ffff88021e731d10 0000000000000046 ffff88021e731ca0
ffffffff813a9b3b
[6515054.873288]  0000000000010e80 000000000000c748 ffff88021f9c5580
ffff88021f843900
[6515054.873292]  ffff88021f9c58f0 0000000100000282 00000002844c0480
0000000000000282
[6515054.873296] Call Trace:
[6515054.873300]  [<ffffffff813a9b3b>] ? __wait_on_bit+0x7b/0x90
[6515054.873303]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515054.873308]  [<ffffffff81178ebe>]
jbd2_journal_commit_transaction+0x1be/0x1810
[6515054.873312]  [<ffffffff81040cd6>] ? dequeue_task_fair+0x256/0x260
[6515054.873315]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6515054.873320]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515054.873324]  [<ffffffff8117ea8a>] kjournald2+0x11a/0x370
[6515054.873327]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515054.873330]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6515054.873333]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6515054.873337]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6515054.873340]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6515054.873344]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6515054.873347]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6515054.873351]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6515054.873361] INFO: task drdbmake:3919 blocked for more than 120 seconds.
[6515054.873363] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515054.873365] drdbmake      D ffff88021e56f000     0  3919  27107
[6515054.873369]  ffff88021eb4da88 0000000000000082 ffff8801f4cf0ae8
ffff880008ba03f0
[6515054.873374]  0000000000010e80 000000000000c748 ffff8801049063c0
ffff88021f843900
[6515054.873378]  ffff880104906730 00000001f4cf0ae8 00000002844c0480
0000000000000282
[6515054.873382] Call Trace:
[6515054.873386]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515054.873390]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6515054.873394]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515054.873397]  [<ffffffff811781ce>] jbd2_journal_restart+0xbe/0x150
[6515054.873402]  [<ffffffff8116243d>] ext4_ext_truncate+0x6dd/0xa20
[6515054.873406]  [<ffffffff81095b3b>] ? find_get_pages+0x3b/0xf0
[6515054.873409]  [<ffffffff81150a78>] ext4_truncate+0x198/0x680
[6515054.873414]  [<ffffffff810ac984>] ? unmap_mapping_range+0x74/0x280
[6515054.873418]  [<ffffffff811772c0>] ? jbd2_journal_stop+0x1e0/0x360
[6515054.873422]  [<ffffffff810acd25>] vmtruncate+0xa5/0x110
[6515054.873426]  [<ffffffff810dda10>] inode_setattr+0x30/0x180
[6515054.873430]  [<ffffffff8114d073>] ext4_setattr+0x173/0x310
[6515054.873433]  [<ffffffff810ddc79>] notify_change+0x119/0x330
[6515054.873438]  [<ffffffff810c6df3>] do_truncate+0x63/0x90
[6515054.873441]  [<ffffffff810d0cc3>] ? get_write_access+0x23/0x60
[6515054.873445]  [<ffffffff810c70cb>] sys_truncate+0x17b/0x180
[6515054.873448]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6515174.873066] INFO: task pdflush:269 blocked for more than 120 seconds.
[6515174.873070] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515174.873074] pdflush       D ffff8801f4cf0ad4     0   269      2
[6515174.873079]  ffff88021e551960 0000000000000046 ffff88021e63d6e0
ffff88007ddd1540
[6515174.873085]  0000000000010e80 000000000000c748 ffff88021fa2c020
ffff88021f843900
[6515174.873090]  ffff88021fa2c390 0000000100000008 00000002844bfcb2
0080001000800013
[6515174.873096] Call Trace:
[6515174.873106]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515174.873110]  [<ffffffff813ab2d5>] __down_read+0x85/0xb7
[6515174.873115]  [<ffffffff813aa565>] down_read+0x25/0x30
[6515174.873120]  [<ffffffff8114e6f2>] ext4_get_blocks_wrap+0x52/0x290
[6515174.873124]  [<ffffffff8114f601>] mpage_da_map_blocks+0xd1/0x7a0
[6515174.873138]  [<ffffffff8109d12c>] ? write_cache_pages+0x2fc/0x470
[6515174.873146]  [<ffffffff81150330>] ? __mpage_da_writepage+0x0/0x180
[6515174.873155]  [<ffffffff8114ffdb>] ext4_da_writepages+0x30b/0x590
[6515174.873164]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6515174.873172]  [<ffffffff8109d2f8>] do_writepages+0x28/0x50
[6515174.873181]  [<ffffffff810e60fb>] __writeback_single_inode+0x9b/0x3e0
[6515174.873190]  [<ffffffff8104f830>] ? process_timeout+0x0/0x10
[6515174.873197]  [<ffffffff813a8827>] ? io_schedule_timeout+0x37/0x50
[6515174.873206]  [<ffffffff810e68ec>] generic_sync_sb_inodes+0x36c/0x440
[6515174.873214]  [<ffffffff810e6b8e>] writeback_inodes+0x5e/0x100
[6515174.873222]  [<ffffffff8109d4ac>] wb_kupdate+0xbc/0x140
[6515174.873230]  [<ffffffff8109e6a8>] pdflush+0x118/0x220
[6515174.873238]  [<ffffffff8109d3f0>] ? wb_kupdate+0x0/0x140
[6515174.873245]  [<ffffffff8109e590>] ? pdflush+0x0/0x220
[6515174.873253]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6515174.873261]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6515174.873269]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6515174.873277]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6515174.873284]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6515174.873303] INFO: task kjournald2:1334 blocked for more than 120 seconds.
[6515174.873308] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515174.873314] kjournald2    D ffff88021e731e28     0  1334      2
[6515174.873322]  ffff88021e731d10 0000000000000046 ffff88021e731ca0
ffffffff813a9b3b
[6515174.873333]  0000000000010e80 000000000000c748 ffff88021f9c5580
ffff88021f843900
[6515174.873344]  ffff88021f9c58f0 0000000100000282 00000002844c0480
0000000000000282
[6515174.873355] Call Trace:
[6515174.873360]  [<ffffffff813a9b3b>] ? __wait_on_bit+0x7b/0x90
[6515174.873367]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515174.873375]  [<ffffffff81178ebe>]
jbd2_journal_commit_transaction+0x1be/0x1810
[6515174.873382]  [<ffffffff81040cd6>] ? dequeue_task_fair+0x256/0x260
[6515174.873389]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6515174.873396]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515174.873404]  [<ffffffff8117ea8a>] kjournald2+0x11a/0x370
[6515174.873411]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515174.873418]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6515174.873424]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6515174.873431]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6515174.873437]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6515174.873444]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6515174.873450]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6515174.873457]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6515174.873470] INFO: task drdbmake:3919 blocked for more than 120 seconds.
[6515174.873475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515174.873480] drdbmake      D ffff88021e56f000     0  3919  27107
[6515174.873489]  ffff88021eb4da88 0000000000000082 ffff8801f4cf0ae8
ffff880008ba03f0
[6515174.873499]  0000000000010e80 000000000000c748 ffff8801049063c0
ffff88021f843900
[6515174.873510]  ffff880104906730 00000001f4cf0ae8 00000002844c0480
0000000000000282
[6515174.873521] Call Trace:
[6515174.873526]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515174.873534]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6515174.873541]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515174.873548]  [<ffffffff811781ce>] jbd2_journal_restart+0xbe/0x150
[6515174.873556]  [<ffffffff8116243d>] ext4_ext_truncate+0x6dd/0xa20
[6515174.873563]  [<ffffffff81095b3b>] ? find_get_pages+0x3b/0xf0
[6515174.873569]  [<ffffffff81150a78>] ext4_truncate+0x198/0x680
[6515174.873578]  [<ffffffff810ac984>] ? unmap_mapping_range+0x74/0x280
[6515174.873585]  [<ffffffff811772c0>] ? jbd2_journal_stop+0x1e0/0x360
[6515174.873592]  [<ffffffff810acd25>] vmtruncate+0xa5/0x110
[6515174.873600]  [<ffffffff810dda10>] inode_setattr+0x30/0x180
[6515174.873607]  [<ffffffff8114d073>] ext4_setattr+0x173/0x310
[6515174.873614]  [<ffffffff810ddc79>] notify_change+0x119/0x330
[6515174.873621]  [<ffffffff810c6df3>] do_truncate+0x63/0x90
[6515174.873628]  [<ffffffff810d0cc3>] ? get_write_access+0x23/0x60
[6515174.873635]  [<ffffffff810c70cb>] sys_truncate+0x17b/0x180
[6515174.873642]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6515294.873034] INFO: task pdflush:269 blocked for more than 120 seconds.
[6515294.873038] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515294.873041] pdflush       D ffff8801f4cf0ad4     0   269      2
[6515294.873046]  ffff88021e551960 0000000000000046 ffff88021e63d6e0
ffff88007ddd1540
[6515294.873053]  0000000000010e80 000000000000c748 ffff88021fa2c020
ffff88021f843900
[6515294.873058]  ffff88021fa2c390 0000000100000008 00000002844bfcb2
0080001000800013
[6515294.873063] Call Trace:
[6515294.873073]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515294.873078]  [<ffffffff813ab2d5>] __down_read+0x85/0xb7
[6515294.873082]  [<ffffffff813aa565>] down_read+0x25/0x30
[6515294.873088]  [<ffffffff8114e6f2>] ext4_get_blocks_wrap+0x52/0x290
[6515294.873092]  [<ffffffff8114f601>] mpage_da_map_blocks+0xd1/0x7a0
[6515294.873099]  [<ffffffff8109d12c>] ? write_cache_pages+0x2fc/0x470
[6515294.873103]  [<ffffffff81150330>] ? __mpage_da_writepage+0x0/0x180
[6515294.873107]  [<ffffffff8114ffdb>] ext4_da_writepages+0x30b/0x590
[6515294.873112]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6515294.873117]  [<ffffffff8109d2f8>] do_writepages+0x28/0x50
[6515294.873123]  [<ffffffff810e60fb>] __writeback_single_inode+0x9b/0x3e0
[6515294.873136]  [<ffffffff8104f830>] ? process_timeout+0x0/0x10
[6515294.873144]  [<ffffffff813a8827>] ? io_schedule_timeout+0x37/0x50
[6515294.873153]  [<ffffffff810e68ec>] generic_sync_sb_inodes+0x36c/0x440
[6515294.873161]  [<ffffffff810e6b8e>] writeback_inodes+0x5e/0x100
[6515294.873169]  [<ffffffff8109d4ac>] wb_kupdate+0xbc/0x140
[6515294.873177]  [<ffffffff8109e6a8>] pdflush+0x118/0x220
[6515294.873185]  [<ffffffff8109d3f0>] ? wb_kupdate+0x0/0x140
[6515294.873192]  [<ffffffff8109e590>] ? pdflush+0x0/0x220
[6515294.873200]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6515294.873209]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6515294.873217]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6515294.873224]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6515294.873232]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6515294.873241] INFO: task kjournald2:1334 blocked for more than 120 seconds.
[6515294.873247] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515294.873253] kjournald2    D ffff88021e731e28     0  1334      2
[6515294.873273]  ffff88021e731d10 0000000000000046 ffff88021e731ca0
ffffffff813a9b3b
[6515294.873284]  0000000000010e80 000000000000c748 ffff88021f9c5580
ffff88021f843900
[6515294.873294]  ffff88021f9c58f0 0000000100000282 00000002844c0480
0000000000000282
[6515294.873305] Call Trace:
[6515294.873311]  [<ffffffff813a9b3b>] ? __wait_on_bit+0x7b/0x90
[6515294.873318]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515294.873326]  [<ffffffff81178ebe>]
jbd2_journal_commit_transaction+0x1be/0x1810
[6515294.873334]  [<ffffffff81040cd6>] ? dequeue_task_fair+0x256/0x260
[6515294.873341]  [<ffffffff8103d91b>] ? finish_task_switch+0x5b/0xd0
[6515294.873349]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515294.873356]  [<ffffffff8117ea8a>] kjournald2+0x11a/0x370
[6515294.873363]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515294.873369]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6515294.873375]  [<ffffffff8117e970>] ? kjournald2+0x0/0x370
[6515294.873382]  [<ffffffff8105b4c6>] kthread+0x56/0x90
[6515294.873389]  [<ffffffff8100cf6a>] child_rip+0xa/0x20
[6515294.873395]  [<ffffffff8100c969>] ? restore_args+0x0/0x30
[6515294.873402]  [<ffffffff8105b470>] ? kthread+0x0/0x90
[6515294.873408]  [<ffffffff8100cf60>] ? child_rip+0x0/0x20
[6515294.873418] INFO: task receptd:5709 blocked for more than 120 seconds.
[6515294.873423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515294.873428] receptd       D 000000000000002a     0  5709   2046
[6515294.873436]  ffff88009cce3c78 0000000000000086 ffff88009cce3be8
ffffffff81152dd3
[6515294.873447]  0000000000010e80 000000000000c748 ffff880104901c80
ffffffff81526360
[6515294.873457]  ffff880104901ff0 00000000810db183 00000002844fcb53
0000000000000286
[6515294.873468] Call Trace:
[6515294.873473]  [<ffffffff81152dd3>] ? dx_release+0x23/0x50
[6515294.873480]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515294.873488]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6515294.873495]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515294.873502]  [<ffffffff81178306>] jbd2_journal_start+0xa6/0xf0
[6515294.873510]  [<ffffffff811593c5>] ext4_journal_start_sb+0x55/0x90
[6515294.873517]  [<ffffffff81155441>] ext4_create+0x81/0x130
[6515294.873524]  [<ffffffff810d23aa>] vfs_create+0x9a/0xb0
[6515294.873531]  [<ffffffff810d522e>] do_filp_open+0x85e/0x990
[6515294.873538]  [<ffffffff810d1d16>] ? getname+0x36/0x200
[6515294.873545]  [<ffffffff810deada>] ? alloc_fd+0x4a/0x140
[6515294.873552]  [<ffffffff810c5dfb>] do_sys_open+0x7b/0x110
[6515294.873558]  [<ffffffff810c5ebb>] sys_open+0x1b/0x20
[6515294.873565]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[6515294.873575] INFO: task drdbmake:3919 blocked for more than 120 seconds.
[6515294.873580] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6515294.873586] drdbmake      D ffff88021e56f000     0  3919  27107
[6515294.873594]  ffff88021eb4da88 0000000000000082 ffff8801f4cf0ae8
ffff880008ba03f0
[6515294.873605]  0000000000010e80 000000000000c748 ffff8801049063c0
ffff88021f843900
[6515294.873616]  ffff880104906730 00000001f4cf0ae8 00000002844c0480
0000000000000282
[6515294.873627] Call Trace:
[6515294.873633]  [<ffffffff813a9639>] schedule+0x9/0x20
[6515294.873640]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
[6515294.873647]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
[6515294.873654]  [<ffffffff811781ce>] jbd2_journal_restart+0xbe/0x150
[6515294.873662]  [<ffffffff8116243d>] ext4_ext_truncate+0x6dd/0xa20
[6515294.873669]  [<ffffffff81095b3b>] ? find_get_pages+0x3b/0xf0
[6515294.873676]  [<ffffffff81150a78>] ext4_truncate+0x198/0x680
[6515294.873685]  [<ffffffff810ac984>] ? unmap_mapping_range+0x74/0x280
[6515294.873692]  [<ffffffff811772c0>] ? jbd2_journal_stop+0x1e0/0x360
[6515294.873700]  [<ffffffff810acd25>] vmtruncate+0xa5/0x110
[6515294.873707]  [<ffffffff810dda10>] inode_setattr+0x30/0x180
[6515294.873714]  [<ffffffff8114d073>] ext4_setattr+0x173/0x310
[6515294.873721]  [<ffffffff810ddc79>] notify_change+0x119/0x330
[6515294.873728]  [<ffffffff810c6df3>] do_truncate+0x63/0x90
[6515294.873734]  [<ffffffff810d0cc3>] ? get_write_access+0x23/0x60
[6515294.873741]  [<ffffffff810c70cb>] sys_truncate+0x17b/0x180
[6515294.873747]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
