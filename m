From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: circular locking dependency detected
Date: Fri, 30 Nov 2007 13:04:46 +0530
Message-ID: <20071130073446.GA7864@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lkml <linux-kernel@vger.kernel.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44120 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652AbXK3HfR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2007 02:35:17 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc3 #6
-------------------------------------------------------
bash/2294 is trying to acquire lock:
(&journal->j_list_lock){--..}, at: [<c01eee2f>] journal_try_to_free_buffers+0x76/0x10c

but task is already holding lock:
(inode_lock){--..}, at: [<c01864b6>] drop_pagecache+0x48/0xd8

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (inode_lock){--..}:
[<c0143929>] __lock_acquire+0xa31/0xc1a
[<c0143b8c>] lock_acquire+0x7a/0x94
[<c0447ae5>] _spin_lock+0x2e/0x58
[<c0185fae>] __mark_inode_dirty+0xd8/0x15e
[<c018996f>] __set_page_dirty+0xfb/0x10a
[<c01899fe>] mark_buffer_dirty+0x80/0x86
[<c01ed1b6>] __journal_temp_unlink_buffer+0xc1/0xc5
[<c01ed2f3>] __journal_unfile_buffer+0xb/0x15
[<c01ed338>] __journal_refile_buffer+0x3b/0x85
[<c01efe1b>] journal_commit_transaction+0xe7f/0x10ec
[<c01f34b0>] kjournald+0x131/0x35f
[<c0138ee9>] kthread+0x3b/0x62
[<c0105c7f>] kernel_thread_helper+0x7/0x10
[<ffffffff>] 0xffffffff

-> #0 (&journal->j_list_lock){--..}:
[<c0143819>] __lock_acquire+0x921/0xc1a
[<c0143b8c>] lock_acquire+0x7a/0x94
[<c0447ae5>] _spin_lock+0x2e/0x58
[<c01eee2f>] journal_try_to_free_buffers+0x76/0x10c
[<c01cb7a2>] ext3_releasepage+0x68/0x74
[<c0151ff1>] try_to_release_page+0x33/0x44
[<c01578b0>] __invalidate_mapping_pages+0x74/0xe0
[<c01864de>] drop_pagecache+0x70/0xd8
[<c018657c>] drop_caches_sysctl_handler+0x36/0x4e
[<c019efaa>] proc_sys_write+0x6b/0x85
[<c016da2b>] vfs_write+0x90/0x119
[<c016dfe2>] sys_write+0x3d/0x61
[<c0104f6e>] sysenter_past_esp+0x5f/0xa5
[<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by bash/2294:
#0:  (&type->s_umount_key#16){----}, at: [<c01864a6>] drop_pagecache+0x38/0xd8
#1:  (inode_lock){--..}, at: [<c01864b6>] drop_pagecache+0x48/0xd8

stack backtrace:
[<c0105ffb>] show_trace_log_lvl+0x1a/0x2f
[<c0106875>] show_trace+0x12/0x14
[<c0106967>] dump_stack+0x16/0x18
[<c0141b33>] print_circular_bug_tail+0x5f/0x68
[<c0143819>] __lock_acquire+0x921/0xc1a
[<c0143b8c>] lock_acquire+0x7a/0x94
[<c0447ae5>] _spin_lock+0x2e/0x58
[<c01eee2f>] journal_try_to_free_buffers+0x76/0x10c
[<c01cb7a2>] ext3_releasepage+0x68/0x74
[<c0151ff1>] try_to_release_page+0x33/0x44
[<c01578b0>] __invalidate_mapping_pages+0x74/0xe0
[<c01864de>] drop_pagecache+0x70/0xd8
[<c018657c>] drop_caches_sysctl_handler+0x36/0x4e
[<c019efaa>] proc_sys_write+0x6b/0x85
[<c016da2b>] vfs_write+0x90/0x119
[<c016dfe2>] sys_write+0x3d/0x61
[<c0104f6e>] sysenter_past_esp+0x5f/0xa5
=======================
