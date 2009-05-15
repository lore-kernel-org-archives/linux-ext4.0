From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 06:27:19 -0400
Message-ID: <20090515102719.GB6816@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090515045827.GB1279@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48256 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbZEOK11 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 06:27:27 -0400
Content-Disposition: inline
In-Reply-To: <20090515045827.GB1279@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 10:28:27AM +0530, Aneesh Kumar K.V wrote:
> > commit 8ff799da106e9fc4da9b2a3753b5b86caab27f13
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Thu May 14 00:39:48 2009 -0400
> > 
> >     ext4: Add a block validity check to ext4_get_blocks_wrap()
> >     
> >     A few users with very large disks have been reporting low block number
> >     filesystem corruptions, potentially zapping the block group
> >     descriptors or inodes in the first inode table block.  It's not clear
> >     what is causing this, but most recently, it appears that whatever is
> >     trashing the filesystem metadata appears to be file data.  So let's
> >     try to set a trap for the corruption in ext4_get_blocks_wrap(), which
> >     is where logical blocks in an inode are mapped to physical blocks.
> 
> 
> We already do block validation in allocator. In
> ext4_mb_mark_diskspace_used we check whether the block allocator is
> wrongly getting blocks from system zone. So i guess we don't need
> this patch. Or may be we need to remove the check in
> ext4_mb_mark_diskspace_used and add the ckeck in get_block so that
> it catches the extent cache corruption as found by this bug.

Yeah, I was debating what to do with this patch long term.  It catches
problems than the sanity checks in ext4_mb_mark_diskspace_used() in
mballoc.c, or ext4_valid_extent() in ext4/extents.c will miss.
However, (a) it's expensive to do these sorts of tests, and (b) it
only checks for problems in the primary block group descriptors and
first block group's inode tables, since this is where we had been
reporting problems.

The other problem is that ext4_mb_mark_diskspace_used()'s tests assume
!flex_bg, and with flex_bg, its checks are largely ineffective.

What I think the right approach probably will be is that we need to
build an rbtree of the "system zone" blocks at mount time.  Especially
with flex_bg, in the normal case the block group descriptors and
bitmap blocks will form a very nice, contiguous set of extents that
should be relatively compactly stored in an rbtree.  This will allow
us to make the tests done by ext4_valid_extent(),
ext4_mb_mark_diskspace_used(), and ext4_get_blocks() to be ***much***
more effective and comprehensive. 

This still doesn't answer the question of where we should be doing the
tests.  If we're trying to track down a bug, we probably want to be
doing these tests everywhere.  For performance reasons, though, my
guess is that *most* of the tests should be default disabled except
unless a mount option is given.  (Why a run-time mount option as
opposed a compile-time tests?  So that if this bug happens in the
field, a Level 3 engineer from RHEL's, SLES's, or IBM's help desk can
tell the customer to mount with this option, and track it down without
requesting that the user install a custom kernel; having done some
field work, I can tell you this will save a huge amount of
time/effort.)  

I would probably keep the tests in ext4_valid_extent() so we can test
for on-disk corruption, but we would probably want to turn off the
tests at allocation and ext4_get_blocks() for performance reasons ---
at least until someone has a chance to do some real benchmarking tests
and confirms whether or not the extra CPU utilization is visible on
say a TPC-H or TPC-C run.

						- Ted
