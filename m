From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Sat, 16 Jun 2012 17:41:23 +0000
Message-ID: <201206161741.23900.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206160726.07851.arnd.bergmann@linaro.org> <20120616134923.GA12140@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2FPRlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jun 2012 13:41:40 -0400
In-Reply-To: <20120616134923.GA12140@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday 16 June 2012, Ted Ts'o wrote:
> On Sat, Jun 16, 2012 at 07:26:07AM +0000, Arnd Bergmann wrote:
> > > Oh, that's cool.  And I don't think that's hard to do.  We could just
> > > keep a flag in the in-core inode indicating whether it is in "large
> > > unit" mode.  If it is in large unit mode, we can make the fs writeback
> > > function make sure that we adhere to the restrictions of the large
> > > unit mode, and if at any point we need to do something that might
> > > violate the constraints, the file system would simply close the
> > > context.
> > 
> > Really? I actually had expected this to be a major issue, to the
> > point that I thought we would only ever do large contexts in
> > special emmc-optimized file sytems.
> 
> Yeah, it's easy, for file systems (like ext4) which have delayed
> allocation.  It's always faster to write in large contiguous chunks,
> so we do a lot of work to make sure we can make that happen.  Take a
> look of a blktrace of ext4 when writing large set of files; most of
> the I/O will be in contiguous, large chunks.  So it's just a matter of
> telling the block device layer when we are about to do that large
> write.  We could probably do some tuning to make the chunks be larger
> and adjust some parameters in the block allocation, but that's easy.
> 
> One thing which is going to be tricky is that ext4 currently uses a
> buddy allocator, so it will work well for erase blocks of two.  You
> mentioned some devices might have erase block sizes of 3*2**N, so that
> might require reworking the block allocator some, if we need to align
> writes on erase block boundaries.

What about the other restrictions I mentioned though? If we use large-unit
read-only contexts, it's not just about writing the entire erase block
from start to end, we have to make sure we follow other rules:

* We cannot read from write-only large-unit context, so we have to
  do one of these:
   a) ensure we never drop any pages from page-cache between writing
      them to the large context and closing that context
   b) if we need to read some data that we have just written to the
      large-unit context, close that context and open a new rw-context
      without the large-unit flag set (or write in the default context)
* All writes to the large-unit context have to be done in superpage
  size, which means something between 8 and 32 kb typically, so more
  than the underlying fs block size
* We can only start the large unit at the start of an erase block. If
  we unmount the drive and later continue writing, it has to continue
  without the large-unit flag at first until we hit an erase block
  boundary.
* If we run out of contexts in the block device, we might have to
  close a large-unit context before getting to the end of it.

> > > Well, I'm interested in getting something upstream, which is useful
> > > not just for the consumer-grade eMMC devices in handsets, but which
> > > might also be extensible to SSD's, and all the way up to PCIe-attached
> > > flash devices that might be used in large data centers.
> > > 
> > 
> > I am not aware of any actual SSD technology that would take advantage
> > of it, but at least the upcoming UFS standard that is supposed to
> > replace eMMC should do it, and it's somewhere inbetween an eMMC and
> > an SSD in many ways.
> 
> I'm not aware that anything has been announced, but this is one of
> those things which the high end folks have *got* to be thinking about.
> The issues involved aren't only just for eMMC, you know...   :-)

My impression was always that the high-end storage folks try to make
everything behave nicely whatever the access patterns are, and they
can do it because an SSD controllers has vast amounts of cache (megabytes,
not kilobytes) and processing power (e.g. 1Ghz ARMv5 instead of 50 Mhz
8051) to handle it, and they also make use of tagged command queuing to
let the device have multiple outstanding requests.

	Arnd
