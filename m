From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Reserved GDT inode: blocks vs extents
Date: Fri, 19 Sep 2014 12:36:49 -0400
Message-ID: <20140919163649.GQ26995@thunk.org>
References: <BAY406-EAS150EB9E4098E2894ADA30B7FDB40@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37815 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbaISQgw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 12:36:52 -0400
Content-Disposition: inline
In-Reply-To: <BAY406-EAS150EB9E4098E2894ADA30B7FDB40@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 19, 2014 at 11:54:39AM -0400, TR Reardon wrote:
> Hello all: there's probably a good reason for this, but I'm wondering why inode#7 (reserved GDT blocks) is always created with a block map rather than extent? 
> 
>  [see ext2fs_create_resize_inode()]

It's created using an indirect map because the on-line resizing code
in the kernel relies on it.  It's rather dependent on the structure of
the indirect block map so that the kernel knows where to fetch the
necessary blocks in each block group to extend the block group
descriptor.

So no, we can't change it.

And we do have a solution, namely the meta_bg layout which mostly
solves the problem, although at the cost of slowing down the mount
time.

But that may be moot, since one of the things that I've been
considering is to stop pinning the block group descriptors in memory,
and just start reading in memory as they are needed.  The rationale is
that for a 4TB disk, we're burning 8 MB of memory.  And if you have
two dozen disks attached to your system, then you're burning 192
megabytes of memory, which starts to fairly significant amounts of
memory, especially for bookcase NAS servers.

If I would do it all over again, knowing what we know now, I'd
probably redesign the meta_bg layout somewhat to group block group
descriptors into chunks.  But it's probably not worth it to add yet
another block group descriptor layout at this point.

Cheers,

						- Ted
