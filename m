From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] non-contiguous files (64.9%) on a ext4 fs
Date: Mon, 10 Aug 2009 13:11:34 GMT
Message-ID: <200908101311.n7ADBYeZ017851@demeter.kernel.org>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56512 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZHJNLd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 09:11:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7ADBYc8017852
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 13:11:34 GMT
In-Reply-To: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13930





--- Comment #6 from Theodore Tso <tytso@mit.edu>  2009-08-10 13:11:32 ---
There are a number of ways that we can increase the size of block allocation
request made by ext4_da_writepages:

1)  Increase MAX_WRITEBACK_PAGES, possibly on a per-filesystem basis.

The comment around MAX_WRITEBACK_PAGES indicates the problem is around blocking
tasks that wait on I_SYNC, but it's not clear this is really a problem.  
Before I_SYNC was separated out from I_LOCK, this was clearly much more of an
issue, but now the only time when a process waits for I_SYNC, as near as I can
tell, is when they are calling fsync() or otherwise forcing out the inode.   So
I don't think it's going to be that big of a deal.

2) We can change ext4_da_writepages() to attempt to see if there are more dirty
pages in the page cache beyond what had been requested to be written, and if
so, we pass a hint to mballoc via an extension to the allocation_request
structure so that additional blocks are allocated and reserved in the inode's
preallocation structure.

3) Jens Axboe is working on a set of patches which create a separate pdflush
thread for each block device (the per-bdi patches).  I don't think there is a
risk in increasing MAX_WRITEBACK_PAGES, but if there is still a concern, with
the per-bdi patches, perhaps the per-bdi patches could be changed to prefer
dirty inodes which are closed, and writing out complete inodes which have been
closed, one at a time, instead of stopping after MAX_WRITEBACK_PAGES.

These changes should allow us to improve ext4's large file writeback to the
point where it is allocating up to 32768 blocks at a time, instead of 1024
blocks at a time.  At the moment the mballoc code isn't capable of allocating
more than a block group's worth of blocks at a time, since it was written
assuming that there was per block group metadata at the beginning of each block
group which prevented allocations from spanning block groups.   So long term,
we may need to make further improvements to help assure sane allocations for
really files > 128 megs --- although solution #3 might help this situation even
without mballoc changes, since there would only be a single pdflush thread per
bdi writing out large files.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
