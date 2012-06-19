From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 19 Jun 2012 15:17:26 +0000
Message-ID: <201206191517.26687.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206161741.23900.arnd.bergmann@linaro.org> <20120618174214.GA1506@thunk.org>
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
Received: from moutng.kundenserver.de ([212.227.17.9]:55110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2FSPRd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2012 11:17:33 -0400
In-Reply-To: <20120618174214.GA1506@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 18 June 2012, Ted Ts'o wrote:
> On Sat, Jun 16, 2012 at 05:41:23PM +0000, Arnd Bergmann wrote:
> > 
> > * We cannot read from write-only large-unit context, so we have to
> >   do one of these:
> >    a) ensure we never drop any pages from page-cache between writing
> >       them to the large context and closing that context
> >    b) if we need to read some data that we have just written to the
> >       large-unit context, close that context and open a new rw-context
> >       without the large-unit flag set (or write in the default context)
> 
> If we ever a read on the inode in question, we close the large-unit
> context.  That's the simplest thing to do, since we then don't need to
> track which blocks had been written from the inode.  And in general,
> if you have a random read/write workload, large-unit contexts probably
> won't help you.  We mainly would need this when the workload is doing
> large sequential writes, which is *easy* to optimize for.

right.

> > * All writes to the large-unit context have to be done in superpage
> >   size, which means something between 8 and 32 kb typically, so more
> >   than the underlying fs block size
> 
> Right, so we only enable the large-unit context when we are in
> ext4_da_writepages() and we can do the first write in a way that meets
> the requirements (i.e., the write starts aligned on the erase block,
> and is a multiple of the superpage size).  The moment we need to do a
> read (see above) or a write which doesn't meet the large-unit
> restrictions, we close the large-unit context.
> 
> (This is why I asked the question about whether there are performance
> penalties for opening and closing contexts.  If it requires flushing
> the NCQ queues, ala the trim request, then we might need to be more
> careful.)

I believe it should only require flushing that one context, although
a specific hardware implementation might be worse than that. Maybe
Luca or Alex can comment on this.

> > * We can only start the large unit at the start of an erase block. If
> >   we unmount the drive and later continue writing, it has to continue
> >   without the large-unit flag at first until we hit an erase block
> >   boundary.
> 
> My assumption was that when you umount the drive, the file system
> would close all of the contexts.

Yes, makes sense. This is probably required to ensure that the data
has made to the drive, at least for the large contexts, but it is
definitely required for housekeeping of contexts if we manage them
from the block layer.

	Arnd
