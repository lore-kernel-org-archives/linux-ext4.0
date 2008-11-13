From: Theodore Tso <tytso@mit.edu>
Subject: Re: I had to modify some of your patches in the ext4 patch queue
Date: Thu, 13 Nov 2008 09:53:42 -0500
Message-ID: <20081113145342.GA12089@mit.edu>
References: <491C1111.3040602@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51555 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542AbYKMOxq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 09:53:46 -0500
Content-Disposition: inline
In-Reply-To: <491C1111.3040602@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > Looking at defrag-08-add-ioc-move-victim-ioctl, I'm still concerned
> > that we have far too much policy in the kernel-side code.  The fact
> > that there is "phases" for the ioctl seems very wrong.  You don't
> > normally find that in normal system calls, since it implies the kernel
> > is dictating how various system calls will be used, and in what order.
> 
> Do you mean that it is not good EXT4_IOC_DEFRAG ioctl's behavior
> is changed by "phases"?
> If so, is it OK to create new ioctls equivalent to "phases"
> (EXT4_IOC_DEFRAG_FORCE_XXX), for example?

That's not what I was trying to say.  Yes, having separate ioctls
rather than phases is better, but the fact that you have "phases", or
lots of separate ioctls that do very similar things, is in fact a red
flag that indicates that perhaps there's something wrong with the
userspace/kernel interface.

Put another way --- we have system call interfaces such as "open",
"read", "write", etc.  They are very general.  For performance/speed
reasons, we even have system calls such as "sendfile" which will take
a file descriptor and dump the contents out to another file
descriptor, to avoid copying the data in and out of userspace.
However, we do *not* have a "send http file" system call interface
that assembles the http header in the kernel; nor do we have a "send
ftp file" that does the ftp protocol in the kernel and then sends the
file out to the network.  When I look at interfaces which effectively
do, "assign new blocks to this inode, using blocks from inside its
home block group", and "assign new blocks to this inode, using blocks
from anywhere but its home block group", what I see are interfaces
which are insufficiently general.

Consider if you will the following interfaces:

(1)   A move_extent ioctl which takes a structure

struct move_extent
{
	__u64	inode;
	__u64	lblk;
	__u64	old_pblk;
	__u64	new_pblk;
	__u64	length;
}

If the inode is not currently in use, it will return an ENOENT.  If
inode is currently not map the extent (lblk, old_pblk, len), it will
return the error message ESTALE.  If the blocks new_pblk through
new_pblk+len-1 are not free, it will return ENOSPC.  Otherwise, it
will read the contents of the pages lblk through lblk+len-1 into the
page cache, and then reassign those pages to the inode using the new
blocks new_pblk through new_pblk+len-1.

This is a very low-level interface, and means that the userspace has
to do much more of the work.  But it also has the advantage that it is
simple, and we are not putting a lot of policy in the kernel.  For
example, what if it turns out that the right answer is not, "allocate
inside the blockgroup" or "allocate not in the blockgroup", but
rather, allocate the new file within a flexbg group?  The ioctl's
which you have proposed are so specific to a particular
defragmentation approach that they could not be used if we wanted to
use another way of approaching the defragmentation problem.

We can, BTW, make this interface more flexible, by for example
defining that if new_pblk is 0, that we ask the kernel to find a new
location, using the mballoc algorithm, instead forcing the userspace
to choose the best location.

(2) An interface for adding allocation rule to a particular
inode.  These constraints are dropped when the last file descriptor
associated with the inode is closed --- they are not persistent.   

So we have an ioctl for clearing the allocation rules
(IOC_CLEAR_ALLOC_RULE), and an ioctl for adding a rule
(IOC_ADD_ALLOC_RULE).  A new rule is always added to the end of the
list, and the rule looks like this:

struct ext4_alloc_rule {
	__u32	match_type;
	__u32	rule_result;
	__u64	start;
	__u64	end;
};

Match type can be one of the following rules:

ALLOC_MATCH_IN_RANGE -- the proposed extent to be allocated is
	contained within the range start--end.

ALLOC_MATCH_NOT_IN_RANGE -- the proposed extent to be allocated
	is entirely outside of the range start--end

ALLOC_MATCH_PARTIAL_IN_RANGE --- part of the extent overlaps the range
	start--end, and part of the extent is not in the range start--end.

The result of the rule can be:

RESULT_ACCEPT --- the proposed extent can be used
RESULT_REJECT --- the proposed extent can not be used
RESULT_CONTINUE_ACCEPT --- check the next rule in the allocation
	       ruleset; if there are no more rules, accept the extent
RESULT_CONTINUE_REJECT --- check the next rule in the allocation
	       ruleset; if there are no more rules, reject the extent
RESULT_CONTINUE_GLOBAL --- jump to the global allocation ruleset

There are also two ioctls which define the default allocation ruleset
which should be used if a particular inode does not have an allocation
rulset defined for it.  The global default allocation ruleset is
persistent while the filesystem is mounted, but it does not persist
across a reboot or an unmount of the filesystem (i.e., it is attached
to the in-core superblock).  If an inode does not have an allocation
ruleset associated with it, it will use the global allocation rulset.

----

OK so what can we do with these interfaces?  First of all, note that
they can be used for a lot more than just defragmentation.  On a DVR,
for exaple, we could reserve part of the space of the filesystem just
for video streams.  So we could have a global allocation rule which
restricts a portion of the disk from being used by "normal files", and
a specific allocation rule attached to video files which forces them
to allocate blocks out of the reserved area of the filesystem.

Another use for this scheme might be for doing an online shrink of the
filesystem.  We can set a global allocation rule which will prevent
any new blocks from being allocated in the part of the disk that is to
be evacuated, while we use the defragmentation ioctls to move data
blocks for existing files out of the range of the filesystem that is
to be shrunk.

This is the mark of a good kernel interface; the interfaces can be
used to solve problems other than the one which you were originally
setting out to solve.  In constrast, consider the original ioctl with
its rather specific "phases", or even if you broke out each of its
"phase" to individual ioctl's; they are too specific, and not powerful
enough to support some of these use cases described above.


Are the interfaces described above powerful enough to support a
userspace defragmentation engine?  I think the answer is yes, since
they can do everything the original ioctl's can do.  In fact, they do
even more, since the userspace has a much finer grained control over
which blocks get used, or not used.

Are the above interfaces perfect?  Probably not.  I spent maybe 30
minutes designing them, and they might not be succiently general, or
there may be ways in which they aren't quite right.  I think though
that this is a much better starting point, and with some more
refinement this is a much better set of interfaces than what we
currently have.

Regards,

						- Ted
