From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Mon, 05 Nov 2007 15:21:36 -0800
Message-ID: <1194304896.3987.27.camel@localhost.localdomain>
References: <46D7097F.4020501@linux.vnet.ibm.com>
	 <1188552066.3781.15.camel@dhcp5.linsyssoft.com>
	 <1193964035.4014.23.camel@localhost.localdomain>
	 <20071102052031.GC18505@webber.adilger.int>
	 <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com>
	 <20071103013621.GC2863@webber.adilger.int>
	 <1194278695.17333.3.camel@dyn9047017100.beaverton.ibm.com>
	 <20071105161529.GC2892@webber.adilger.int>
	 <1194286053.17333.14.camel@dyn9047017100.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42792 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXKEXVi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 18:21:38 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA5NLbaA003026
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 18:21:37 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA5NLbkA478420
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 18:21:37 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA5NLb9d014985
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 18:21:37 -0500
In-Reply-To: <1194286053.17333.14.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-11-05 at 10:07 -0800, Badari Pulavarty wrote: 
> On Tue, 2007-11-06 at 00:15 +0800, Andreas Dilger wrote:
> > On Nov 05, 2007  08:04 -0800, Badari Pulavarty wrote:
> > > On Sat, 2007-11-03 at 09:36 +0800, Andreas Dilger wrote:
> > > > But...  this implies that every user of bh->b_data needs to kmap, and I
> > > > don't see that in the code anywhere else.  That makes me think something
> > > > else is going wrong here.
> > > 
> > > Most cases, this is handled in ll_rw_block() code - when we submit the
> > > buffer head for IO. If the page is in highmem, we will end up creating
> > > a bounce bufer for it. 
> > > 
> > > In our case, JBD code is trying to look at the data to do checksum
> > > on it. Thats why we have to kmap() the page before looking.
> > 
> > My point is that there is a LOT of code in ext[234] that dereferences
> > bh->b_data without kmap() (e.g. group descriptors, bitmaps, superblock,
> > inode tables, etc).  Does that imply that something is forcing those
> > bh pages into lowmem, or is the journal bh page in question being
> > allocated in some different way that allows it to be in highmem?
> 
> Yes. You are right. Its been a while since I had to deal with HIGHMEM.
> All the meta-data should be in LOWMEM. I asked Mingming to verify
> what the buffer-head is pointing to when it has HIGHMEM page.
> 

The buffer_heads with NULL bh->b_data(under the "start_journal_io"
branch in jbd2_journal_commit_transaction() code) is created by
jbd2_journal_write_metadata_buffer().

Noticed that in jbd2_journal_write_metadata_buffer(),  there are
multiple places which do kmap_atomic() to access the journal bh page
(new_page).  In the normal case the new_page is pointing to the bh
pages, which(the page) was initially allocated by _page_cache_alloc()
(sb_bread->__bread()->_...>find_or_create_page()->_page_cache_alloc()

In the case it need a data copy (the buffer start with the
JBD2_MAGIC_NUMBER?), a new page is allocated by by
__get_free_pages()(via jbd2_alloc, which is possible allocated in
highmem. __get_free_pages calls alloc_pages() directly, doesn't seem to
have highmem handling like __page_cache_alloc(). 

I am not sure why we saw this issue on 2.6.23 kernel, where
jbd2_slab_alloc()->kmem_cache_alloc() is used. Isn't all slab pages
under lowmem?


Regards,

Mingming
