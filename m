From: Hugh Dickins <hughd@google.com>
Subject: ext4: ext23 support leaks buffer pages
Date: Mon, 10 Jan 2011 02:54:26 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1101100242530.2000@sister.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Amir Goldstein <amir73il@users.sf.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:46104 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1AJKym (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jan 2011 05:54:42 -0500
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id p0AAsdYP018938
	for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 02:54:40 -0800
Received: from iwn6 (iwn6.prod.google.com [10.241.68.70])
	by kpbe12.cbf.corp.google.com with ESMTP id p0AAscRl024572
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 02:54:38 -0800
Received: by iwn6 with SMTP id 6so25811608iwn.15
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 02:54:38 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I switched to CONFIG_EXT4_USE_FOR_EXT23=y with 2.6.37, but was
then surprised by OOM kills: 2.6.36 and current are also bad.

Try something like this:

mkfs -t ext2 /dev/sda10
while :
do	mount /dev/sda10 /mnt
	rm -rf /mnt/linux-2.6.37
	( cd /mnt; tar xf ~hughd/linux-2.6.37.tar.bz2 )
	umount /mnt
	grep "Active(file)" /proc/meminfo
	grep buffer_head /proc/slabinfo
done

and watch Active and buffer_head grow.  Buffers remains stable,
but that's because each unmount truncates those pages from the
blockdev, yet try_to_free_buffers() cannot detach their buffer
heads because one is still "busy" (raised b_count).  Such pages
are put back on the Active(file) list, but in practice they're
unevictable by now.

ext3 behaves in the same way.  And it's no better if you don't
keep on unmounting - then you can just watch the Buffers grow,
until they cover almost the whole device (if you've enough memory).

Bisection arrives at the commit below; and reverting it
(obviously not the right solution) fixes the problem.

Hugh

commit 40389687382bf0ae71458e7c0f828137a438a956
Author: Amir G <amir73il@users.sourceforge.net>
Date:   Tue Jul 27 11:56:05 2010 -0400

    ext4: Fix block bitmap inconsistencies after a crash when deleting files
    
    We have experienced bitmap inconsistencies after crash during file
    delete under heavy load.  The crash is not file system related and I
    the following patch in ext4_free_branches() fixes the recovery
    problem.
    
    If the transaction is restarted and there is a crash before the new
    transaction is committed, then after recovery, the blocks that this
    indirect block points to have been freed, but the indirect block
    itself has not been freed and may still point to some of the free
    blocks (because of the ext4_forget()).
    
    So ext4_forget() should be called inside ext4_free_blocks() to avoid
    this problem.
    
    Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 755ba86..699d1d0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4490,27 +4490,6 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 					depth);
 
 			/*
-			 * We've probably journalled the indirect block several
-			 * times during the truncate.  But it's no longer
-			 * needed and we now drop it from the transaction via
-			 * jbd2_journal_revoke().
-			 *
-			 * That's easy if it's exclusively part of this
-			 * transaction.  But if it's part of the committing
-			 * transaction then jbd2_journal_forget() will simply
-			 * brelse() it.  That means that if the underlying
-			 * block is reallocated in ext4_get_block(),
-			 * unmap_underlying_metadata() will find this block
-			 * and will try to get rid of it.  damn, damn.
-			 *
-			 * If this block has already been committed to the
-			 * journal, a revoke record will be written.  And
-			 * revoke records must be emitted *before* clearing
-			 * this block's bit in the bitmaps.
-			 */
-			ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
-
-			/*
 			 * Everything below this this pointer has been
 			 * released.  Now let this top-of-subtree go.
 			 *
@@ -4534,8 +4513,20 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 					    blocks_for_truncate(inode));
 			}
 
+			/*
+			 * The forget flag here is critical because if
+			 * we are journaling (and not doing data
+			 * journaling), we have to make sure a revoke
+			 * record is written to prevent the journal
+			 * replay from overwriting the (former)
+			 * indirect block if it gets reallocated as a
+			 * data block.  This must happen in the same
+			 * transaction where the data blocks are
+			 * actually freed.
+			 */
 			ext4_free_blocks(handle, inode, 0, nr, 1,
-					 EXT4_FREE_BLOCKS_METADATA);
+					 EXT4_FREE_BLOCKS_METADATA|
+					 EXT4_FREE_BLOCKS_FORGET);
 
 			if (parent_bh) {
 				/*
