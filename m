From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Wed, 7 Nov 2007 19:20:38 -0500
Message-ID: <20071108002037.GA7728@thunk.org>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz> <20071106194012.GE12857@thunk.org> <20071107143605.GD22214@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38029 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbXKHAVe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 19:21:34 -0500
Content-Disposition: inline
In-Reply-To: <20071107143605.GD22214@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 07, 2007 at 03:36:05PM +0100, Jan Kara wrote:
> > What if more than one application wants to use this facility?
>
>   That should be fine - let's see: Each application keeps somewhere a time when
> it started a scan of a subtree (or it can actually remember a time when it
> set the flag for each directory), during the scan, it sets the flag on
> each directory. When it wakes up to recheck the subtree it just compares
> the rtime against the stored time - if rtime is greater, subtree has been
> modified since the last scan and we recurse in it and when we are finished
> with it we set the flag. Now notice that we don't care about the flag when
> we check for changes - we care only for rtime - so if there are several
> applications interested in the same subtree, the flag just gets set more
> often and thus the update of rtime happens more often but the same scheme
> still works fine.

OK, so in this case you don't need to set rtime on the every single
file inode, but only directory inode, right?  Because you're only
using checking the rtime at the directory level, and not the flag.
And it's just as easy for you to check the rtime flag for the file's
containing directory (modulo magic vis-a-vis hard links) as the file's
inode.

I'm just really wishing that rtime and the rtime flag didn't have live
on disk, but could rather be in memory.  If you only needed to save
the directory flags and rtimes, that might actually be doable.

Note by the way that since you need to own the file/directory to set
flags, this means that only programs that are running as root or
running as the uid who owns the entire subtree will be able to use
this scheme.  One advantage of doing in kernel memory is that you
might be able to support watching a tree that is not owned by the
watcher.

>   I don't get it here - you need to scan the whole subtree and set the flag
> only during the initial scan. Later, you need to scan and set the flag only
> for directories in whose subtree something changed. Similarty rtime needs
> to be updated for each inode at most once after the scan. 

OK, so in the worst case every single file in a kernel source tree
might change after doing an extreme git checkout.  That means around
36k of files get updated.  So if you have to set/clear the rtime flag
during the checkout process 36k file inodes would have to have their
rtime flag cleared, plus 2k worth of directory inodes; but those would
probably be folded into other changes made to the inodes anyway.  But
then when trackerd goes back and scans the subtree, if you are
actually setting rtime flags for every single file inode, then that's
38k of indoes that need updating.  If you only need to set the rtime
flags for directories, that's only 2k worth of extra gratuitous inode
updates.

							- Ted
