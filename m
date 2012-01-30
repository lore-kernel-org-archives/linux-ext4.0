From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Mon, 30 Jan 2012 18:52:36 -0500
Message-ID: <20120130235236.GC20940@thunk.org>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
 <20120125224847.GT15102@dastard>
 <4C9A2CF5-A980-43A0-9D43-56EA45DA096C@dilger.ca>
 <20120127001904.GB15102@dastard>
 <4F22B436.9070306@tao.ma>
 <20120129220705.GE15102@dastard>
 <01B555EA-1364-4288-ACE8-0EF42533701E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Tao Ma <tm@tao.ma>,
	Robin Dong <hao.bigrat@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44218 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab2A3Xws (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 18:52:48 -0500
Content-Disposition: inline
In-Reply-To: <01B555EA-1364-4288-ACE8-0EF42533701E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As a large meta-comment, let me say that I find that most
conversations about which file systems users "should" are very often
not very useful.  Even less useful is what developers "should" be
working on.  In that way, my philosophy of ext4 is that it should be
like the Linux kernel; it's an evolutionary process and central
planning is often overrated.  People contribute to ext4 for many
different reasons, and that means they optimize ext4 for their
particular workloads.  Like Linus for Linux, we're not trying to
architect for "world domination" by saying, "hmm, in order to 'take
out' reiserfs4, we'd better implement features foo and bar".

Instead, it's things like "gee, this company over here is interested
in using ext4 as a back-end store for a cluster file system where the
journal is unnecessary overhead and performance under severe memory
pressure is important" --- and so we got no journal mode and some
improvements to the block allocator so it works better under those
conditions.

People contribute to ext4 for different goals, just as people
contribute to Linux for different goals.  And just as there are times
when improvements for big servers have improved Linux's capabilities
for embedded machines, and vice versa, there are similar things that
can and have happened for ext4 (such as extents and the multi-block
allocator originally being developed for Lustre, but which have been
very useful for many other use cases).

Personally, I find that I get a lot more joy out of programming to
make a codebase better --- as opposed programming with the goal to
kill off some other codebase, or discouraging other users to use some
other codebase.

Now that's an open source approach to things.  Things are no doubt
very different if you are trying to allocate engineering resources at
a distribution.  So there may be some tensions between a desire from
an open source perspective to be as flexible as possible, and a
company's position that they only want to support a limited set of
configuration options.  I think those decisions are ones which are
best made by the distribution, and not as part of the open source
process.  After all, what might make sense for one distribution's
customer base and business model, might not make sense for another's.

There are some dangers to that model; for example, RAID support was
only implemented for the Lustre's private in-kernel (and out-of-tree)
API.  Some smarts in ext4's writepages codepath so that we can
properly handle RAID support is currently lacking.  I'd work on it,
except that I don't personally (nor does my employer) has a strong
need to worry about RAID systems.  I'll certainly integrate code that
fixes that problem, and I'm confident that eventually someone will
decide that's the one bit of improvement they need so that ext4 is a
good match for their use case.  I'm definitely not going to stress
that this is something we have to do right away just so we can kill
off XFS; most of us are hopefully working on ext4 because it's fun,
and secondarily because amazingly enough our employers are willing to
pay for us to work on something cool.  (Just as I'm glad most Linux
kernel developers weren't waking up trying to think up ways to kill
off FreeBSD or try to put the Mark Williams Company out of business.  :-)

Let me also add that competition is a good thing.  It keeps all of us
on our toes.  Legacy unix systems accepted that system calls and
context switches were naturally slow, until Linux proved that it could
be done very quickly and efficiently.  SGI didn't bother dealing with
XFS's slow metadata performance even tough they were selling desktops
during its original development.  It was only when Ric Wheeler (as he
tells the story) told the XFS developers how much XFS lagged on
fs_mark that there was a strong effort to address those issues, over a
decade and a half after XFS's original deployment.  That's why I don't
believe it's productive to say that a particular file system has no
place in an ecosystem.  If developers are continuing to work on an OS,
or a file system, and if users continue to use it, then of course it
has a place.  You might not understand why that might be true
initially, but in general it's not because everyone is being
foolish/stupid.

One last observation.  It's dangerous to focus on just one benchmark;
especially if it is a micro-benchmark.  As a tool to improve one
aspect of a file system's performance, it's certainly useful.  But how
many workloads will really hammer a file system with 16 cores, by
creating lots of small files and nothing else?  I have no doubt that
we could improve ext4's scalability for that particular workload.  But
is that a deadly shortcoming that should cause ext4 developers to drop
everything else they are doing and work on this problem, lest users
immediately reformat their disks and switch to another file system
because ext4's block allocator isn't as scalable as it could be for
lots of small block allocations done in parallel?

I'd suggest that might be an over-reaction.

Best regards,

						- Ted
