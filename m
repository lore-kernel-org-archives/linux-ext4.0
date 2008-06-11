From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Wed, 11 Jun 2008 19:26:31 +0530
Message-ID: <20080611135631.GA15169@skywalker>
References: <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093459.GC30613@duck.suse.cz> <20080602095956.GB9225@skywalker> <20080602102759.GG30613@duck.suse.cz> <20080605135413.GI8942@skywalker> <20080605162209.GG27370@duck.suse.cz> <20080605191909.GD4723@skywalker> <20080611124157.GB8121@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37088 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbYFKN5A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 09:57:00 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5BDuRg0003441
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 23:56:27 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5BE19kW182802
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 00:01:09 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5BDuvsY012604
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 23:56:58 +1000
Content-Disposition: inline
In-Reply-To: <20080611124157.GB8121@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 02:41:57PM +0200, Jan Kara wrote:
> On Fri 06-06-08 00:49:09, Aneesh Kumar K.V wrote:
> > On Thu, Jun 05, 2008 at 06:22:09PM +0200, Jan Kara wrote:
> > >   I like it. I'm only not sure whether there cannot be two users of
> > > write_cache_pages() operating on the same mapping at the same time. Because
> > > then they could alter writeback_index under each other and that would
> > > probably result in unpleasant behavior. I think there can be two parallel
> > > calls for example from sync_single_inode() and sync_page_range().
> > >   In that case we'd need something like writeback_index inside wbc (or
> > > maybe just alter range_start automatically when range_cont is set?) so that
> > > parallel callers do no influence each other.
> > > 
> > 
> > commit e56edfdeea0d336e496962782f08e1224a101cf2
> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Date:   Fri Jun 6 00:47:35 2008 +0530
> > 
> >     mm: Add range_cont mode for writeback.
> >     
> >     Filesystems like ext4 needs to start a new transaction in
> >     the writepages for block allocation. This happens with delayed
> >     allocation and there is limit to how many credits we can request
> >     from the journal layer. So we call write_cache_pages multiple
> >     times with wbc->nr_to_write set to the maximum possible value
> >     limitted by the max journal credits available.
> >     
> >     Add a new mode to writeback that enables us to handle this
> >     behaviour. If mapping->writeback_index is not set we use
> >     wbc->range_start to find the start index and then at the end
> >     of write_cache_pages we store the index in writeback_index. Next
> >     call to write_cache_pages will start writeout from writeback_index.
> >     Also we limit writing to the specified wbc->range_end.
>   I think this changelog is out of date...

The patch in the patchqueue have an updated changelog.


> 
> >     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> > index f462439..0d8573e 100644
> > --- a/include/linux/writeback.h
> > +++ b/include/linux/writeback.h
> > @@ -63,6 +63,7 @@ struct writeback_control {
> >  	unsigned for_writepages:1;	/* This is a writepages() call */
> >  	unsigned range_cyclic:1;	/* range_start is cyclic */
> >  	unsigned more_io:1;		/* more io to be dispatched */
> > +	unsigned range_cont:1;
> >  };
> >  
> >  /*
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 789b6ad..182233b 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -882,6 +882,9 @@ int write_cache_pages(struct address_space *mapping,
> >  	if (wbc->range_cyclic) {
> >  		index = mapping->writeback_index; /* Start from prev offset */
> >  		end = -1;
> > +	} else if (wbc->range_cont) {
> > +		index = wbc->range_start >> PAGE_CACHE_SHIFT;
> > +		end = wbc->range_end >> PAGE_CACHE_SHIFT;
>   Hmm, why isn't this in the next else?

The patch in the patchqueue have

+       } else if (wbc->range_cont) {
+               index = wbc->range_start >> PAGE_CACHE_SHIFT;
+               end = wbc->range_end >> PAGE_CACHE_SHIFT;
+               /*
+                * we want to set the writeback_index when congested
+                * and we are requesting for nonblocking mode,
+                * because we won't force the range_cont mode then
+                */
+               if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+                       range_whole = 1;


I was not clear about setting scanned = 1; Now that I read it again I
guess it makes sense to set scanned = 1. We don't need to start the
writeout from index=0 when range_cont is set.


> 
> >  	} else {
> >  		index = wbc->range_start >> PAGE_CACHE_SHIFT;
> >  		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> > @@ -956,6 +959,9 @@ int write_cache_pages(struct address_space *mapping,
> >  	}
> >  	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
> >  		mapping->writeback_index = index;
> > +
> > +	if (wbc->range_cont)
> > +		wbc->range_start = index << PAGE_CACHE_SHIFT;
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL(write_cache_pages);
> 
> 									Honza

Attaching the updated patch.

Mingming,

Can you update the patchqueu with the  below attached patch ?

-aneesh

mm: Add range_cont mode for writeback.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Filesystems like ext4 needs to start a new transaction in
the writepages for block allocation. This happens with delayed
allocation and there is limit to how many credits we can request
from the journal layer. So we call write_cache_pages multiple
times with wbc->nr_to_write set to the maximum possible value
limitted by the max journal credits available.

Add a new mode to writeback that enables us to handle this
behaviour. In the new mode we update the wbc->range_start
to point to the new offset to be written. Next call to
call to write_cache_pages will start writeout from  specified
range_start offset. In the new mode we also limit writing
to the specified wbc->range_end.


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)


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
index 789b6ad..ded57d5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -956,6 +956,9 @@ int write_cache_pages(struct address_space *mapping,
 	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
+
+	if (wbc->range_cont)
+		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
