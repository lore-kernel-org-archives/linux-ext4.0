From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 9 Jun 2011 09:09:08 -0400
Message-ID: <20110609130908.GA22360@infradead.org>
References: <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
 <20110603002714.GA27129@redhat.com>
 <20110603004300.GE16306@thunk.org>
 <20110603005403.GB27129@redhat.com>
 <20110603010233.GA17726@infradead.org>
 <20110603012858.GC27129@redhat.com>
 <20110603013345.GD27129@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54839
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757680Ab1FINJL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2011 09:09:11 -0400
Content-Disposition: inline
In-Reply-To: <20110603013345.GD27129@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 09:33:45PM -0400, Vivek Goyal wrote:
> > Yes this patch helps. I have already laid out the file and doing
> > overwrites.
> > 
> > I throttled aio-stress in one cgroup to 1 byte/sec and edited another
> > file from other cgroup and did a "sync" and it completed.
> 
> Even other test where I am running aio-stress in one window and edited
> a file in another window and typed "sync" worked. "sync" does not hang
> waiting for aio-stress to finish.

I've been thinking about the patch a bit more, and I think it's simply
incorrect.  i_iocount is the only thing that actually tracks in-flight
DIO/AIO requests, so we can't actually skip incrementing it as that
means we can't wait for pending AIO in fsync/sync/inode reclaim or
remount r/o.

We could simply declare AIO is off limits for sync and skip it there,
which is easily doable, but we'd still need a special case version of
sync for remount r/o as that absolutely needs to stop all pending I/O.

Of the other filesystem ext4 also has the counter, but only waits for
it during inode teardown, and using a slightly different, but also
effective scheme for fsync, but completely ignores sync and remount.

I couldn't find a similar scheme in other filesystem supporting AIO,
but it might be hidden a bit better.

I suspect we could optimize things by using the dual count and list
approach ext4 does - there is a counter for in-flight direct I/O, which
we only check for inode teardown and remount, as those need to stop
pending I/O, but sync and fsync can skip them as they only need to
flush pending I/O.  There is a list for the pending unwritten extent
conversions that only gets appended to when the actual I/O is done,
and the unwritten extent conversion is queued up. 

I'll see if I can come up with a good scheme for that, preferably
sitting directly in the direct I/O code, so that everyone gets it
without additional work.
