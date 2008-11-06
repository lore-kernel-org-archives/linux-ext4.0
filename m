From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Thu, 6 Nov 2008 11:15:59 -0500
Message-ID: <20081106161559.GA18939@mit.edu>
References: <49019EF6.4000706@rs.jp.nec.com> <20081026084048.GF3184@webber.adilger.int> <20081026084848.GA9270@infradead.org> <20081031100547.GA22093@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36020 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752772AbYKFQQG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 11:16:06 -0500
Content-Disposition: inline
In-Reply-To: <20081031100547.GA22093@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 31, 2008 at 06:05:47AM -0400, Christoph Hellwig wrote:
> > I'll hack up a generic open_by_handle and then we can gather the
> > reaction - it shouldn't be more than about one or two hundred lines of
> > code.  Note that you really want an open by handle and not just inum for
> > a defragmentation tool - without the generation you can easily run into
> > races.

I think having a generic open_by_handle is a Good Thing, but it
actually isn't quite enough for defrag, because that brings up the
question of how defrag can create the handle in the first place.  

In the case of Aryan's desire to get the list of files that were read
during boot, it's pretty obvious how we can define an interface which
would make available a set of file handles corresponding to the files
that were opened during the boot process, and then that list of file
handles can be saved to a file and used on the subsequent boot to do
the readahead.   Fairly straight forward.

In the case of the defrag situation, though, we need to step back and
figure out what we are trying to do.  What the userspace program is
apparently trying to do is to get the block extent maps used by all of
the inodes in the block group.  The problem is we aren't opening the
inodes by pathname, so we couldn't create a handle in the first place
(since in order to create a handle, we need the containing directory).

The bigger question is whether the defrag code is asking the right
question in the first place.  The issue is that is that it currently
assumes that in order to find the owner of a particular block (or more
generally, extent), you should search the inodes in the block's
blockgroup.  The problem is that for a very fragmented filesystem,
most of the blocks' owners might not be in their block group.  In
fact, over time, if you use defrag -f frequently, it will move blocks
belonging to inodes in one block group to other block groups, which
will make defrag -f's job even harder, and eventually impossible, for
inodes belonging to other block groups.

> Akira, can you please comment on these issues before going on?
> I think the generation issue is a particularly important one if you
> want to allow defrag by normal users.

I'm not at all sure that it makes sense to allow "defrag -f" to be
used by normal users.  The problem here is we're fighting multiple
constraints.  First of all, we want to keep policy in the kernel to an
absolute minimum, since debugging kernel code is a mess, and I don't
think we want the complexity of a full-fledge defragger in the kernel.
Secondly, though, if we are going to do this in userspace, we need to
push a huge amount of information to the userspace defrag program,
that immediately raises some very serious security issues, because we
don't want to leak information unduly to random userspace programs.

> > Btw, any reason the XFS approach of passing in *file descriptors* for both
> > the inode to be defragmented and the "donor" inode doesn't work for you?

I agree this is probably the better approach; it would certainly
reduce the amount of new code that needs to be added to the kernel.
Right now the "donor"/temporary inode is created and allocated in the
kernel, and then the kernel decides whether or not the temporary inode
is an improvement.  If we make the userspace code responsible for
creating the temporary inode and then using fallocate() to allocate
the new blocks, then userspace can call FIEMAP and decide whether it
is an improvement.

							- Ted

P.S. I've been looking at ext4_defrag_partial(), and the page locking
looks wrong.  The page is only locked if it it hasn't been read into
memory yet?   And at the end of the function, we do this?   

       	      if (PageLocked(page))
			unlock_page(page);
