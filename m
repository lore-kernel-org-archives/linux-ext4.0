From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: don't load the block bitmap for block groups which have no space
Date: Mon, 13 Aug 2012 17:20:34 -0600
Message-ID: <A2F8B063-6402-4134-AE45-63CD3D368D27@dilger.ca>
References: <20120809181059.A5BAA11FC69@bugzilla.kernel.org> <1344622885-14982-1-git-send-email-tytso@mit.edu> <50292500.1070807@redhat.com> <20120813184916.GF32484@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57272 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2HMXUg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2012 19:20:36 -0400
In-Reply-To: <20120813184916.GF32484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-13, at 12:49 PM, Theodore Ts'o wrote:
> On Mon, Aug 13, 2012 at 11:02:08AM -0500, Eric Sandeen wrote:
>> 
>> Looks ok to me; I think this just further optimizes what was done
>> in
>> 
>> 8a57d9d61a6e361c7bb159dda797672c1df1a691
>> ext4: check for a good block group before loading buddy pages
>> 
>> correct?
> 
> Yes, that's right; it's a further optimization.
> 
> I can think of an additional optimization where if we are reading the
> block bitmap for block group N, and the block bitmap for block group
> N+1 hasn't been read before (so we don't have buddy bitmap stats), and
> the block bitmap for bg N+1 is adjacent for bg N, we should read both
> at the same time.  (And this could be generalized for N+2, N+3, etc.)

I was thinking the same thing.  Seems a shame that we have contiguous
bitmaps with flex_bg and don't load them all at once.  However, I ended
up deciding not to pursue the issue, because I suspect the block device
will already be doing some physical block/track readahead.  I guess it
couldn't hurt to submit explicit readahead requests, so long as we don't
wait for anything but the first bitmap to actually be loaded.

> I'm not entirely sure whether it's worth the effort, but I suspect for
> very full file systems, it might be very well be.  This is a more
> general case of the problem where most people only benchmark mostly
> empty file systems, and my experience has been that above 70-80%
> utilization, our performance starts to fall off.  And while disk space
> is cheap, it's not _that_ cheap, and there are always customers who
> insist on using file systems up to a utilization of 99%, and expect
> the same performance as when the file system was freshly formated.  :-(

In my experience, there are so many factors that affect the performance
of a full filesystem that nothing can be done about it.

We've discussed changing statfs() reporting for Lustre to exclude the
"reserved" amount from the device size, so that people don't complain
"why can't I use the last 5% of the device" and/or "tune2fs -m 0" to
remove the reserved space, then complain when performance permanently
dives after hitting 100% full due to bad fragmentation of the last 5%
of files written that will not be deleted for many months.  Even with
SSDs, the fragmentation is going to be seen, due to erase block
fragmentation and more IO submission overhead for small chunks.

The other significant factor is the inner/outer track performance can
vary by a factor of 2x on some drives.  The ext4 allocator biases toward
outer tracks, which is good, but performance is down on the inner tracks
regardless of whether there is fragmentation or not.

Cheers, Andreas





