From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Fri, 03 Oct 2008 08:07:49 -0400
Message-ID: <1223035669.6836.5.camel@think.oraclecorp.com>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	 <20081002181856.GB29613@skywalker>
	 <1222996262.12099.42.camel@think.oraclecorp.com>
	 <200810031243.51277.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:26217 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYJCMIJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2008 08:08:09 -0400
In-Reply-To: <200810031243.51277.nickpiggin@yahoo.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-10-03 at 12:43 +1000, Nick Piggin wrote:
> On Friday 03 October 2008 11:11, Chris Mason wrote:

> > > Part of that can happen due to shrink_page_list -> pageout -> writepagee
> > > call back with lots of unallocated buffer_heads(blocks). Also a journal
> > > commit with jbd2 looks at the inode and all the dirty pages, rather than
> > > the buffer_heads (journal_submit_data_buffers). We don't force commit
> > > pages that doesn't have blocks allocated with the ext4. The consistency
> > > is only with i_size and data.
> >
> > In general, I don't think pdflush or the VM expect
> > redirty_pages_for_writepage to be used this aggressively.
> 
> BTW. redirty_page_for_writepage and the whole model of cleaning the page's
> dirty bit *before* calling into the filesystem is really nasty IMO. For
> one thing it opens races that mean a filesystem can't keep metadata about
> the pagecache properly in synch with the page's dirty bit.
> 
> I have a patch in my fsblock series that fixes this and has the writepage()
> function itself clear the page's dirty bit. This basically makes
> redirty_page_for_writepages go away completely (at least the uses I looked
> at, I didn't look at ext4 though).
> 
> Shall I break it out and submit it?

It's a fair amount of churn in the FS code, and the part I'm not sure of
is if the bigger problem is lock ordering around the page lock and the
FS locks or just the dirty bit.

Personally I'd rather see writepages used everywhere, giving the FS the
chance to do more efficient IO.

-chris



