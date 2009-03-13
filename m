From: <gregkh@suse.de>
Subject: patch ext4-fix-deadlock-in-ext4_write_begin-and-ext4_da_write_begin.patch added to 2.6.27-stable tree
Date: Thu, 12 Mar 2009 23:33:45 -0700
Message-ID: <20090313063754.7015849042@coco.kroah.org>
References: <1236238447-8341-2-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: jack@suse.cz, gregkh@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752977AbZCMGhz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 02:37:55 -0400
In-Reply-To: <1236238447-8341-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()

to the 2.6.27-stable tree.  Its filename is

    ext4-fix-deadlock-in-ext4_write_begin-and-ext4_da_write_begin.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Thu Mar 12 23:32:47 2009
From: Jan Kara <jack@suse.cz>
Date: Thu,  5 Mar 2009 02:34:07 -0500
Subject: ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()
To: stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Message-ID: <1236238447-8341-2-git-send-email-tytso@mit.edu>

From: Jan Kara <jack@suse.cz>

(cherry picked from commit ebd3610b110bbb18ea6f9f2aeed1e1068c537227)

Functions ext4_write_begin() and ext4_da_write_begin() call
grab_cache_page_write_begin() without AOP_FLAG_NOFS. Thus it
can happen that page reclaim is triggered in that function
and it recurses back into the filesystem (or some other filesystem).
But this can lead to various problems as a transaction is already
started at that point. Add the necessary flag.

http://bugzilla.kernel.org/show_bug.cgi?id=11688

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1372,6 +1372,10 @@ retry:
   		goto out;
 	}
 
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
+
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		ext4_journal_stop(handle);
@@ -1381,7 +1385,7 @@ retry:
 	*pagep = page;
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext4_get_block);
+				ext4_get_block);
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
@@ -2465,6 +2469,9 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {


Patches currently in stable-queue which might be from jack@suse.cz are

queue-2.6.27/fs-new-inode-i_state-corruption-fix.patch
queue-2.6.27/jbd2-fix-return-value-of-jbd2_journal_start_commit.patch
queue-2.6.27/revert-ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch
queue-2.6.27/jbd2-avoid-possible-null-dereference-in-jbd2_journal_begin_ordered_truncate.patch
queue-2.6.27/ext4-fix-deadlock-in-ext4_write_begin-and-ext4_da_write_begin.patch
