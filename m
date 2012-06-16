From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Sat, 16 Jun 2012 07:26:07 +0000
Message-ID: <201206160726.07851.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206142155.32009.arnd.bergmann@linaro.org> <20120615220453.GC7363@thunk.org>
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
Received: from moutng.kundenserver.de ([212.227.126.187]:50496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2FPH00 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jun 2012 03:26:26 -0400
In-Reply-To: <20120615220453.GC7363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 15 June 2012, Ted Ts'o wrote:
> On Thu, Jun 14, 2012 at 09:55:31PM +0000, Arnd Bergmann wrote:
> > 
> > As soon as we get into the territory of the file system being
> > smart about keeping separate contexts for some files rather than
> > just using the low bits of the inode number or the pid, we get
> > more problems:
> > 
> > * The block device needs to communicate the number of available
> >   contexts to the file system
> > * We have to arbitrate between contexts used on different partitions
> >   of the same device
> 
> Can't we virtualize this?  Would this work?
> 
> The file system can simply create as many virtual contexts as it
> likes; if there are no more contexts available, the block device
> simply closes the least recently used context (no matter what
> partition).  If the file system tries to use a virtual context where
> the underlying physical context has been closed, the block device will
> simply open a new physical context (possibly closing some other old
> context).

Yes, that sounds like a useful thing to do. It just means that we
have to throw away and redo all the patches, but I think that's ok.

> > There is one more option we have to give the best possible performance,
> > although that would be a huge amount of work to implement:
> > 
> > Any large file gets put into its own context, and we mark that
> > context "write-only" "unreliable" and "large-unit". This means the
> > file system has to write the file sequentially, filling one erase
> > block at a time, writing only "superpage" units (e.g. 16KB) or
> > multiples of that at once. We can neither overwrite nor read back
> > any of the data in that context until it is closed, and there is
> > no guarantee that any of the data has made it to the physical medium
> > before the context is closed. We are allowed to do read and write
> > accesses to any other context between superpage writes though.
> > After closing the context, the data will be just like any other
> > block again.
> 
> Oh, that's cool.  And I don't think that's hard to do.  We could just
> keep a flag in the in-core inode indicating whether it is in "large
> unit" mode.  If it is in large unit mode, we can make the fs writeback
> function make sure that we adhere to the restrictions of the large
> unit mode, and if at any point we need to do something that might
> violate the constraints, the file system would simply close the
> context.

Really? I actually had expected this to be a major issue, to the
point that I thought we would only ever do large contexts in
special emmc-optimized file sytems.

> The only reason I can think of why this might be problematic is if
> there is a substantial performance cost involved with opening and
> closing contexts on eMMC devices.  Is that an issue we need to be
> worried about?

I don't think so. Opening a context should basically be free, and
while closing a context can take some time, my understanding is
that in a sensible implementation that time would never be more
than the time we saved in the first place by using the context:
With a write-only context, the device does not actually have to
write all the data (it may have to write some of it, depending
on the exact mode the context is put into) until the context gets
closed, so it can take advantage of smarter allocation and batched
writes at close time.

> > Right now, there is no support for large-unit context and also not for
> > read-only or write-only contexts, which means we don't have to
> > enforce strict policies and can basically treat the context ID
> > as a hint. Using the advanced features would require that we
> > keep track of the context IDs across partitions and have to flush
> > write-only contexts before reading the data again. If we want to
> > do that, we can probably discard the patch series and start over.
> 
> Well, I'm interested in getting something upstream, which is useful
> not just for the consumer-grade eMMC devices in handsets, but which
> might also be extensible to SSD's, and all the way up to PCIe-attached
> flash devices that might be used in large data centers.
> 
> I think if we do things right, it should be possible to do something
> which would accomodate a large range of devices (which is why I
> brought up the concept of exposing virtualized contexts to the file
> system layer).

I am not aware of any actual SSD technology that would take advantage
of it, but at least the upcoming UFS standard that is supposed to
replace eMMC should do it, and it's somewhere inbetween an eMMC and
an SSD in many ways.

	Arnd
