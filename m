From: <gregkh@suse.de>
Subject: patch ext4-fix-deadlock-in-ext4_write_begin-and-ext4_da_write_begin.patch added to 2.6.28-stable tree
Date: Thu, 12 Mar 2009 23:20:49 -0700
Message-ID: <20090313062316.D04E549045@coco.kroah.org>
References: <1236238515-8479-2-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, jack@suse.cz,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751619AbZCMGXS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 02:23:18 -0400
In-Reply-To: <1236238515-8479-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()

to the 2.6.28-stable tree.  Its filename is

    ext4-fix-deadlock-in-ext4_write_begin-and-ext4_da_write_begin.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Thu Mar 12 22:52:20 2009
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Thu,  5 Mar 2009 02:35:15 -0500
Subject: ext4: Fix deadlock in ext4_write_begin() and ext4_da_write_begin()
To: stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Message-ID: <1236238515-8479-2-git-send-email-tytso@mit.edu>


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
@@ -1347,6 +1347,10 @@ retry:
 		goto out;
 	}
 
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
+
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		ext4_journal_stop(handle);
@@ -1356,7 +1360,7 @@ retry:
 	*pagep = page;
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
-							ext4_get_block);
+				ext4_get_block);
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
@@ -2603,6 +2607,9 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
+	/* We cannot recurse into the filesystem as the transaction is already
+	 * started */
+	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {


Patches currently in stable-queue which might be from tytso@mit.edu are

queue-2.6.28/jbd2-fix-return-value-of-jbd2_journal_start_commit.patch
queue-2.6.28/revert-ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch
queue-2.6.28/jbd2-avoid-possible-null-dereference-in-jbd2_journal_begin_ordered_truncate.patch
queue-2.6.28/ext4-fix-to-read-empty-directory-blocks-correctly-in-64k.patch
queue-2.6.28/ext4-fix-lockdep-warning.patch
queue-2.6.28/ext4-initialize-preallocation-list_head-s-properly.patch
queue-2.6.28/ext4-implement-range_cyclic-in-ext4_da_writepages-instead-of-write_cache_pages.patch
queue-2.6.28/ext4-fix-null-dereference-in-ext4_ext_migrate-s-error-handling.patch
queue-2.6.28/ext4-add-fallback-for-find_group_flex.patch
queue-2.6.28/ext4-fix-deadlock-in-ext4_write_begin-and-ext4_da_write_begin.patch
