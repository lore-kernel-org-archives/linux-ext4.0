From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Tue, 5 Aug 2008 19:54:03 +0530
Message-ID: <20080805142403.GA16529@skywalker>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804163505.GE9397@skywalker> <20080805064428.GB8569@mit.edu> <20080805065217.GF9397@skywalker> <20080805132133.GA15568@skywalker> <20080805134722.GA12544@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:43567 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753234AbYHEOYK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 10:24:10 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m75EO7Eo032354
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 19:54:07 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m75EO74w1261718
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 19:54:07 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m75EO7b2021406
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 19:54:07 +0530
Content-Disposition: inline
In-Reply-To: <20080805134722.GA12544@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2008 at 09:47:23AM -0400, Theodore Tso wrote:
> On Tue, Aug 05, 2008 at 06:51:33PM +0530, Aneesh Kumar K.V wrote:
> > This should not be needed. I was trying to force the pages to writeback.
> > generic_sync_sb_inodes actually move  the inode to s_dirty if the
> > pages_skipped differ after a writeback. But the confusing part is we
> > are not looking at s_dirty list again. We move s_dirty and s_more_io to s_io
> > only once in queue_io
> 
> Yes, but ext4_da_writepages() gets called twice in the __fsync_super()
> code path, right?  Once with wbc->sync_mode set to WB_SYNC_HOLD, and
> once with wbc->sync_mode set to wbc->sync_mode set to WB_SYNC_ALL,
> corresponding to sync_inodes_sb() getting called twice, once with
> wait=0 and once with wait=1.
> 

But we would still can have pages skipped in the second call to
ext4_da_writepages(). But this make me wonder how xfs is doing
delalloc. Also this should be possible in other file systems too. The
delayed allocation logic is just exposing it much easily.

sync_inodes_sb(sb, 0);
generic_sync_sb_inodes
	write 10 pages and moves 10 to pages skipped.
		move the inode to s_dirty.

sync_inodes_sb(sb, 1);
generic_sync_sb_inodes
	move s_dirty to s_io
	write 10 pages  and move 5 pages to skipped list
		move inode to s_dirty.

I guess sync_inodes_sb() should  ensure that all dirty pages
are written to the disk. And currently i can see may ways in
which generic_sync_sb_inodes fails to do that. generic_sync_sb_inodes
is suitable for pdflush work function which get called periodically
But for __fsync_super i guess we need a different API which ensures
that all the dirty pages are synced to the disk.

-aneesh
