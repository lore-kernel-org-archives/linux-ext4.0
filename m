From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
Date: Thu, 16 Dec 2010 14:50:21 +0100
Message-ID: <1292507421.4885.19.camel@thinkpad>
References: <20101121112611.GB4267@deepthought.bhanu.net>
	 <20101121133024.GF23423@thunk.org>	<20101121133024.GF23423@thunk.org>
	 <20101121153949.GD20947@barrios-desktop>	<20101121173726.GG23423@thunk.org>
	 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
	 <rcu-radix-tree@mdm.bga.com>	<20101122061619.GA2764@linux.vnet.ibm.com>
	 <1291748509.19276.62.camel@thinkpad>
	 <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: gerald.schaefer@de.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: paulmck@linux.vnet.ibm.com, Milton Miller <miltonm@bga.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Arun Bhanu <ab@arunbhanu.com>, Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:44464 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0LPNu3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Dec 2010 08:50:29 -0500
In-Reply-To: <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got the same warning now after increasing /proc/sys/vm/nr_hugepages, see
below. Both cases are easily reproducible: memory unplug with big page cache,
or adding large pages during run-time.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
1 lock held by bash/761:
 #0:  (&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<00000000002263ae>] migrate_page_move_mapping+0x4a/0x2d8

stack backtrace:
CPU: 1 Not tainted 2.6.37-rc6 #4
Process bash (pid: 761, task: 00000000181b5540, ksp: 00000000181bb7f8)
00000000181bb818 00000000181bb798 0000000000000002 0000000000000000 
       00000000181bb838 00000000181bb7b0 00000000181bb7b0 000000000056bafa 
       0000000000000000 000000003f42bdf0 0000000000000002 000000001c43be30 
       000003e00000000d 000003e00000000c 00000000181bb800 0000000000000000 
       0000000000000000 0000000000100bfa 00000000181bb798 00000000181bb7d8 
Call Trace:
([<0000000000100b02>] show_trace+0xee/0x144)
 [<000000000022654e>] migrate_page_move_mapping+0x1ea/0x2d8
 [<0000000000226c80>] migrate_page+0x38/0x68
 [<0000000000226d9a>] move_to_new_page+0xea/0x2bc
 [<000000000022785a>] migrate_pages+0x496/0x568
 [<000000000021e24e>] compact_zone+0x432/0x7d8
 [<000000000021e772>] compact_zone_order+0x9e/0xbc
 [<000000000021ed52>] try_to_compact_pages+0x1ba/0x24c
 [<00000000001e1afa>] __alloc_pages_nodemask+0x86a/0xa64
 [<000000000021c80c>] alloc_fresh_huge_page.clone.2+0x68/0x18c
 [<000000000021cc4c>] set_max_huge_pages.clone.0+0xa4/0x1ac
 [<000000000021ce06>] hugetlb_sysctl_handler+0xb2/0xcc
 [<00000000002a6572>] proc_sys_call_handler+0xe6/0x10c
 [<00000000002a65be>] proc_sys_write+0x26/0x34
 [<00000000002336e0>] vfs_write+0xac/0x18c
 [<00000000002338bc>] SyS_write+0x58/0xa8
 [<0000000000113976>] sysc_noemu+0x16/0x1c
 [<0000020000162edc>] 0x20000162edc
INFO: lockdep is turned off.

I honestly do not understand 100% why this is a false positive, seeing that
e.g. find_get_page() will also use radix_tree_deref_slot(), holding only the
rcu_read_lock, while migrate_page_move_mapping() has no rcu_read_lock() but
the &mapping->tree_lock instead. So I'm not quite sure how to fix this
properly, but simply adding rcu_read_lock/unlock() to the affected code paths,
even if it is not necessary for synchronization, would get rid of the warning,
like in the following patch. Any ideas?

---
 fs/hugetlbfs/inode.c |    2 ++
 mm/migrate.c         |    4 ++++
 2 files changed, 6 insertions(+)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -580,7 +580,9 @@ static int hugetlbfs_migrate_page(struct
 {
 	int rc;
 
+	rcu_read_lock();
 	rc = migrate_huge_page_move_mapping(mapping, newpage, page);
+	rcu_read_unlock();
 	if (rc)
 		return rc;
 	migrate_page_copy(newpage, page);
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -417,7 +417,9 @@ int migrate_page(struct address_space *m
 
 	BUG_ON(PageWriteback(page));	/* Writeback must be complete */
 
+	rcu_read_lock();
 	rc = migrate_page_move_mapping(mapping, newpage, page);
+	rcu_read_unlock();
 
 	if (rc)
 		return rc;
@@ -444,7 +446,9 @@ int buffer_migrate_page(struct address_s
 
 	head = page_buffers(page);
 
+	rcu_read_lock();
 	rc = migrate_page_move_mapping(mapping, newpage, page);
+	rcu_read_unlock();
 
 	if (rc)
 		return rc;


