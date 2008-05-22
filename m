From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Thu, 22 May 2008 23:56:53 +0530
Message-ID: <20080522182653.GB7404@skywalker>
References: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1211391859-17399-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1211479817.8596.42.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:57652 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYEVS1I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2008 14:27:08 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4MIQxgr006071
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 23:56:59 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4MIQlHl889062
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 23:56:47 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4MIQPZE025458
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 23:56:25 +0530
Content-Disposition: inline
In-Reply-To: <1211479817.8596.42.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 22, 2008 at 11:10:17AM -0700, Mingming wrote:
> 
> On Wed, 2008-05-21 at 23:14 +0530, Aneesh Kumar K.V wrote:
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 46cc610..076d00f 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1571,13 +1571,17 @@ static int ext4_da_writepages(struct address_space *mapping,
> >  		 */
> >  		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> >  			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
> > -		to_write -= wbc->nr_to_write;
> > 
> > +		to_write -= wbc->nr_to_write;
> >  		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> >  		ext4_journal_stop(handle);
> > -		to_write +=wbc->nr_to_write;
> > +		if (wbc->nr_to_write) {
> > +			/* We failed to write what we requested for */
> > +			to_write += wbc->nr_to_write;
> > +			break;
> > +		}
> 
> Not sure about the break here...
> > +		wbc->nr_to_write = to_write;
> 
> Looks right. thanks.
> 
> >  	}
> > -
> >  out_writepages:
> >  	wbc->nr_to_write = to_write;
> >  	wbc->range_cyclic = range_cyclic;
> 

The call chain that made me look at this was 

#0  ext4_da_writepages (mapping=0xc76dc244, wbc=0xc790bf70) at fs/ext4/inode.c:1557
#1  0xc0150176 in do_writepages (mapping=0xc76dc244, wbc=0xc790bf70) at mm/page-writeback.c:1004
#2  0xc0180fe6 in __writeback_single_inode (inode=0xc76dc11c, wbc=0xc790bf70) at fs/fs-writeback.c:285
#3  0xc018146c in sync_sb_inodes (sb=0xc7abac00, wbc=0xc790bf70) at fs/fs-writeback.c:502
#4  0xc0181701 in writeback_inodes (wbc=0xc790bf70) at fs/fs-writeback.c:570
#5  0xc01509f8 in background_writeout (_min_pages=<value optimized out>) at mm/page-writeback.c:639
#6  0xc0150f57 in pdflush (dummy=<value optimized out>) at mm/pdflush.c:127
#7  0xc01324af in kthread (_create=<value optimized out>) at kernel/kthread.c:79
#8  0xc0104633 in kernel_thread_helper () at include/asm/string_32.h:238

ext4_da_writepages gets called with nr_to_write MAX_WRITEBACK_PAGES. the
file size is only 4K. ie there is only one page to write. With these
value we get stuck in the above loop because to_write will never decrement
below 1023.


-aneesh
