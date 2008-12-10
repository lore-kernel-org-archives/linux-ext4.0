From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH]ext4: online defrag: Enable to reuse blocks by multiple
 defrag
Date: Wed, 10 Dec 2008 17:00:50 +0900
Message-ID: <493F7732.1020505@rs.jp.nec.com>
References: <493DD75D.60504@rs.jp.nec.com> <20081209054712.GB10270@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41616 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYLJIBS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 03:01:18 -0500
In-Reply-To: <20081209054712.GB10270@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thank you for letting me know.
I think new defrag can be implemented with your proposal.
At first, I am planning to implement usual defrag (without any options)
in the following steps.
Please check whether my approach is fine.

(U:User spcace K:Kernel)
1:U  Create donor inode and then unlink it.

2:U  Allocate contiguous blocks to donor inode with fallocate().

3:U  Call the FS_IOC_FIEMAP ioctl to get the extents information of donor inode.
      And check the extents of donor inode are less than the defrag target inode's.

4:U  Call the EXT4_IOC_DEFRAG ioctl to exchange the data between
      target inode and donor inode.

5:K  The EXT4_IOC_DEFRAG ioctl calls ext4_defrag() in kernel
      (I'm going to change current ext4_defrag() to do only data exchange).

* Step 4 and 5 correspond to Ted's (3) ioctl.

6:U  Close fd of donor inode.


New EXT4_IOC_DEFRAG would be implemented as followings.

#define EXT4_IOC_DEFRAG                 _IOW('f', 15, struct move_extent)

struct move_extent
{
     int org_fd;		/* file descriptor of defrag target file */
     int dest_fd;	/* file descriptor of donor file */
     long long start;	/* logical block offset of target file */
     long long len;	/* exchange data length in block */
}


Also defrag -r and -f options can be implemented with (1) and (2)
in your previous post.  I will address them after implementing usual defrag.


Regards,
Akira Fujita

Theodore Tso wrote:
> On Tue, Dec 09, 2008 at 11:26:37AM +0900, Akira Fujita wrote:
>> I'm redesigning ext4 online defrag based on the comments from Ted.
>> Probably defrag's block allocation method will be changed greatly.
> 
> Akira-san,
> 
> FYI, there was a discussion about defrag on today's ext4 call.  One of
> the ideas that was kicked around was to completely change the
> primitives used by defrag, and to design things around three
> primitive, general purpose interfaces.
> 
> We didn't go into complete detail on the call, but let me give you a
> strawman proposal for consideration/discussion:
> 
> (1) An (ioctl-based) interface which allows a privileged program to
> specify one or more range of blocks which the filesystem's block
> allocator must NOT allocate from.  (We may want to have a flag for
> each block range which either makes the block lockout advisory, such
> that if the block allocator can't find blocks anywhere else, it may
> invade the reserved block area --- or mandatory, where if there are no
> other blocks, the filesystem returns ENOSPC).  This allows the
> defragmenter to work on an area of the disk without worrying about
> concurrent allocations by other processes from getting in the way.
> 
> (2) An (ioctl-based) interface which associates with an inode
> preferred range(s) of blocks which the block allocator will try using
> first; if those blocks are not available, or the block range(s) is
> exhausted, the block allocator use its normal algorithms to pick the
> best available block.  The set of preferred blocks is only guaranteed
> to persist while the inode is in memory.
> 
> (3) An (ioctl-based) interface which takes two inode numbers, and
> allows a privileged program to "defrag" an inode by using blocks from
> a donor inode and using them as the new blocks for the destination
> inode, preserving the contents of the destination inode.
> 
> The advantage of this implementation strategy is that each of the
> interfaces can be implemented one at a time, with very well defined
> semantics, and which can be independently tested.  The semantics can
> also be used in different combinations to solve alternate problems.
> For example, a combination of (1) and (2) can be used to reserve
> blocks for use by a directory that is expected to grow, so the
> directory can use contiguous blocks.  Or, they could be used to
> implement an "online shrink" that would allow a filesystem to be
> resized to a smaller size.
> 
> One other thing that comes to mind.  If it turns out that these
> interfaces have multiple users, and in some cases the reservations or
> block allocation restrictions are expected to last for longer than a
> process lifetime, it may be useful to tag them with a short (8-16
> character) name, so that it is possible to list the current set of
> reservations, and so they can be removed by a privileged user.  This
> could be overdesigning the interface; but the whole *point* of
> thinking about the interfaces from a more generic point of view (as
> opposed for use by a specific program for which the kernel interfaces
> are custom-designed) is that hopefully they will have multiple use
> cases and multiple users, in which case we need to worry about how
> multiple users can co-exist.
> 
> Thoughts, comments?
> 
> 						- Ted
> 
