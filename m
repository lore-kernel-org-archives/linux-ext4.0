From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] non-contiguous files (64.9%) on a ext4 fs
Date: Mon, 10 Aug 2009 12:04:15 GMT
Message-ID: <200908101204.n7AC4FKt006399@demeter.kernel.org>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37078 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbZHJMEO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 08:04:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7AC4Fq0006400
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 12:04:15 GMT
In-Reply-To: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13930





--- Comment #5 from Theodore Tso <tytso@mit.edu>  2009-08-10 12:04:13 ---
I did some more looking at this issue.   The root cause is pdflush, which is
the daemon that starts forcing background writes when 10% of the available page
cache is dirty.   It will write out a maximum of 1024 blocks per page, because
of a hard-coded limit in mm/page-writeback.c:

/*
 * The maximum number of pages to writeout in a single bdflush/kupdate
 * operation.  We do this so we don't hold I_SYNC against an inode for
 * enormous amounts of time, which would block a userspace task which has
 * been forced to throttle against that inode.  Also, the code reevaluates
 * the dirty each time it has written this many pages.
 */
#define MAX_WRITEBACK_PAGES    1024

The means that background_writeout() in mm/page-writeback.c only calls
ext4_da_writepages requesting a writeout of 1024 pages, which we can see if we
put a trace on ext4_da_writepages after writing a very large file:

         pdflush-398   [000]  5743.853396: ext4_da_writepages: dev sdc1 ino 12
nr_t_write 1024 pages_skipped 0 range_start 0 range_end 0 nonblock
ing 1 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1
         pdflush-398   [000]  5743.858988: ext4_da_writepages_result: dev sdc1
ino 12 ret 0 pages_written 1024 pages_skipped 0 congestion 0 more_
io 0 no_nrwrite_index_update 0
         pdflush-398   [000]  5743.923578: ext4_da_writepages: dev sdc1 ino 12
nr_t_write 1024 pages_skipped 0 range_start 0 range_end 0 nonblock
ing 1 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1
         pdflush-398   [000]  5743.927562: ext4_da_writepages_result: dev sdc1
ino 12 ret 0 pages_written 1024 pages_skipped 0 congestion 0 more_
io 0 no_nrwrite_index_update 0

The ext4_da_writepages() function is therefore allocating 1024 blocks at a
time, which the ext4 multiblock allocator is increasing to 2048 blocks (and
sometimes 1024 blocks is allocated, and sometimes 2048 blocks is allocated), as
we can see from /proc/fs/ext4/<dev>/mb_history:

1982  12       1/14336/1024@12288      1/14336/2048@12288     
1/14336/2048@12288      1     0     0  0x0e20 M     0     0     
1982  12       1/15360/1024@13312                             
1/15360/1024@13312     
1982  12       1/16384/1024@14336      1/16384/2048@14336     
1/16384/2048@14336      1     0     0  0x0e20 M     2048  8192  
1982  12       1/17408/1024@15360                             
1/17408/1024@15360     

If there are multiple large dirty files in the page cache, then pdflush will
round-robin trying to write out the inodes, with the result that large files
get interleaved in chunks of 4M (1024 pages) to 8M (2048), and larger chunks
happen only when there is only pages from one inode left in memory.

Potential solutions in the next comment...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
