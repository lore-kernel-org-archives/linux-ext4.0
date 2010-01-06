From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH]ext4: online defrag: Enable to reuse blocks by multiple
 defrag
Date: Tue, 5 Jan 2010 21:06:43 -0800 (PST)
Message-ID: <27026776.post@talk.nabble.com>
References: <493DD75D.60504@rs.jp.nec.com> <20081209054712.GB10270@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:49238 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0AFFGn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 00:06:43 -0500
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1NSO6V-0004eS-7H
	for linux-ext4@vger.kernel.org; Tue, 05 Jan 2010 21:06:43 -0800
In-Reply-To: <20081209054712.GB10270@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

Sorry for the late reply...


tytso wrote:
> 
> 
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

What exactly do we mean here by the preferred range(s) of block here? 
A couple of months back in a similar context a patch was submitted from
Akira to which he was suggested to work the patch on the existing mechanism
of PA.

In case of PA the allocation must start from pa_pstart strictly, which would
not truly mean
preferred block RANGES. Consider a case where you have an inode A with PA of
block range = {100, 500}
and later blocks {100, 300} are allocated to some inode B.

Later when block allocation request of 150 blocks comes for inode A, even
though blocks {301-500} is free in the PA range, the allocation through PA
would fail.

So, if we implement the above mentioned ioctl-based interface will it truly
serve the purpose? Or How about thinking of it in lines of preferred block
group ranges, which should serve the above mentioned purpose.

What I understand about PA is that PA are to be purely used by and within
the block allocator to make best judgement of deciding the preferred ranges
to block (to avoid fragmentation) but should not be allowed to be
manipulated through any ioctl based interface or external interfaces.



tytso wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://old.nabble.com/-PATCH-ext4%3A-online-defrag%3A-Enable-to-reuse-blocks-by-multiple-defrag-tp20907596p27026776.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

