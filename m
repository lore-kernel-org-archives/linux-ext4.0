From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: partially uptodate page reads
Date: Fri, 25 Jul 2008 19:22:39 +1000
Message-ID: <200807251922.40299.nickpiggin@yahoo.com.au>
References: <200807250117.11331.nickpiggin@yahoo.com.au> <20080724175913.GA32117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:35328 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752683AbYGYJWt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 05:22:49 -0400
In-Reply-To: <20080724175913.GA32117@infradead.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 25 July 2008 03:59, Christoph Hellwig wrote:
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
>
> But as mentioned in one of your previous comments I'd rather prefer
> a readpage interface chaneg to deal with this.

Yeah... actually if it is a nice win I don't mind too much to go
with this API to start with, and consolidate with readpage later.
Readpage I am thinking about making a few other changes for it as
well, so I am happy to look at folding in this partially-uptodate
API with it as well.

If we just get some numbers (maybe SGI can help out?), I'm happy
enough with this approach.
