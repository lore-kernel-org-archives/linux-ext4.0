From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Thu, 22 May 2008 12:26:10 -0700
Message-ID: <1211484370.8596.46.camel@BVR-FS.beaverton.ibm.com>
References: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211479817.8596.42.camel@BVR-FS.beaverton.ibm.com>
	 <20080522182653.GB7404@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55902 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbYEVT0a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2008 15:26:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4MJQMmp019601
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 15:26:22 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4MJQB3S100788
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 13:26:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4MJQA6b028606
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 13:26:11 -0600
In-Reply-To: <20080522182653.GB7404@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-05-22 at 23:56 +0530, Aneesh Kumar K.V wrote:
> On Thu, May 22, 2008 at 11:10:17AM -0700, Mingming wrote:
> > 
> > On Wed, 2008-05-21 at 23:14 +0530, Aneesh Kumar K.V wrote:
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > ---
> > >  fs/ext4/inode.c |   10 +++++++---
> > >  1 files changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 46cc610..076d00f 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -1571,13 +1571,17 @@ static int ext4_da_writepages(struct address_space *mapping,
> > >  		 */
> > >  		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> > >  			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
> > > -		to_write -= wbc->nr_to_write;
> > > 
> > > +		to_write -= wbc->nr_to_write;
> > >  		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> > >  		ext4_journal_stop(handle);
> > > -		to_write +=wbc->nr_to_write;
> > > +		if (wbc->nr_to_write) {
> > > +			/* We failed to write what we requested for */
> > > +			to_write += wbc->nr_to_write;
> > > +			break;
> > > +		}
> > 
> > Not sure about the break here...
> > > +		wbc->nr_to_write = to_write;
> > 
> > Looks right. thanks.
> > 
> > >  	}
> > > -
> > >  out_writepages:
> > >  	wbc->nr_to_write = to_write;
> > >  	wbc->range_cyclic = range_cyclic;
> > 
> 
> The call chain that made me look at this was 
> 
> #0  ext4_da_writepages (mapping=0xc76dc244, wbc=0xc790bf70) at fs/ext4/inode.c:1557
> #1  0xc0150176 in do_writepages (mapping=0xc76dc244, wbc=0xc790bf70) at mm/page-writeback.c:1004
> #2  0xc0180fe6 in __writeback_single_inode (inode=0xc76dc11c, wbc=0xc790bf70) at fs/fs-writeback.c:285
> #3  0xc018146c in sync_sb_inodes (sb=0xc7abac00, wbc=0xc790bf70) at fs/fs-writeback.c:502
> #4  0xc0181701 in writeback_inodes (wbc=0xc790bf70) at fs/fs-writeback.c:570
> #5  0xc01509f8 in background_writeout (_min_pages=<value optimized out>) at mm/page-writeback.c:639
> #6  0xc0150f57 in pdflush (dummy=<value optimized out>) at mm/pdflush.c:127
> #7  0xc01324af in kthread (_create=<value optimized out>) at kernel/kthread.c:79
> #8  0xc0104633 in kernel_thread_helper () at include/asm/string_32.h:238
> 
> ext4_da_writepages gets called with nr_to_write MAX_WRITEBACK_PAGES. the
> file size is only 4K. ie there is only one page to write. With these
> value we get stuck in the above loop because to_write will never decrement
> below 1023.
> 

Ah, So I guess the comment should be reflect that the nr_to_write
returned after mpage_da_writepages() means there is no more dirty page
need to flush, then quit the loop.

Mingming
> 
> -aneesh

