From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Ext4 Workshop Draft Minutes
Date: Mon, 23 Apr 2012 11:02:45 -0400
Message-ID: <E1SMKmr-0002jQ-4N@tytso-glaptop.cam.corp.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39363 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab2DWPCt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Apr 2012 11:02:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Please comment.  Thanks!!

					- Ted


		     Ext4 Workshop -- Draft Minutes
			     March 30, 2012

Introduction
============

The 2012 Ext4 Workshop was held at Google Building 1400 on March 30,
2012.  Although a number of ext4 developers were not able to attend,
we had a very good discussion and we found it to be very valuable.  In
particular, we welcomed Tao Ma and Zheng Liu from Tao Bao and were
able to get a much better understanding of their use cases of
interest.

Tao Bao is using ext4 in many different ways --- including back ends
for cluster file systems (Hadoopfs and an internally developed cluster
file system), content delivery networks, and for databases.  (This is
not that different from the uses of ext4 at Google, and so it was nice
to compare notes regarding technical challenges and approaches to
address those challenges.)

Development Process Issues
==========================

Patch sets ready for review
---------------------------

The following new patch sets should be ready for review for the next
(for v3.5) merge window:

1) 64-bit on-line resize using meta_bg from Yongqiang Yang
2) metadata checksums from Darrick Wong
	- requires e2fsprogs changes
3) inline data from Tao Ma
	- requires e2fsprogs changes

Code review
-----------

Ted reiterate a plea for help for in reviewing patches.  One
suggestion which we wil try implementing is to send announcements for
a particular patch set: "this week we will review the metadata
checksum e2fsprogs changes".  This will help focus people on a
particular features.  This will also give more visibility to people
who are following ext4 development about upcoming features.

Conference call
---------------

We discussed with the current time of the ext4 conference call (8am
US/Pacific); the folks from Tao Bao assured us that 11pm in China
wasn't too late, and that in the future, they would be joining the
conference call.  (If there are other folks who are interested in
joining the weekly ext4 call, please contact tytso@mit.edu or
cmm@us.ibm.com.)

Technical Issues
================

Big Extents cache
-----------------

Nauman Rafique has implemented a in-memory btree extent cache which
can collapse multiple physical extent entries which are contiguous in
physical and logical block number space into a single in-memory
extents.  For this reason, it is called "big extents".  This work was
originally motivated by very fast flash devices (where the cost of
cache misses when doing binary search on the extent leaf block can be
measurable).  However, this would solve a number of other problems,
including async I/O being really asynchronous, and it would also
address why Tao Bao is interested in changing the extent format to
break the 2**15 block extent length limitation.  (There are other
advantages that would accrue to creating a V2 extent tree format, such
as breaking the 2**32 logical block limitation, but that isn't
currently a strong motivation for any of the current ext4 developers.)

I/O Tree
--------

One of the other things that was discussed at the workshop was
something that has been loosely called the I/O tree.  This would be an
in-memory data structure to track the status of delayed allocation
writers, required uninit->init extent conversions, etc.  There is a
proof-of-concept implementation which Yongqiang Yang fielded that
tracked delayed allocation writes, and which Allison Henderson had
started looking at.  Tao Bao indicated an interest to pick up this
work.

The I/O tree would allow us to significantly simplify our delayed
allocation support, and it is a prerequisite to solving the
bigalloc/delalloc bug where we have trouble tracking when we write to
a previously unallocated 4k block, whether it is the first 4k block in
a bigalloc cluster which has been subject to delayed allocation
accounting or not.

One open question is whether the I/O tree should be implement as
something independent to the big extent tree cache, or in parallel
with the big extent tree cache.  The primary arguments in favor of
combining the functionality of these two trees into a single data
structure are (a) that it will save memory since a large part of the
overhead of a in-memory tree structure is the pointers and (b) there
will be code duplication in maintaining the two in-memory trees.

The argument for keeping these two trees separate is (a) we have
proof-of-concept implementation for both of these trees already, and
working on them in parallel might be more efficient, and (b) the I/O
tree only needs to be kept for inodes that are opened, or still has
dirty pages that haven't been flushed out or has I/O still in flight.
The inodes that are not opened, but just in the inode cache, will stay
in memory on a much longer term.  Combining the two trees could add
fields to the extent cache that would not be needed in for
closed/inactive files, thus bloating them.  In addition, fs code that
needs to assure the I/O tree is empty would have to search through all
of the extent cache nodes to support things like fsync() or during the
writeback code.

At least initially, we'll proceed with an implementation with two
separate trees, and then we can investigate whether or not it makes
sense to unify the code handling the two in-memory trees.

[ Note: since the workshop, Allison Headerson has sent out a
  proof-of-concept patchset for "status extents" which are essentially
  the I/O tree idea concept discussed at the workshop.  Zheng Liu will
  be taking over work on this patch set. ]

Future of Snapshot Patches
--------------------------

At the workshop we discussed the future of the snapshot patches.
There is still a large concern over the complexity and maintainability
of those patches.  One of the things which we are looking very closely
at are the dm-thin snapshot work.  There are some downsides, including
the fact that you need to have a separate partitions for the dm-thin
snapshot storage, and there were some questions over the performance
of the dm-thin snapshot code.  However, the combination of dm-thin
plus discard patches is worth a closer look.

Controlling Feature and mount flag combinatorics
------------------------------------------------

(This was discussed at a informal ext4 meetup during the Collaboration
Sommit, which took place after the ext4 workshop; we had this meeting
primarily because folks from Red Hat, such as Eric Sandeen, Lukas, and
Ric Wheeler were not able to attend the ext4 workshop on Friday.0

Eric and Ric expressed some continuing concern over the complexity
caused by the large number of feature flags and mount flags, both from
a distribution support perspective and from a testing perspective.
They would prefer that we give more guidance to users over what has
been fully tested and supported both by the upstream community and
then by the distributions.

After some discussion, Eric will look at implementing a framework
where for upstream kernels, if the user specifies a "non-standard"
combination of feature flags and mount options, the kernel will issue
a warning message indicating that this is not a configuration which is
tested regularly by ext4 developers, and requesting the user to
contact the ext4 mailing list if they feel they have a use case such
that this particular combination should be supported.  Distributions
could use the same framework to issue a message regarding support
status, including possibly setting a taint flag.
