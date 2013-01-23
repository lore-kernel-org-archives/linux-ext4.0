From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: allow for fs-specific objects to be pruned as part
 of pruning inodes
Date: Thu, 24 Jan 2013 00:32:31 +1100
Message-ID: <20130123133231.GS2498@dastard>
References: <20130121170937.GB15473@gmail.com>
 <1358921168-30921-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	gnehzuil.liu@gmail.com, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28650 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584Ab3AWNcf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2013 08:32:35 -0500
Content-Disposition: inline
In-Reply-To: <1358921168-30921-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2013 at 01:06:08AM -0500, Theodore Ts'o wrote:
> The VFS's prune_super() function allows for the file system to prune
> file-system specific objects.  Ext4 would like to use this to prune
> parts of the inode's extent cache.  The object lifetime rules used by
> ext4 is somewhat different from the those of the dentry and inode in
> the VFS.  Ext4's extent cache objects can be pruned without removing
> the inode; however if an inode is pruned, all of the extent cache
> objects associated with the inode are immediately removed.
> 
> To accomodate this rule, we measure the number of fs-specific objects
> before the dentry and inodes are pruned, and then measure them again
> afterwards.  If the number of fs-specific objects have decreased, we
> credit that decrease as part of the shrink operation, so that we do
> not end up removing too many fs-specific objects.

Doesn't work. Shrinkers run concurrently on the same context, so a
shrinker can be running on multiple CPUs and hence "interfere" with
each other. i.e. A shrinker call on CPU 2 could see a reduction in
a cache as a result of the same shrinker running on CPU 1 in the
same context, and that would mean the shrinker on CPU 2 doesn't do
the work it was asked (and needs) to do to reclaim memory.

It also seems somewhat incompatible with the proposed memcg/NUMA
aware shrinker infrastructure, where the shrinker has much more
fine-grained context for operation than the current infrastructure.
This seems to assume that there is global context relationship
between inode cache and the fs specific cache.

Also, the superblock shrinker is designed around a direct 1:1:1
dependency relationship between the superblock dentry, inode and "fs
cache" objects. i.e. dentry pins inode pins fs cache object.  It is
designed to keep a direct balance of the three caches by ensuring
they get scanned in amounts directly proportional to the relative
differences in their object counts.  That can't be done with
separate shrinkers, hence the use of the superblock shrinker to
define the dependent relationship between the caches.

i.e. the relationship between the VFS inode and the XFS inode is
that they are the same object, but the "XFS inode" lives for some
time after the VFS is done with it. IOWs, the VFS inode reclaim does
not free any memory, so the reclaim work needs to be transferred
directly to the "fscache shrinker" to free the inode objects.

e.g.  if we have a batch of 100 objects to scan and al the caches
are of equal sizes, 33 dentries are scanned, 33 VFS indoes are
scanned, and 33 XFS inodes are scanned, The result is that for every
100 objects scanned, we'll free 33 dentries and 33 inodes. And if
the caches are out of balance, the biasing of the reclaim towards
different caches will pull them back into even proportions of object
counts.  i.e. the proportioning is very carefully balanced around
maintaining the fixed relationship between the different types
objects...

In your proposed use case, the ext4 extent cache size has no direct
relationship to the size of the VFS inode cache - the can both
change size independently and not impact the balance of the system
as long as the hot objects are kept in their respective caches when
under memory pressure.

When the cache size proportion varies with workload, you want
separate shrinkers for the caches so that the memory pressure and
number of active objects the workload generates determines the cache
size. That's exactly what I'd say is necessary for an extent cache -
it will balloon out massively larger than the inode cache when you
have fragmented files, but if you have well formed files, it will
stay relatively small. However, the number of inodes doesn't change,
and hence what we have here is the optimal cache size proportions
change with workload...

i.e. the superblock fscache shrinker callout is the wrong thing to
use here asit doesn't model the relationship between objects at all
well. A separate shrinker instance for the extent cache is a much
better match....

> In the case where fs-specific objects are not removed when inodes are
> removed, this will not change the behavior of prune_super() in any
> appreciable way.  (Currently the only other user of this facility is
> XFS, and this change should not affect XFS's usage of this facility
> for this reason.)

It can change behaviour is surprisingly subtle, nasty ways.

The XFS superblock shrinker is what provides that memory reclaim
rate throttling for XFS, similar to the way the page cache throttles
writes to the rate at which dirty data can be written to disk. In
effect, it throttles the rate of cache allocation to the rate at
which we clean and free inodes and hence maintains a good system
balance.

The shrinker is also designed to prevent overloading and contention
in the case of concurent execution on large node count machines. It
prevents different CPUs/nodes executing reclaim on the same caches
and hence contending on locks. This also further throttles the rate
of reclaim by blocking shrinkers until they can do the work they
were asked to do by reclaim. IOWs, there are several layers of
throttling in the XFS shrinker, and the system balance is dependent
on the XFS inode shrinker being called appropriately.

With these two cache counters, XFS is guaranteed to see different
inode counts as shrinker reclaim always happens concurrently, not to
mention there is also background inode reclaim also running
concurrently. The result of decreasing counts (as will happen
frequently) is that the cwthis shrinker-based reclaim will not be
run, and hence inode reclaim will not get throttled to the rate at
which we can clean inodes or relcaim them without contention.

The result is that the system becomes unstable and unpredictable
under memory pressure, especially under workloads that dirty a lot
of metadata. Think "random OOM conditions" and "my system stopped
responding for minutes" type of issues....

Like I said, surprisingly subtle and nasty....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
