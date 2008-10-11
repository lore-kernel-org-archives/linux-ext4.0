From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH updated] ext4: Fix file fragmentation during large file
	write.
Date: Sat, 11 Oct 2008 23:44:26 +0530
Message-ID: <20081011181426.GB9662@skywalker>
References: <1223661776-20098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081011105152.GB29681@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	chris.mason@oracle.com, akpm@linux-foundation.org,
	hch@infradead.org, steve@chygwyn.com, mpatocka@redhat.com,
	linux-mm@kvack.org, inux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:40340 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762327AbYJKSOw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 14:14:52 -0400
Content-Disposition: inline
In-Reply-To: <20081011105152.GB29681@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 11, 2008 at 12:51:52PM +0200, Nick Piggin wrote:
> On Fri, Oct 10, 2008 at 11:32:56PM +0530, Aneesh Kumar K.V wrote:
> > The range_cyclic writeback mode use the address_space
> > writeback_index as the start index for writeback. With
> > delayed allocation we were updating writeback_index
> > wrongly resulting in highly fragmented file. Number of
> > extents reduced from 4000 to 27 for a 3GB file with
> > the below patch.
> > 
> > The patch also removes the range_cont writeback mode
> > added for ext4 delayed allocation. Instead we add
> > two new flags in writeback_control which control
> > the behaviour of write_cache_pages.
> 
> The mm/page-writeback.c changes look OK, although it loks like you've
> got rid of range_cont? Should we do a patch to get rid of it entirely
> from the tree first?
> 
> I don't mind rediffing my patchset on top of this, but this seems smaller
> and not strictly a bugfix so I would prefer to go the other way if you
> agree.
> 
> Seems like it could be broken up into several patches (eg. pagevec_lookup).
> 
> The results look very nice.

I actually tried to do that. But to do that and also achieve a working
bisect kernel, I will have to do the patches in below way

a) Introduce ext4_write_cache_pages
b) remove range_cont from write_cache_pages
c) Introduce the new flags to writeback_control
d) switch ext4 to use write_cache_pages.

I thought that involved lot of code which are later getting removed.
So i went for a single patch.

-aneesh
