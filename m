From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: allow for fs-specific objects to be pruned as part
 of pruning inodes
Date: Fri, 25 Jan 2013 07:03:10 +1100
Message-ID: <20130124200310.GF2667@dastard>
References: <20130121170937.GB15473@gmail.com>
 <1358921168-30921-1-git-send-email-tytso@mit.edu>
 <20130123133231.GS2498@dastard>
 <20130124005816.bce599de.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	gnehzuil.liu@gmail.com, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130124005816.bce599de.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 24, 2013 at 12:58:16AM -0800, Andrew Morton wrote:
> On Thu, 24 Jan 2013 00:32:31 +1100 Dave Chinner <david@fromorbit.com> wrote:
> 
> > Also, the superblock shrinker is designed around a direct 1:1:1
> > dependency relationship between the superblock dentry, inode and "fs
> > cache" objects. i.e. dentry pins inode pins fs cache object.  It is
> > designed to keep a direct balance of the three caches by ensuring
> > they get scanned in amounts directly proportional to the relative
> > differences in their object counts.  That can't be done with
> > separate shrinkers, hence the use of the superblock shrinker to
> > define the dependent relationship between the caches.
> 
> I was staring at the code and at the 0e1fdafd9 changelog trying to work
> out why prune_super() does its weird shrinker-in-a-shrinker thing.  And
> failing.

commit 8daaa83145ef1f0a146680618328dbbd0fa76939
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jul 8 14:14:46 2011 +1000

    xfs: make use of new shrinker callout for the inode cache
    
    Convert the inode reclaim shrinker to use the new per-sb shrinker
    operations. This allows much bigger reclaim batches to be used, and
    allows the XFS inode cache to be shrunk in proportion with the VFS
    dentry and inode caches. This avoids the problem of the VFS caches
    being shrunk significantly before the XFS inode cache is shrunk
    resulting in imbalances in the caches during reclaim.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Basically, it's to allow filesystems with their own inode cache
management to shrink the cache in direct proportion to the VFS inode
cache so that we don't get situations where the VFS caches get
shrunk to nothing while the filesystem inode cache stays large (and
hence no memory is reclaimed) and vice-versa. The reclaim imbalance
problem ended up so bad I could OOM machines simply by running a
metadata intensive workload....

> IOW it needs a code comment, please.  Ideally one which explains *why*
> "It is designed to keep a direct balance of the three caches...".  What
> would go wrong if the fs were to just register its own shrinker in the
> expected manner?

Nothing, unless there is a direct reclaim relationship between the
filesystem cache and the VFS caches and then independent shrinkers
cannot maintain the balanced relationship between the dependent
caches.  XFS uses normal shrinkers for it's other caches that don't
have a direct 1:1 relationship to the VFS inode and dentry caches,
and that works just fine.

As it is, if you just want to keep random caches at the same object
count as the inodes and dentries, then the fs callout will work just
fine. But if you want something that does not have an equivalent
object count relationship, then a separate shrinker is what is
needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
