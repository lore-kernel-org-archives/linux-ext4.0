From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Thu, 31 Jul 2014 10:04:34 -0400
Message-ID: <20140731140434.GE10295@kvack.org>
References: <20140707211349.GA12478@kvack.org> <20140708001655.GI8254@thunk.org> <E0178FE2-1C0C-4AF3-BA8C-3F32B4A4ACF7@dilger.ca> <20140730144928.GA10295@kvack.org> <20140731130332.GB1566@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:57064 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGaOEf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 10:04:35 -0400
Content-Disposition: inline
In-Reply-To: <20140731130332.GB1566@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2014 at 09:03:32AM -0400, Theodore Ts'o wrote:
> On Wed, Jul 30, 2014 at 10:49:28AM -0400, Benjamin LaHaise wrote:
> > This seems like a pretty serious regression relative to ext3.  Why can't 
> > ext4's mballoc pick better block groups to attempt allocating from based 
> > on the free block counts in the block group summaries?
> 
> Allocation algorithms are *always* tradeoffs.  So I don't think
> regression is necessarily the best way to think about things.
> Unfortuntaely, your use case really doesn't work well with how we have
> set things up with ext4 now.  Sure, if you your specific use case is
> one where you are mostly allocating 8MB files, then we can add a
> special case where if you are allocating 32768 blocks, we should
> search for block groups that have 32768 blocks free.  And if that's
> what you are asking for, we can certainly do that.

The workload targets allocation 8MB files, mostly because that is a size 
that is large enough to perform fairly decently, but small enough to not 
incur too much latency for each write.  Depending on other dynamics in the 
system, it's possible to end up with files as small as 8K, or as large as 
30MB.  The target file size can certainly be tuned up or down if that makes 
life easier for the filesystem.

> The problem is that free block counts don't work well in general.  If
> I see that the free block count is 2048 blocks, that doesn't tell me
> the free blocks are in a contiguous single chunk of 2048 blocks, or
> 2048 single block items.  (We do actually pay attention to free
> blocks, by the way, but it's in a nuanced way.)
> 
> If the only goal you have is fast block allocation after fail over,
> you can always use the VFAT block allocation --- i.e., use the first
> free block in the file system.  Unfortunately, it will result in a
> very badly fragmented file system, as Microsoft and its users
> discovered.

Fragmentation is not a huge concern, but is more acceptable if the time 
to perform an allocation increases.  Time to perform a write is hugely 
important, as the system will have more and more data coming in as time 
progresses.  At present under load the system has to be able to sustain 
550MB/s of writes to disk for an extended period of time.  With 8MB 
writes that means we can't tolerate very many multi second writes.  
I am of the opinion that expecting the filesystem to be able to sustain 
550MB/s is reasonable given that the underlying disk array can perform 
sequential reads/writes at more than 1GB/s and has a reasonably large 
amount of write back cache (512MB) on the RAID controller.

The use-case is essentially making use of the filesystem as an elastic 
buffer for queues of messages.  Under normal conditions all of the data 
is received and then sent out within a fairly short period of time, but 
sometimes there are receivers that are slow or offline which means that 
the in memory buffers get filled and need to be spilled out to disk.  
Many users of the system cycle this behaviour over the course of a single 
day.  They receive a lot of data during business hours, then process and 
drain it over the course of the evening.  Since everything is cyclic, and 
reads are slow anyways, long term fragmentation of the filesystem isn't a 
significant concern.

> I'm sure that are things we could do that would make things better for
> your workload (if you want to tell us in great detail exactly what the
> file/block allocation patterns are for your workload), and perhaps
> even better in general, but the challenge is making sure we don't
> regress for other workloads --- and this includes long-term
> fragmentation resistance.  This is a hard problem.  Kvetching about
> how it's so horrible just for you isn't really helpful for solving it.

I'm kvetching mostly because the mballoc code is hugely complicated and 
easy to break (and oh have I broken it).  If you can point me in the right 
direction for possible improvements that you think might improve mballoc, 
I'll certainly give them a try.  Hopefully the above descriptions of the 
workload make it a bit easier to understand what's going on in the big 
picture.

I also don't think this problem is limited to my particular use-case.  
Any ext4 filesystem that is 7TB or more and gets up into the 80-90% 
utilization will probably start exhibiting this problem.  I do wonder if 
it is at all possible to fix this issue without replacing the bitmaps used 
to track free space with something better suited to the task on such large 
filesystems.  Pulling in hundreds of megabytes of bitmap blocks is always 
going to hurt.  Fixing that would mean either compressing the bitmaps into 
something that can be read more quickly, or wholesale replacement of the 
bitmaps with something else.

> (BTW, one of the problems is that ext4_mb_normalize_request caps large
> allocations so that we use the same goal length for multiple passes as
> we search for good block groups.  We might want to use the original
> goal length --- so long as it is less than 32768 blocks --- for the
> first scan, or at least for goal lengths which are powers of two.  So
> if your application is regularly allocating files which are exactly
> 8MB, there are probably some optimizations that we could apply.  But
> if they aren't exactly 8MB, life gets a bit trickier.)

And sadly, they're not always 8MB.  If there's anything I can do on the 
application side to make the filesystem's life easier, I would happily 
do so, but we're already doing fallocate() and making the writes in a 
single write() operation.  There's not much more I can think of that's 
low hanging fruit.

Cheers,

		-ben

> Regards,
> 
> 						- Ted

-- 
"Thought is the essence of where you are now."
