From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext2] Mislabeled quadratic probing?
Date: Sun, 30 Jul 2017 18:22:58 -0400
Message-ID: <20170730222258.whb5onhp26ew62bv@thunk.org>
References: <07c8955b-0ead-9dd9-978e-767d5dec6712@gmail.com>
 <20170730023718.GH15980@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sean Anderson <seanga2@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack@suse.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46944 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751076AbdG3WXF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Jul 2017 18:23:05 -0400
Content-Disposition: inline
In-Reply-To: <20170730023718.GH15980@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 29, 2017 at 07:37:18PM -0700, Matthew Wilcox wrote:
> 
> The biggest danger I see here is that we're only going to test 32
> groups before falling back to linear probing (we'll shift the single
> '1' bit out of 'i' in 32 steps).  That might be a performance problem,
> but it should hit quite rarely.
> 
> The danger in changing it is that we'll end up with new files created in
> a directory choosing a different block group from files created in that
> directory using an old kernel.  And that could be a worse performance
> impact.

The original assumption behind this scheme was that by the time we
fill a block group --- say block group #42, it was highly likely that
the linear probing for block allocations would have filled block
groups #43, #44, #45, etc.  So by the time block group was filled,
when we are allocating a new inode, the idea was to jump much farther
away.

It's also fair to say that we spent a lot more time thinking about the
Orlov algorithm which spreads new directories than we did how
find_group_other() would work.  Note: Orlov algorithm was originally
implemented in the BSD FFS, and was then imported into ext2 by Al
Viro.

> I think we'd need to see some benchmarks ... Ted, any suggestions for
> something which might show a difference between these two approaches
> to hashing?

Trying to benchmarks different allocation algorithms are hard.  The
problem is that allocation patterns are very different depending on
workloads, and it's not just one workload, but usually, there is a
combination of workloads resulting in different levels of free space
fragmentation.  Not only the workloads or combination of workloads
matter, but the amount of free space can also make a huge difference.

When I worked on the changes for ext4's allocation algorithm, I used a
combination of measuring time to run various benchmarks and looking at
free space fragmentation information using e2freefrag and looking at
reports of file fragmentation by using "e2fsck -E fragcheck".  I did
this after inducing various amounts of fragmentation, using various ad
hoc means; I should have done more to automate and to make this be
more controlled.

There is certainly much more that can be done to improve allocation
algorithms, for ext2 and ext4.  With ext2, though, you give up so much
performance from the use of indirect blocks, that it's probably not
worth trying to change the inode and block allocation algorithms for
ext2.

We do use the same "quadratic hash" algorithm in ext4, so it's
something that works better is worth some thought.  One of the
problems is that depending on the number of blocks in the file system,
using a pure quadratic probing can cause duplicate probes to the same
buckets.  Unlike in a hash table, the number block groups isn't
necessarily going to be prime, or a pure power of two, in which case
we could use something like this:

	((i + i*i)/2) % n

So if we use a quadratic hash, we might want to artificially limit the
number of probes, but at the same time, we might want to make sure we
try some buckets that are fairly far away if the first couple of
probes don't succeed.  But that's kind of what an exponential probing
scheme does, which is what we have.  So it's not entirely clear trying
to use a quadratic hash would actually be a better approach.

       	 	   	      	       	  - Ted
