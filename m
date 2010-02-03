From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: 2.6.33-rc6: ext4 triggers warning about high order allocations
Date: Wed, 3 Feb 2010 08:08:55 +0200
Message-ID: <20100203060854.GA12489@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0BCGMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2010 01:12:10 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!
I got this warning at boot with 2.6.33-rc6:

[   12.374168] ------------[ cut here ]------------
[   12.375798] WARNING: at mm/page_alloc.c:1813 __alloc_pages_nodemask+0x180/0x666()
[   12.377401] Hardware name: 2241B48
[   12.378984] Modules linked in: [last unloaded: scsi_wait_scan]
[   12.380593] Pid: 1, comm: init Not tainted 2.6.33-rc6-aa-nopat #50
[   12.382194] Call Trace:
[   12.383781]  [<ffffffff810b6b3e>] ? __alloc_pages_nodemask+0x180/0x666
[   12.385390]  [<ffffffff81041cda>] warn_slowpath_common+0x77/0xa4
[   12.386996]  [<ffffffff81041d16>] warn_slowpath_null+0xf/0x11
[   12.388577]  [<ffffffff810b6b3e>] __alloc_pages_nodemask+0x180/0x666
[   12.390168]  [<ffffffff81036a9b>] ? finish_task_switch+0x4b/0xb1
[   12.391758]  [<ffffffff810b7036>] __get_free_pages+0x12/0x4f
[   12.393354]  [<ffffffff810de892>] __kmalloc+0x42/0x116
[   12.394934]  [<ffffffff812405bf>] match_number+0x35/0x98
[   12.396493]  [<ffffffff8124064d>] match_int+0xb/0xd
[   12.398045]  [<ffffffff81169c8c>] parse_options+0x5fe/0x733
[   12.399594]  [<ffffffff811058c3>] ? __wait_on_buffer+0x1f/0x21
[   12.401157]  [<ffffffff8116a2dc>] ext4_fill_super+0x373/0x2070
[   12.402696]  [<ffffffff8123ede2>] ? snprintf+0x59/0x5b
[   12.404229]  [<ffffffff815cb293>] ? _raw_spin_unlock_irq+0x24/0x2f
[   12.405764]  [<ffffffff815cae1a>] ? __down_write+0xb/0xd
[   12.407293]  [<ffffffff810e68fe>] get_sb_bdev+0x12a/0x175
[   12.408815]  [<ffffffff81169f69>] ? ext4_fill_super+0x0/0x2070
[   12.410336]  [<ffffffff81167b7f>] ext4_get_sb+0x13/0x15
[   12.411843]  [<ffffffff810e64e5>] vfs_kern_mount+0x9d/0x158
[   12.413355]  [<ffffffff810e65fd>] do_kern_mount+0x47/0xe7
[   12.414859]  [<ffffffff810fbdf3>] do_mount+0x780/0x7f9
[   12.416362]  [<ffffffff810b7036>] ? __get_free_pages+0x12/0x4f
[   12.417855]  [<ffffffff81119838>] compat_sys_mount+0x1ee/0x227
[   12.419339]  [<ffffffff810e2594>] ? do_sys_open+0xf5/0x104
[   12.420831]  [<ffffffff8102b112>] ia32_sysret+0x0/0x5
[   12.422307] ---[ end trace f5edc87c0d05d4ad ]---
[   12.425039] EXT4-fs (sda8): INFO: recovery required on readonly filesystem
[   12.426552] EXT4-fs (sda8): write access will be enabled during recovery
[   14.342227] EXT4-fs (sda8): orphan cleanup on readonly fs
[   14.343756] EXT4-fs (sda8): ext4_orphan_cleanup: deleting unreferenced inode 54847
[   14.343818] EXT4-fs (sda8): ext4_orphan_cleanup: deleting unreferenced inode 54846
[   14.343830] EXT4-fs (sda8): 2 orphan inodes deleted
[   14.345342] EXT4-fs (sda8): recovery complete
[   14.761956] EXT4-fs (sda8): mounted filesystem with ordered data mode


I have not noticed this warning previously on the same kernel, so it's not
easily reproducible.  The system functions fine after this: __GFP_NOWARN
missing somewhere?

Thanks,

-- 
MST
