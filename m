From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Sat, 16 Jun 2012 09:49:23 -0400
Message-ID: <20120616134923.GA12140@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <201206142155.32009.arnd.bergmann@linaro.org>
 <20120615220453.GC7363@thunk.org>
 <201206160726.07851.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50865 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab2FPNtb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jun 2012 09:49:31 -0400
Content-Disposition: inline
In-Reply-To: <201206160726.07851.arnd.bergmann@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 16, 2012 at 07:26:07AM +0000, Arnd Bergmann wrote:
> > Oh, that's cool.  And I don't think that's hard to do.  We could just
> > keep a flag in the in-core inode indicating whether it is in "large
> > unit" mode.  If it is in large unit mode, we can make the fs writeback
> > function make sure that we adhere to the restrictions of the large
> > unit mode, and if at any point we need to do something that might
> > violate the constraints, the file system would simply close the
> > context.
> 
> Really? I actually had expected this to be a major issue, to the
> point that I thought we would only ever do large contexts in
> special emmc-optimized file sytems.

Yeah, it's easy, for file systems (like ext4) which have delayed
allocation.  It's always faster to write in large contiguous chunks,
so we do a lot of work to make sure we can make that happen.  Take a
look of a blktrace of ext4 when writing large set of files; most of
the I/O will be in contiguous, large chunks.  So it's just a matter of
telling the block device layer when we are about to do that large
write.  We could probably do some tuning to make the chunks be larger
and adjust some parameters in the block allocation, but that's easy.

One thing which is going to be tricky is that ext4 currently uses a
buddy allocator, so it will work well for erase blocks of two.  You
mentioned some devices might have erase block sizes of 3*2**N, so that
might require reworking the block allocator some, if we need to align
writes on erase block boundaries.

> > Well, I'm interested in getting something upstream, which is useful
> > not just for the consumer-grade eMMC devices in handsets, but which
> > might also be extensible to SSD's, and all the way up to PCIe-attached
> > flash devices that might be used in large data centers.
> > 
> 
> I am not aware of any actual SSD technology that would take advantage
> of it, but at least the upcoming UFS standard that is supposed to
> replace eMMC should do it, and it's somewhere inbetween an eMMC and
> an SSD in many ways.

I'm not aware that anything has been announced, but this is one of
those things which the high end folks have *got* to be thinking about.
The issues involved aren't only just for eMMC, you know...   :-)

    	   	    	   	     	  - Ted
