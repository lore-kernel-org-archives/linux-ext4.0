From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Fri, 6 Jun 2008 00:49:09 +0530
Message-ID: <20080605191909.GD4723@skywalker>
References: <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093459.GC30613@duck.suse.cz> <20080602095956.GB9225@skywalker> <20080602102759.GG30613@duck.suse.cz> <20080605135413.GI8942@skywalker> <20080605162209.GG27370@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:48031 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751118AbYFETTT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 15:19:19 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m55JJHh2017258
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 00:49:17 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55JJ24E1450020
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 00:49:02 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m55JJGkv003161
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 00:49:17 +0530
Content-Disposition: inline
In-Reply-To: <20080605162209.GG27370@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 06:22:09PM +0200, Jan Kara wrote:
>   I like it. I'm only not sure whether there cannot be two users of
> write_cache_pages() operating on the same mapping at the same time. Because
> then they could alter writeback_index under each other and that would
> probably result in unpleasant behavior. I think there can be two parallel
> calls for example from sync_single_inode() and sync_page_range().
>   In that case we'd need something like writeback_index inside wbc (or
> maybe just alter range_start automatically when range_cont is set?) so that
> parallel callers do no influence each other.
> 

commit e56edfdeea0d336e496962782f08e1224a101cf2
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Jun 6 00:47:35 2008 +0530

    mm: Add range_cont mode for writeback.
    
    Filesystems like ext4 needs to start a new transaction in
    the writepages for block allocation. This happens with delayed
    allocation and there is limit to how many credits we can request
    from the journal layer. So we call write_cache_pages multiple
    times with wbc->nr_to_write set to the maximum possible value
    limitted by the max journal credits available.
    
    Add a new mode to writeback that enables us to handle this
    behaviour. If mapping->writeback_index is not set we use
    wbc->range_start to find the start index and then at the end
    of write_cache_pages we store the index in writeback_index. Next
    call to write_cache_pages will start writeout from writeback_index.
    Also we limit writing to the specified wbc->range_end.
    
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f462439..0d8573e 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -63,6 +63,7 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	unsigned range_cont:1;
 };
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 789b6ad..182233b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -882,6 +882,9 @@ int write_cache_pages(struct address_space *mapping,
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
+	} else if (wbc->range_cont) {
+		index = wbc->range_start >> PAGE_CACHE_SHIFT;
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
@@ -956,6 +959,9 @@ int write_cache_pages(struct address_space *mapping,
 	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
+
+	if (wbc->range_cont)
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
