From: Theodore Tso <tytso@mit.edu>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 16:10:04 -0400
Message-ID: <20080813201004.GJ8232@mit.edu>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, mail@eworm.de
To: eworm@lugor.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39196 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751871AbYHMUKH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 16:10:07 -0400
Content-Disposition: inline
In-Reply-To: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 08:28:18PM +0200, eworm@lugor.de wrote:
> 
> After mounting the partitions and logging in it took half a minute to hang
> the system (or at least freeze all applications that access the fs). The
> log contains the following:
> 
> kernel BUG at fs/ext4/mballoc.c:3963!

This means that we tried to truncate/delete a file while there were
still blocks on i_prealloc_list.  I think I see the problem.  And the
reason why we haven't noticed it is that it only shows up if you have
an indirect block-based file, and you truncate it when you have
previously been writing to it (so i_prealloc_list is not empty).

The problem is that we call ext4_discard_reservation() too late, after
we've started calling ext4_free_branches(), which calls
ext4_free_blocks(), which ultimately calls
ext4_mb_return_to_preallocation(), which is what is BUG-checking.

Can you reproduce the bug?  Things are a little busy on my end, so I
don't have time to try to create a reproducer and test the patch, at
least not for a day or so.  The following patch passes the "It Builds,
Ship It!" test, but not much else.  :-) 

If you could report (a) whether or not you can reproduce the failure,
and (b) whether this patch fixes things, I would be most grateful.

Thanks, regards,

							- Ted

commit b86b40e630893e74d3259f129060cfcb115f7fb9
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Aug 13 16:07:32 2008 -0400

    ext4: Fix potential truncate BUG due to i_prealloc_list being non-empty
    
    We need to call ext4_discard_reservation() earlier in ext4_truncate(),
    to avoid a BUG() in ext4_mb_return_to_preallocation(), which is called
    (ultimately) by ext4_free_blocks().  So we must ditch the blocks on
    i_prealloc_list before we start freeing the data blocks.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 368ec6b..7f7b0c5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3512,6 +3512,9 @@ void ext4_truncate(struct inode *inode)
 	 * modify the block allocation tree.
 	 */
 	down_write(&ei->i_data_sem);
+
+	ext4_discard_reservation(inode);
+
 	/*
 	 * The orphan list entry will now protect us from any crash which
 	 * occurs before the truncate completes, so it is now safe to propagate
@@ -3581,8 +3584,6 @@ do_indirects:
 		;
 	}
 
-	ext4_discard_reservation(inode);
