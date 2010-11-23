From: Nick Piggin <npiggin@kernel.dk>
Subject: [bug] ext4 bug
Date: Tue, 23 Nov 2010 20:32:01 +1100
Message-ID: <20101123093201.GA4131@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:26713 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab0KWJcI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 04:32:08 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Got a couple of ext4 bugs. modprobe ext4 ; # use it ; rmmod ext4 ;
modprobe ext4 reproduced it twice.

Seems to not deallocate the kobject stuff properly, and then probably
something in an error path is doing a double free and corrupting stuff.


[ 1234.475241]
=============================================================================
[ 1234.475503] BUG kmalloc-32: Object already free
[ 1234.475665]
-----------------------------------------------------------------------------
[ 1234.475668] 
[ 1234.476076] INFO: Allocated in kmem_cache_create+0x65/0x2d0
age=1104271 cpu=0 pid=1492
[ 1234.476332] INFO: Freed in kmem_cache_release+0x16/0x30 age=1 cpu=13
pid=27603
[ 1234.476584] INFO: Slab 0xffffea0003cf5cd8 objects=39 used=9
fp=0xffff880116acd750 flags=0x40000000000000c1
[ 1234.476842] INFO: Object 0xffff880116acd6e8 @offset=1768
fp=0xffff880116acd478
[ 1234.476845] 
[ 1234.477244] Bytes b4 0xffff880116acd6d8:  00 00 00 00 00 00 00 00 5a
5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[ 1234.478696]   Object 0xffff880116acd6e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1234.480152]   Object 0xffff880116acd6f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk?
[ 1234.481604]  Redzone 0xffff880116acd708:  bb bb bb bb bb bb bb bb
????????        
[ 1234.483059]  Padding 0xffff880116acd748:  5a 5a 5a 5a 5a 5a 5a 5a
ZZZZZZZZ        
[ 1234.484512] Pid: 27603, comm: rmmod Not tainted 2.6.37-rc3+ #27
[ 1234.484679] Call Trace:
[ 1234.484837]  [<ffffffff8110bb1e>] print_trailer+0xfe/0x160
[ 1234.485025]  [<ffffffffa00626a7>] ? ext4_exit_mballoc+0x67/0x80
[ext4]
[ 1234.485196]  [<ffffffff8110bbbc>] object_err+0x3c/0x50
[ 1234.485362]  [<ffffffff8110e015>] free_debug_processing+0x1f5/0x250
[ 1234.485546]  [<ffffffffa00626a7>] ? ext4_exit_mballoc+0x67/0x80
[ext4]
[ 1234.485719]  [<ffffffff8110e5d4>] __slab_free+0x1b4/0x1e0
[ 1234.485891]  [<ffffffff8110e71c>] kfree+0x11c/0x1c0
[ 1234.486071]  [<ffffffffa00626a7>] ? ext4_exit_mballoc+0x67/0x80
[ext4]
[ 1234.486258]  [<ffffffffa00626a7>] ext4_exit_mballoc+0x67/0x80 [ext4]
[ 1234.486444]  [<ffffffffa0070e23>] ext4_exit_fs+0xfb/0x12e [ext4]
[ 1234.486619]  [<ffffffff81083b4d>] ? trace_hardirqs_on+0xd/0x10
[ 1234.486791]  [<ffffffff810904ea>] sys_delete_module+0x17a/0x270
[ 1234.486964]  [<ffffffff816036ad>] ? retint_swapgs+0xe/0x13
[ 1234.487133]  [<ffffffff81083afd>] ?
trace_hardirqs_on_caller+0x13d/0x180
[ 1234.487306]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[ 1234.487477] FIX kmalloc-32: Object at 0xffff880116acd6e8 not freed
[ 1243.592427] ------------[ cut here ]------------
[ 1243.592595] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xce/0x200()
[ 1243.592757] Hardware name: S5520UR
[ 1243.592921] sysfs: cannot create duplicate filename '/fs/ext4'
[ 1243.593081] Modules linked in: ext4(+) jbd2 crc16 brd [last unloaded:
ext4]
[ 1243.593642] Pid: 27865, comm: modprobe Not tainted 2.6.37-rc3+ #27
[ 1243.593800] Call Trace:
[ 1243.593964]  [<ffffffff810497ea>] warn_slowpath_common+0x7a/0xb0
[ 1243.594129]  [<ffffffff810498c1>] warn_slowpath_fmt+0x41/0x50
[ 1243.594289]  [<ffffffff8118c35e>] sysfs_add_one+0xce/0x200
[ 1243.594447]  [<ffffffff8118c50c>] create_dir+0x7c/0xd0
[ 1243.594607]  [<ffffffff8118c5dc>] sysfs_create_dir+0x7c/0xd0
[ 1243.594771]  [<ffffffff8127949b>] kobject_add_internal+0xab/0x1f0
[ 1243.594954]  [<ffffffff8127960f>] kset_register+0x2f/0x60
[ 1243.595118]  [<ffffffff81279c9f>] kset_create_and_add+0x8f/0x1c0
[ 1243.595287]  [<ffffffffa00ff11e>] ? ext4_init_fs+0x0/0x139 [ext4]
[ 1243.595454]  [<ffffffffa00ff15a>] ext4_init_fs+0x3c/0x139 [ext4]
[ 1243.595617]  [<ffffffff810001de>] do_one_initcall+0x3e/0x180
[ 1243.595780]  [<ffffffff81093ba2>] sys_init_module+0xb2/0x200
[ 1243.595949]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b
[ 1243.596113] ---[ end trace 8766368be9c85c43 ]---
[ 1243.596279] kobject_add_internal failed for ext4 with -EEXIST, don't
try to register things with the same name in the same directory.
[ 1243.596538] Pid: 27865, comm: modprobe Tainted: G        W
2.6.37-rc3+ #27
[ 1243.596711] Call Trace:
[ 1243.596865]  [<ffffffff8127953c>] kobject_add_internal+0x14c/0x1f0
[ 1243.597043]  [<ffffffff8127960f>] kset_register+0x2f/0x60
[ 1243.597208]  [<ffffffff81279c9f>] kset_create_and_add+0x8f/0x1c0
[ 1243.597377]  [<ffffffffa00ff11e>] ? ext4_init_fs+0x0/0x139 [ext4]
[ 1243.597545]  [<ffffffffa00ff15a>] ext4_init_fs+0x3c/0x139 [ext4]
[ 1243.597710]  [<ffffffff810001de>] do_one_initcall+0x3e/0x180
[ 1243.597872]  [<ffffffff81093ba2>] sys_init_module+0xb2/0x200
[ 1243.598085]  [<ffffffff8100312b>] system_call_fastpath+0x16/0x1b

