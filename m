From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext2_find_near
Date: Thu, 31 Jul 2008 12:23:52 -0400
Message-ID: <20080731162352.GE11632@mit.edu>
References: <2d08ef090807310747p72716f56v6271f81aef7cb8a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Rohit Sharma <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37518 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010AbYGaQXz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 12:23:55 -0400
Content-Disposition: inline
In-Reply-To: <2d08ef090807310747p72716f56v6271f81aef7cb8a8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 08:17:06PM +0530, Rohit Sharma wrote:
> What I understand from it is that it has something to do with reducing
> the chances of a concurrent allocation -- supposedly from a different
> PID.

Yes, that's exactly it.  To quote from from comment above the function:

 * In the latter case we colour the starting block by the callers PID to
 * prevent it from clashing with concurrent allocations for a different inode
 * in the same block group.

In computer science, the concept of "coloring" is to spread the
allocation across multiple (cpu's, processes, etc.) while
concentrating accesses from a specific CPU, processes, etc., in order
to provide better performance.  You will see references to coloring
pages for virtual memory systems, coloring slabs in slab allocators to
improve better cache utilization, etc.

When people talking using coloring to increase cache utilization, the
goal is to reduce the chances that cache collisions lead to premature
ejection of data from the cache.  In the case of block allocation, the
goal is that if you have two processes writing into the same directory
(for example, if you are compiling a program using "make -j4") that
they don't "collide" and start allocating blocks from the same
starting point, since that might result in an interleaved allocation
for the files.

What is going on here is that code is splitting the block group into
16 zones, and it using the low 4 bits of the process ID (i.e., pid %
16) to determine "zone" in the block group is used as a starting point
for the allocation.

This is a hueristic, and like all hueristics, in some cases it wins,
in other cases it is a lose.  Something like delayed allocation can do
a much better job than this particular hueristic.

					- Ted
