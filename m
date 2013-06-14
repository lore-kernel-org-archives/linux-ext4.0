From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Fri, 14 Jun 2013 11:27:22 +0800
Message-ID: <20130614032722.GA8117@gmail.com>
References: <51B7B128.60909@intel.com>
 <20130612071735.GB29898@gmail.com>
 <51B88F1A.5000909@intel.com>
 <20130612204854.GA12456@thunk.org>
 <20130613132715.GA12622@gmail.com>
 <20130613133517.GA13429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130613133517.GA13429@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 13, 2013 at 09:35:17AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 13, 2013 at 09:27:15PM +0800, Zheng Liu wrote:
> > Thanks for your suggestion.  But, sorry, I couldn't get your point here.
> > As you suggested above, we can tag each inode with the last access time
> > when ext4_map_blocks() is called.  Then we will get an unsorted list of
> > inodes with some extent entries.  When we tries to reclaim some entries
> > from extent cache, we can call list_sort() to get an sorted list of
> > inodes and try to reclaim some entries according to the last access
> > time.  My question is why do we need to drop all of the entries from all
> > inodes.
> 
> Sorry, what I meant to say is to drop all of the entries from a
> particular inode.  That is, instead of making the decision to drop one
> or two extents from inode A because they haven't been used in a long
> time, or one or two extents from inode B because they haven't been
> used in a long time, we make the decision on an inode by inode basis.

Sorry, but it seems that we have implemented this algorithm that tries
to reclaim all extents except delayed extent from a particular inode.

Let me describe it, please.  When we access extent status tree of a
particular inode, this inode will be moved into the tail of LRU list
(sbi->s_es_lru).  When we try to reclaim some extents, we will traverse
this list, and reclaim all extents except delayed extent from this
inode until the number of reclaimed objects is equal to 'nr_to_scan' or
all extents has been discarded.

BTW, I have a patch to avoid traverse all entries in LRU list to speed
up this process.

> 
> > Af far as I understand, we can do the following improvement.  We tag the
> > last access time for each inode.  So that would avoid to move the inode
> > in lru list frequently.  When we try to reclaim some entries, we call
> > list_sort() to get a sorted lru list, and drop some entries from lru
> > list.  Please correct me if I misunderstood.
> 
> Yes, that's what I meant;

I have a new patch to implement it.  But as I measure it using 'perf
top', there is no any improvement.  I see that the spin lock burns about
1.3% CPU time in my desktop with 2 Intel CPUs.  Maybe a x86 server with
8 CPUs could highlight this improvement.

> although note that depending on how many
> items we need to drop, it might not be necesary to do a full sort of
> the list --- we could just look for the inode with the oldest time,
> which would be O(n) rather than O(n log n).
> 
> If we are under enough memory pressure that the shrinker is getting
> called a lot, maybe it would be worthwhile keep a list of the oldest N
> inodes, which only gets updated every so many seconds.  (Since we can
> always validate whether or not an inode has been touched since it had
> been put on the oldest N inodes very easily.)

Yes, I will give this a try.

> 
> > For creating all extent leaf blocks, that is another improvement.  I
> > will try to add it after I solve current problem that Dave reported.
> 
> Yes, it's a separable issue, but it's related to the same idea.  We
> should drop items in the cache which can be easily instaniated at the
> time same time (i.e., drop all of the items related to a particular
> extent leaf block, or all of the items related to a particular inode).
> 
> There are of course, other hueristics we could use, such as only
> searching inodes which have open file descriptors.  It's not clear the
> benefit is worth the cost of determining which inodes fit a particular
> criteria or not, though.

Yes, but as you said, we need to measure the benefit from it.

> 
> One other possibility while we're brainstorming is using hints from
> posix_fadvise or madvise to drop items from the extent cache.  The
> cautions with this idea are (a) not that many applications provide
> those hints, and (b) just because one process declares that it doesn't
> anticipate needing to access a particular file, doesn't mean that it
> is true for other users of the same file.  A related classical problem
> is the backup program which reads every single file in the file system
> once.  There's no particular good reason to have the backup program's
> activities affect the caches in the system, whether it be the page
> cache or the extent cache.  The trick is determining whether or not a
> particular program is behaving like a backup program or not, either
> via a hueristic or via an explicit hint/declaration from the program.

To be honest, it is difficulty for us to add a new flag in
fadvise/madvise because other file systems might not provide this hint,
and app A using this hint could affect app B as you described.  But I
agree with you that we could provide a interface to let application
manage extent cache.

Regards,
                                                - Zheng
