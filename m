From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
	checker)
Date: Sun, 20 Apr 2008 22:33:42 -0400
Message-ID: <20080421023342.GC9700@mit.edu>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <87ej9085dq.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ej9085dq.fsf@basil.nowhere.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 21, 2008 at 01:37:37AM +0200, Andi Kleen wrote:
> Are you sure about all data? I think he would just need some lookup table from 
> metadata block numbers to inode numbers and then when a hit occurs on a block
> in  the table somehow invalidate all data related to that inode
> and restart that part. And the same thing for bitmap blocks. That lookup
> table should be much smaller than the full metadata.

Yeah, unfortunately it's close to all of the metadata.  Consider that
e2fsck also has to deal with changes in the directory, and there can
be multiple hard links in a directory, so it's not just a simple
lookup table.  You could try to condense the directory into a list of
inodes numbers and the number of times they were counted in a
directory, but then any time the directory changed, you'd have to
rescan the *entire* directory.

Also, consider that the lookup table might not be enough, if the
filesystem is actually corrupted, and there are multiple blocks
claimed by an inode.  How you "invalidate all data" in that case
becomes less obvious.

It would be possible to condense the metdata somewhat by taking the
omitting unused inodes, and storing the indirect blocks as extents.
But there would still be a huge amount of metadata that would have to
be stored in memory.  If you're willing to completely rewrite e2fsck
(which the on-line resize would need anyway, because the updated data
could invalidate the previously done work at any point anywhere in the
e2fsck processing), maybe the extra cached data structures won't be on
completely additive on top of the other intermediate data kept by
e2fsck, but it once again points out it would be insane for a student
to try to do this in 3 months.

> Anyways my favourite fsck wish list feature would be a way to record the 
> changes a read-only fsck would want to do and then some quick way
> to apply them to a writable version of the file system without 
> doing a full rescan. Then you could regularly do a background check
> and if it finds something wrong just remount and apply the changes
> quickly.

This is a read-only fsck while the filesystem is changing out from
underneath it, and the hope is that you can take the instructions
gathered from the read-only fsck (presumably run on a snapshot) and
then apply them to filesystem that has since been modified after the
snaphot was taken.  Even if it has been remounted read-only at this
point, this gets really dicey.  Consider that with certain types of
corruption, if the filesystem continues to get modified, the
corruption can get worse.

> Or perhaps just tell the kernel which objects is suspicious and
> should be EIOed.

Yeah; you could do that, as long as it's not a guarantee that all of
the objects which were suspicious were found.  It would also be
possible to isolate the objects, perhaps with some potential inode and
block leakage that would get fixed at the next off-line fsck.  Still,
it would be a lot of work.  Let me know if someone is willing to pay
for this, and I could probably work with someone like Val to execute
this.  But otherwise, it probably falls in the "we'd all like a pony"
sort of wishlist.....

							- Ted
