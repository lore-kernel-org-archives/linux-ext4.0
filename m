From: Christoph Hellwig <hch@infradead.org>
Subject: Re: partially uptodate page reads
Date: Thu, 24 Jul 2008 13:59:13 -0400
Message-ID: <20080724175913.GA32117@infradead.org>
References: <200807250117.11331.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, xfs@oss.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYGXR7S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2008 13:59:18 -0400
Content-Disposition: inline
In-Reply-To: <200807250117.11331.nickpiggin@yahoo.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2008 at 01:17:11AM +1000, Nick Piggin wrote:
> Hi, I have some questions about your patch in -mm
> 
> vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
> 
> I have no particular problem with something like this, but leaving the
> implementation details aside for the moment, can we discuss the
> justification for this?
> 
> Are there significant numbers of people using block size < page size in
> situations where performance is important and significantly improved by
> this patch? Can you give any performance numbers to illustrate perhaps?

With XFS lots of people use 4k blocksize filesystems on ia64 systems
with 16k pages, so an optimization like this would be useful.

But as mentioned in one of your previous comments I'd rather prefer
a readpage interface chaneg to deal with this.
