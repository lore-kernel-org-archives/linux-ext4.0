From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
Date: Tue, 07 Dec 2010 20:01:49 +0100
Message-ID: <1291748509.19276.62.camel@thinkpad>
References: <20101121112611.GB4267@deepthought.bhanu.net>
	 <20101121133024.GF23423@thunk.org> <20101121133024.GF23423@thunk.org>
	 <20101121153949.GD20947@barrios-desktop> <20101121173726.GG23423@thunk.org>
	 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
	 <rcu-radix-tree@mdm.bga.com>  <20101122061619.GA2764@linux.vnet.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Milton Miller <miltonm@bga.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Arun Bhanu <ab@arunbhanu.com>, Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: paulmck@linux.vnet.ibm.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:52877 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab0LGTC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 14:02:29 -0500
In-Reply-To: <20101122061619.GA2764@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got the same warning as reported by Arun Bhanu in "[BUG?] [Ext4] INFO:
suspicious rcu_dereference_check() usage" during memory hotplug test on
2.6.37-rc5, see below.

migrate_pages() -> unmap_and_move() only calls rcu_read_lock() for anonymous
pages, as introduced by git commit 989f89c57e6361e7d16fbd9572b5da7d313b073d.
This should be ok, as the comment suggests, so the warning is probably a
false positive. Eventually, migrate_page_move_mapping() will call
radix_tree_deref_slot() with tree_lock held, but w/o rcu_read_lock() for
non-anonymous pages.

As suggested by Milton before, a new version of radix_tree_deref_slot that
uses rcu_dereference_protected could help, if this is a false positive, or
maybe the rcu_read_lock() should be called for all pages, not just anonymous.
Any thoughts?


===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
6 locks held by sh/960:
 #0:  (&buffer->mutex){+.+.+.}, at: [<00000000002afa7a>] sysfs_write_file+0x4a/0x1a8
 #1:  (s_active#52){.+.+.+}, at: [<00000000002afb02>] sysfs_write_file+0xd2/0x1a8
 #2:  (&mem->state_mutex){+.+.+.}, at: [<0000000000404d78>] memory_block_change_state+0x40/0x1a0
 #3:  (mem_hotplug_mutex){+.+.+.}, at: [<00000000002242c4>] lock_memory_hotplug+0x2c/0x44
 #4:  (pm_mutex){+.+.+.}, at: [<000000000022483c>] remove_memory+0x104/0x758
 #5:  (&(&inode->i_data.tree_lock)->rlock){..-...}, at: [<000000000022624a>] migrate_page_move_mapping+0x4a/0x2d8

stack backtrace:
CPU: 2 Not tainted 2.6.37-rc5 #2
Process sh (pid: 960, task: 0000000018e38640, ksp: 000000000f037818)
000000000f037ad8 000000000f037a58 0000000000000002 0000000000000000
       000000000f037af8 000000000f037a70 000000000f037a70 0000000000567c42
       0000000000000000 0000000017bd7e78 0000000000000002 0000000017bd2e30
       000003e00000000d 000003e00000000c 000000000f037ac0 0000000000000000
       0000000000000000 0000000000100bfa 000000000f037a58 000000000f037a98
Call Trace:
([<0000000000100b02>] show_trace+0xee/0x144)
 [<00000000002263ea>] migrate_page_move_mapping+0x1ea/0x2d8
 [<0000000000226b1c>] migrate_page+0x38/0x68
 [<0000000000226c36>] move_to_new_page+0xea/0x2bc
 [<00000000002276f6>] migrate_pages+0x496/0x568
 [<0000000000224be6>] remove_memory+0x4ae/0x758
 [<0000000000404e20>] memory_block_change_state+0xe8/0x1a0
 [<0000000000404fda>] store_mem_state+0x102/0x138
 [<00000000002afb26>] sysfs_write_file+0xf6/0x1a8
 [<000000000023357c>] vfs_write+0xac/0x18c
 [<0000000000233758>] SyS_write+0x58/0xa8
 [<0000000000113976>] sysc_noemu+0x16/0x1c
 [<0000020000162edc>] 0x20000162edc
INFO: lockdep is turned off.


