From: tytso@mit.edu
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Thu, 11 Feb 2010 14:56:24 -0500
Message-ID: <20100211195624.GM739@thunk.org>
References: <loom.20100204T064311-880@post.gmane.org>
 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
 <20100209174145.GU4494@thunk.org>
 <38f6fb7d1002102301x278c3ddt153f570dd1423074@mail.gmail.com>
 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Jiaying Zhang <jiayingz@google.com>
To: Kailas Joshi <kailas.joshi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49068 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0BKT40 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Feb 2010 14:56:26 -0500
Content-Disposition: inline
In-Reply-To: <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 11, 2010 at 01:02:15PM +0530, Kailas Joshi wrote:
> 
> We are assessing the use of copy-on-write technique to provide data
> level consistency in EXT3/EXT4. We have implemented this in EXT3 by
> using the Ordered mode of operation. Benchmark results for IOZone and
> Postmark are quiet good. We could get the consistency equivalent to
> Journal mode with the overhead almost same as Ordered mode. However,
> there are few cases(for example, file rewrite) where performance of
> Journal mode is better than our technique. We think that in EXT4, with
> the support for delayed block allocation and extents, these problems
> can be removed.

Ah, sorry, I misread your initial post; I thouht you were trying to
reimplement the proposed ext4 mode data=guarded.

I've mostly given up on trying to get alloc_on_commit work, for two
reasons.

The first is that one of the reasons why you might be closing the
transaction is if there's not enough space left in the journal.  But
if we you going to a large number of data allocations at commit time,
there's no guaratee that there will be space in the journal for all of
the metadata blocks that might have to be modified in order to make
the block allocations.

The second problem with this scheme is a performance problem; while
you are doing handling delayed allocation blocks, you have to do this
while the journal is still locked, using magic handles that are
allowed to be created while the journal is locked.  That adds all
sorts of complexity, and that seems to what you are thinking about
doing.  The problem though is that while this is going on, all other
file system activity has to be blocked.  So this will cause all sorts
of processes to become suspended waiting for the all of the allocation
activity to complete, which may require bitmap allocation blocks to be
read into disk, etc.

The trade off for all of these problems is that it allows you to delay
the block allocation for only 5 seconds.  The question is, is this
worth it, compared with simply mounting the file system with
nodelalloc?  It may be all of this complexity doesn't produce enough
of a performance gain over simply using nodelalloc.

So maybe the solution for certain distributions that are catering to
the "inexperienced user" / "users who like to use unstable video
drivers" market is to mount with nodelalloc by default, and tell them
that if they want the performance improvements of delayed allocation,
they need to lobby to get the applications fixed.  

(After all, these problems are going to be around no matter whether
people use XFS or btrfs; most modern file systems are going to use
delayed allocation, so sooner or later the broken applications really
need to get fixed.  The defiant user's cry, "well, if you don't fix
this I'll switch to xfs/btrfs!" isn't going to help in this case....)

     	  	    		      - Ted

