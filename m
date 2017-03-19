From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add largedir feature
Date: Sun, 19 Mar 2017 09:34:25 -0400
Message-ID: <20170319133425.gxeg3mba3brvztjf@thunk.org>
References: <4FA5F6BA-7264-42E3-B4E7-2EAD6FDD0AB1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54788 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbdCSNel (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 19 Mar 2017 09:34:41 -0400
Content-Disposition: inline
In-Reply-To: <4FA5F6BA-7264-42E3-B4E7-2EAD6FDD0AB1@dilger.ca>
 <175204AC-DBDD-4894-8944-BBD98388F547@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 18, 2017 at 11:38:38PM -0600, Andreas Dilger wrote:
> 
> Actually, on a Lustre MDT there _are_ only zero-length files, since all
> of the data is stored in another filesystem.  Fortunately, the parent
> directory stores the last group successfully used for allocation
> (i_alloc_group) so that new inode allocation doesn't have to scan the
> whole filesystem each time from the parent's group.

So I'm going to ask a stupid question.  If Lustre is using only
zero-length files, and so you're storing all of the data in the
directory entries --- why didn't you use some kind of userspace store,
such as Mysql or MongoDB?  Is it because the Lustre metadata server is
all in kernel space, and using ext4 file system was the most
expeditious way of moving forward?

I'd be gratified... surprised, but gratified... if the answer was that
ext4 used in this fashion was faster than MongoDB, but to be honest
that would be very surprising indeed.  Most of the cluster file
systems... e.g., GFS, hadoopfs, et.al, tend to use a purpose-built
key-value store (for example GFS uses bigtable) to store the cluster
metadata.

> The 4-billion inode limit is somewhat independent of large directories.
> That said, the DIRDATA feature that is used for Lustre is also designed
> to allow storing the high 32 bits of the inode number in the directory.
> This would allow compatible upgrade of a directory to storing both
> 32-bit and 64-bit inode numbers without the need for wholescale conversion
> of directories, or having space for 64-bit inode numbers even if most
> of the inodes are only 32-bit values.

Ah, I didn't realize that DIRDATA was still used by Lustre.  Is the
reason why you haven't retried merging (I think the last time was
~2009) because it's only used by one or two machines (the MDS's) in a
Lustre cluster?

I brought up the 32-bit inode limit because Alexey was using this as
an argument not to move ahead with merging the largedir feature.  Now
that I understand his concerns are also based around Lustre, and the
fact that we are inserting into the hash tree effectively randomly,
that *is* a soluble problem for Lustre, if it has control over the
directory names which are being stored in the MDS file.  For example,
if you are storing in this gargantuan MDS directory file names which
are composed of the 128-bit Lustre FileID, we could define a new hash
type which, if the filename fits the format of the Lustre FID, parses
the filename and uses the low the 32-bit object ID concatenated with
the low-32 bits of the sequence id (which is used to name the target).

If you did this, then we would limit the number of htree blocks that
you would need to keep in memory at any one time.  I think the only
real problem here is that with only a 32-bit object id namespace, you
must eventually need to reuse object ID's, at which point you could no
longer be allocating them sequentially.  But if you were willing to
use some parts of the 64-bit sequence number space, perhaps this could
be finessed.

I'd probably add this as a new, Lustre-specific hash alongside some
other proposed new htree hash types that have been propsoed over the
years, but this would allow MDS inserts (assuming that each target is
inserting new objects using a sequentially increasing object ID) to be
done in a way where they aren't splatter themselves all over the
htree.

What do you think?

On Sun, Mar 19, 2017 at 12:13:00AM -0600, Andreas Dilger wrote:
> 
> We have seen large directories at the htree limit unable to add new
> entries because the htree/leaf blocks become fragmented from repeated
> create/delete cycles.  I agree that handling directory shrinking
> would probably solve that problem, since the htree and leaf blocks
> would be compacted during deletion and then the htree would be able
> to split the leaf blocks in the right location for the new entries.

Right, and the one thing that makes directory shrinking hard is what
to do with the now-unused block.  I've been thinking about this, and
it *is* possible to do this without having to change the on disk
format.

What we could do is make a copy of the last block in the directory and
write it on top of the now-empty (and now-unlinked) directory block.
We then find where to find the parent pointer for that block by
looking at the first hash value stored in the block if it is an index
block, or hash the first directory entry if it is a leaf block, and
then walk the directory htree to find the block which needs to be
patched to point at the new copy of that directory block, and then
truncate the directory to remove that last 4k block.

It's actually not that bad; it would require taking a full mutex on
the whole directory tree, but it could be done in workqueue since it's
a cleanup operation so we don't have to slowdown the unlink or rmdir
operation.

If someone would like to code this up, patches would be gratefully
accepted.  :-)

Cheers,

					- Ted
