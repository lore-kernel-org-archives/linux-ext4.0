From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Thu, 5 Jun 2008 19:24:13 +0530
Message-ID: <20080605135413.GI8942@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093459.GC30613@duck.suse.cz> <20080602095956.GB9225@skywalker> <20080602102759.GG30613@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46726 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbYFENyx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 09:54:53 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m55Drwkv019271
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 23:53:58 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55Dx1SG100198
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 23:59:01 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m55DsoTZ023746
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 23:54:50 +1000
Content-Disposition: inline
In-Reply-To: <20080602102759.GG30613@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 12:27:59PM +0200, Jan Kara wrote:
> On Mon 02-06-08 15:29:56, Aneesh Kumar K.V wrote:
> > On Mon, Jun 02, 2008 at 11:35:00AM +0200, Jan Kara wrote:
> > > >  			BUG_ON(buffer_locked(bh));
> > > >  			if (buffer_dirty(bh))
> > > >  				mpage_add_bh_to_extent(mpd, logical, bh);
> > > > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > > > index 789b6ad..655b8bf 100644
> > > > --- a/mm/page-writeback.c
> > > > +++ b/mm/page-writeback.c
> > > > @@ -881,7 +881,12 @@ int write_cache_pages(struct address_space *mapping,
> > > >  	pagevec_init(&pvec, 0);
> > > >  	if (wbc->range_cyclic) {
> > > >  		index = mapping->writeback_index; /* Start from prev offset */
> > > > -		end = -1;
> > > > +		/*
> > > > +		 * write only till the specified range_end even in cyclic mode
> > > > +		 */
> > > > +		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> > > > +		if (!end)
> > > > +			end = -1;
> > > >  	} else {
> > > >  		index = wbc->range_start >> PAGE_CACHE_SHIFT;
> > > >  		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> > >   Are you sure you won't break other users of range_cyclic with this
> > > change?
> > >
> > I haven't run any specific test to verify that. The concern was that if
> > we force cyclic mode for writeout in delalloc we may be starting the
> > writeout from a different offset than specified and would be writing
> > more. So the changes was to use the offset specified. A quick look at
> > the kernel suggested most of them had range_end as 0 with cyclic_mode.
> > I haven't audited the full kernel. I will do that. Meanwhile if you
> > think it is risky to make this changes i guess we should drop this
> > part. But i guess we can keep the below change
>   Hmm, I've just got an idea that it may be better to introduce a new flag
> for wbc like range_cont and it would mean that we start scan at
> writeback_index (we use range_start if writeback_index is not set) and
> end with range_end. That way we don't have to be afraid of interference
> with other range_cyclic users and in principle, range_cyclic is originally
> meant for other uses...
> 

something like below ?. With this ext4_da_writepages have

pgoff_t writeback_index = 0;
.....
if (!wbc->range_cyclic) {
	/*
	 * If range_cyclic is not set force range_cont
	 * and save  the old  writeback_index
	 */
	wbc->range_cont = 1;
	writeback_index = mapping->writeback_index;
	mapping->writeback_index = 0;
}
...
mpage_da_writepages(..)
..
if (writeback_index)
           mapping->writeback_index = writeback_index;
return ret;



mm: Add range_cont mode for writeback.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

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
---

 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)


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
index 789b6ad..014a9f2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -882,6 +882,12 @@ int write_cache_pages(struct address_space *mapping,
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
+	} else if (wbc->range_cont) {
+		if (!mapping->writeback_index)
+			index = wbc->range_start >> PAGE_CACHE_SHIFT;
+		else
+			index = mapping->writeback_index;
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
@@ -954,7 +960,9 @@ int write_cache_pages(struct address_space *mapping,
 		index = 0;
 		goto retry;
 	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+	if (wbc->range_cyclic ||
+			(range_whole && wbc->nr_to_write > 0) ||
+			wbc->range_cont)
 		mapping->writeback_index = index;
 	return ret;
 }
