From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Issue in ext4 rename
Date: Thu, 2 Apr 2015 10:02:58 -0400
Message-ID: <20150402140258.GC6873@thunk.org>
References: <551D1EA3.1050202@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Joseph Qi <joseph.qi@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47000 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbbDBODC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 10:03:02 -0400
Content-Disposition: inline
In-Reply-To: <551D1EA3.1050202@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 06:49:07PM +0800, Joseph Qi wrote:
> Hi all,
> In ext4_rename_delete, it only logs a warning if ext4_delete_entry
> fails.
> IMO, it may lead to an inode with two entries (old and new), thus
> filesystem will be inconsistent.
> The case is described below:
> ext4_rename
> 	--> ext4_journal_start
> 	--> ext4_add_entry (new)
> 	--> ext4_rename_delete (old)
> 		--> ext4_delete_entry
> 			--> ext4_journal_get_write_access
> 			*failed* because of -ENOMEM
> 	--> ext4_journal_stop
> Does anyone have an idea to resolve this issue?

I'm guessing you must be using one of the kernel patches or
pre-release kernels that is allowing GFP_NOFS allocations to fail.
Currently in this case, we call ext4_std_error() which will declare
the file system as inconsistent, and either mark the file system
read/only, panic the system, or, if the error mode is set to
"continue" (what I nick name the "don't worry, be happy mode"), the
error gets ignored.  What I recommend for companies that have a large
number of disks and don't want to panic the entire system when a disk
gets marked bad is to have monitoring software which notices when a
disk gets marked inconsistent (either by scraping dmesg or by sending
a notification out via a netlink socket[1]), and then instructing the
cluster file system to declare the disk bad, and to eventually arrange
to the file system fsck'ed.

[1] At Google we have a patch which does this; I believe a version of
the patchd did get sent out to the ext4 list, but the person who
worked on it never had time to get it properly cleaned up so it could
get upstreamed, and we got lost in debates about the proper way to
handle such notifications, should they be done in the VFS, or
conflated with quota errors, etc.)  And at some point during the
interface paint-shedding, the debate stalled out.


In any case, there was a huge debate at the LSF/MM about this, where
file system engineers tried to explain to VM folks why in some cases
backing out of a memory failure is close to impossible, unless you
want to add a transaction rollback system ala an RDBMS (and suffer the
complexity and performance penalties of said RDBMS transaction
rollback mechanism).  You can read more about this at:
https://lwn.net/Articles/636017/ and https://lwn.net/Articles/636797/.

In the short term my plan was to try to create a wrapper for all
kmalloc and slab allocation requests which would allow us to track
memory used, pass in GFP_NOFAIL where necessary, and to loop in cases
where GFP_NOFAIL requests started failing (because like Dave Chinner,
I trust VM folks *this* much -->.<---).  In the jbd2 layer, this would
have to be done via some kind of optional callback system, since I
don't want to force ocfs2 to have to use this scheme if they don't
want to.

In the very short term, if you can't figure out how to fix or rollback
the patch which caused the GFP_NOFS allocations to start failing, you
could simply replace all instances of GFP_NOFS with
GFP_NOFS|GFP_NOFAIL in fs/jbd2 and fs/ext4.

Regards,

						- Ted
