From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Tue, 6 Nov 2007 09:33:38 +0800
Message-ID: <20071106013338.GC3900@webber.adilger.int>
References: <46D7097F.4020501@linux.vnet.ibm.com> <1188552066.3781.15.camel@dhcp5.linsyssoft.com> <1193964035.4014.23.camel@localhost.localdomain> <20071102052031.GC18505@webber.adilger.int> <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com> <20071103013621.GC2863@webber.adilger.int> <1194278695.17333.3.camel@dyn9047017100.beaverton.ibm.com> <20071105161529.GC2892@webber.adilger.int> <1194286053.17333.14.camel@dyn9047017100.beaverton.ibm.com> <1194304896.3987.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@gmail.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:58499 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXKFBdz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 20:33:55 -0500
Content-Disposition: inline
In-Reply-To: <1194304896.3987.27.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 05, 2007  15:21 -0800, Mingming Cao wrote:
> On Mon, 2007-11-05 at 10:07 -0800, Badari Pulavarty wrote: 
> > On Tue, 2007-11-06 at 00:15 +0800, Andreas Dilger wrote:
> > > My point is that there is a LOT of code in ext[234] that dereferences
> > > bh->b_data without kmap() (e.g. group descriptors, bitmaps, superblock,
> > > inode tables, etc).  Does that imply that something is forcing those
> > > bh pages into lowmem, or is the journal bh page in question being
> > > allocated in some different way that allows it to be in highmem?
> > 
> > Yes. You are right. Its been a while since I had to deal with HIGHMEM.
> > All the meta-data should be in LOWMEM. I asked Mingming to verify
> > what the buffer-head is pointing to when it has HIGHMEM page.
> > 
> 
> The buffer_heads with NULL bh->b_data(under the "start_journal_io"
> branch in jbd2_journal_commit_transaction() code) is created by
> jbd2_journal_write_metadata_buffer().
> 
> Noticed that in jbd2_journal_write_metadata_buffer(),  there are
> multiple places which do kmap_atomic() to access the journal bh page
> (new_page).  In the normal case the new_page is pointing to the bh
> pages, which(the page) was initially allocated by _page_cache_alloc()
> (sb_bread->__bread()->_...>find_or_create_page()->_page_cache_alloc()
> 
> In the case it need a data copy (the buffer start with the
> JBD2_MAGIC_NUMBER?), a new page is allocated by by
> __get_free_pages()(via jbd2_alloc, which is possible allocated in
> highmem. __get_free_pages calls alloc_pages() directly, doesn't seem to
> have highmem handling like __page_cache_alloc(). 

So long as there is a good explanation, and the code in jbd is expecting
to kmap() the b_data pages always then I have no objection to the patch.
I was just worried there was some other kind of bug involved here and
wanted to ensure that the root cause was understood.  It might be prudent
to grep for b_data in the jbd2 code to verify there are no other places
that dereference the bh page without kmap first.

Thanks for the investigation Mingming.

Girish, can you please include this fix into our patch series.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
