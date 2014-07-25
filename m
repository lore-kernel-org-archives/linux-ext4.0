From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/24] e2fsck: reserve blocks for root/lost+found
 directory repair
Date: Fri, 25 Jul 2014 13:19:11 -0700
Message-ID: <20140725201911.GJ8628@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225422.31374.22565.stgit@birch.djwong.org>
 <20140725121253.GH1865@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32048 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaGYUTR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 16:19:17 -0400
Content-Disposition: inline
In-Reply-To: <20140725121253.GH1865@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 08:12:53AM -0400, Theodore Ts'o wrote:
> On Fri, Jul 18, 2014 at 03:54:22PM -0700, Darrick J. Wong wrote:
> > If we think we're going to need to repair either the root directory or
> > the lost+found directory, reserve a block at the end of pass 1 to
> > reduce the likelihood of an e2fsck abort while reconstructing
> > root/lost+found during pass 3.
> 
> Can you say more about when this situation arises?  The only thing I
> can think of is if there are a large number of blocks that need to be
> cloned during passes 1b/c/d?

Yep, that's one of the scenarios that this patch fixes -- if / is corrupt and
duplicate processing allocates all the free blocks in the FS, we end up with an
unfixable FS -- there's a big file somewhere, but no directory structure; the
only way to repair would be to run debugfs -w to find and delete files, and
re-run e2fsck.  Granted, in this situation, you'd end up in a nasty loop of
running fsck, mounting the FS long enough to delete a big file or two,
unmounting, and rerunning fsck, but that's less troublesome than mucking with
debugfs.

This wasn't actually how I found the bug.  What really happened was that I
corrupted an extent in a directory such that the lblk was a really huge number.
The directory processing code would then try to "fill in" the "hole" by
allocating tons of blocks, typically until there weren't any free blocks left.
Then, any attempt to repair / or /lost+found would abort because there weren't
any free blocks.  Of course, this behavior is fixed by patch #18, so it's no
longer a good reproducer.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
