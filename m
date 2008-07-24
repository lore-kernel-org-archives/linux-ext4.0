From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: partially uptodate page reads
Date: Thu, 24 Jul 2008 12:08:41 -0700
Message-ID: <20080724120841.81c72be9.akpm@linux-foundation.org>
References: <200807250117.11331.nickpiggin@yahoo.com.au>
	<20080724175913.GA32117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
	hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbYGXTJU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2008 15:09:20 -0400
In-Reply-To: <20080724175913.GA32117@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 24 Jul 2008 13:59:13 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Jul 25, 2008 at 01:17:11AM +1000, Nick Piggin wrote:
> > Hi, I have some questions about your patch in -mm
> > 
> > vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
> > 
> > I have no particular problem with something like this, but leaving the
> > implementation details aside for the moment, can we discuss the
> > justification for this?
> > 
> > Are there significant numbers of people using block size < page size in
> > situations where performance is important and significantly improved by
> > this patch? Can you give any performance numbers to illustrate perhaps?
> 
> With XFS lots of people use 4k blocksize filesystems on ia64 systems
> with 16k pages, so an optimization like this would be useful.

As Nick says, we really should have some measurement results which
confirm this theory.  Maybe we did do some but they didn't find theor
way into the changelog.

I've put the patch on hold until this confirmation data is available.

> But as mentioned in one of your previous comments I'd rather prefer
> a readpage interface chaneg to deal with this.
