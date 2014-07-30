From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Wed, 30 Jul 2014 10:49:28 -0400
Message-ID: <20140730144928.GA10295@kvack.org>
References: <20140707211349.GA12478@kvack.org> <20140708001655.GI8254@thunk.org> <E0178FE2-1C0C-4AF3-BA8C-3F32B4A4ACF7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:50072 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaG3Ot3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jul 2014 10:49:29 -0400
Content-Disposition: inline
In-Reply-To: <E0178FE2-1C0C-4AF3-BA8C-3F32B4A4ACF7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas, Ted,

I've finally had some more time to dig into this problem, and it's worse 
than I initially thought in that it occurs on normal ext4 filesystems.

On Mon, Jul 07, 2014 at 11:11:58PM -0600, Andreas Dilger wrote:
...
> The main problem here is that reading all of the block bitmaps takes
> a huge amount of time for a large filesystem.

Very true.

...
> 
> 7.8TB / 128MB/group ~= 8000 groups
> 8000 bitmaps / 100 seeks/sec = 80s
> 
> So that is what is making things slow. Once the allocator has all the
> blocks in memory there are no problems. There are some heuristics
> to skip bitmaps that are totally full, but they don't work in your case. 
> 
> This is why the flex_bg feature was created - to allow the bitmaps
> to be read from disk without seeks.  This also speeds up e2fsck by
> the same 96s that would otherwise be wasted waiting for the disk.

Unfortunately, that isn't the case.

> Backporting flex_bg to ext3 would be fairly trivial - just disable the checks
> for the location of the bitmaps at mount time. However, using it
> requires that you reformat your filesystem with "-O flex_bg" to
> get the improved layout. 

flex_bg is not sufficient to resolve this issue.  Using a native ext4 
formatted filesystem initialized with mke4fs 1.41.12, this problem still 
occurs.  I created a 7.1TB filesystem, filled it to about 92% full with 
8MB files.  The time to create a new 8MB file after a fresh mount ranges 
from 0.017 seconds 13.2 seconds.  The outlier correlates with bitmaps 
being read from disk.  A copy of /proc/fs/ext4/dm-2/mb_groups from this 
92% full fs is available at http://www.kvack.org/~bcrl/mb_groups.ext4-92 

Note that is isn't the first allocating write to the filesystem that is 
the worst in terms of timing, it can end up being the 10th or even the 
100th attempt.

> The other option (if your runtime environment allows it) is to prefetch
> the block bitmaps using "dumpe2fs /dev/XXX > /dev/null" before the
> filesystem is in use. This still takes 90s, but can be started early in
> the boot process on each disk in parallel.

That isn't a solution.  Prefetching is impossible in my particular use-case, 
as the filesystem is being mounted after a failover from another node -- 
any data prefetched prior to switching active nodes is not guaranteed to be 
valid.

This seems like a pretty serious regression relative to ext3.  Why can't 
ext4's mballoc pick better block groups to attempt allocating from based 
on the free block counts in the block group summaries?

		-ben
-- 
"Thought is the essence of where you are now."
