From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Sun, 22 Jun 2014 23:18:10 +0000
Message-ID: <bug-78651-13602-CsIw79ZmUN@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45225 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaFVXSN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jun 2014 19:18:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 641B82024F
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 23:18:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 73ECD2021A
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 23:18:10 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #2 from Joseph D. Wagner <joe@josephdwagner.info> ---
I changed the script to run "perf record" on the dump command.  I turned
tracing on for all jbd2 and ext4 events.  (I had to stop it about half way
through, because the perf.data file was getting too big.)  All non-zero results
are below.

Are some of these events supposed to be balanced?  For example, there were 8
ext4:ext4_es_shrink_enter, but 0 ext4:ext4_es_shrink_exit.  I'm wondering if
some of this code is being called recursively without proper unwinding.  It
could explain the recursive loss in performance.

499M ext4:ext4_journal_start: 356 chunks LOST!
252M jbd2:jbd2_handle_stats: 4 chunks LOST!
252M jbd2:jbd2_handle_start: 1 chunks LOST!
252M ext4:ext4_mark_inode_dirty: 3 chunks LOST!
246M ext4:ext4_ext_show_extent: 1 chunks LOST!
246M ext4:ext4_ext_map_blocks_exit: 1 chunks LOST!
246M ext4:ext4_ext_map_blocks_enter: 26 chunks LOST!
246M ext4:ext4_es_lookup_extent_exit
246M ext4:ext4_es_lookup_extent_enter: 1 chunks LOST!
246M ext4:ext4_es_insert_extent
246M ext4:ext4_da_write_end: 6 chunks LOST!
246M ext4:ext4_da_write_begin: 441 chunks LOST!
246M ext4:ext4_da_reserve_space
150 ext4:ext4_drop_inode
77 ext4:ext4_releasepage
17 ext4:ext4_es_cache_extent
8 ext4:ext4_sync_fs
8 ext4:ext4_es_shrink_enter
5 ext4:ext4_es_find_delayed_extent_range_exit
5 ext4:ext4_es_find_delayed_extent_range_enter
3 ext4:ext4_request_inode
3 ext4:ext4_allocate_inode
2 ext4:ext4_ext_load_extent

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
