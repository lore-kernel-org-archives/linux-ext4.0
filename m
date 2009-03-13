From: <gregkh@suse.de>
Subject: patch ext4-add-fallback-for-find_group_flex.patch added to 2.6.28-stable tree
Date: Thu, 12 Mar 2009 23:20:49 -0700
Message-ID: <20090313062318.D9F7849047@coco.kroah.org>
References: <1236238515-8479-1-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: tytso@mit.edu, gregkh@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52196 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751665AbZCMGXU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 02:23:20 -0400
In-Reply-To: <1236238515-8479-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Add fallback for find_group_flex

to the 2.6.28-stable tree.  Its filename is

    ext4-add-fallback-for-find_group_flex.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Thu Mar 12 22:52:01 2009
From: "Theodore Ts'o" <tytso@mit.edu>
Date: Thu,  5 Mar 2009 02:35:14 -0500
Subject: ext4: Add fallback for find_group_flex
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1236238515-8479-1-git-send-email-tytso@mit.edu>

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 05bf9e839d9de4e8a094274a0a2fd07beb47eaf1)

This is a workaround for find_group_flex() which badly needs to be
replaced.  One of its problems (besides ignoring the Orlov algorithm)
is that it is a bit hyperactive about returning failure under
suspicious circumstances.  This can lead to spurious ENOSPC failures
even when there are inodes still available.

Work around this for now by retrying the search using
find_group_other() if find_group_flex() returns -1.  If
find_group_other() succeeds when find_group_flex() has failed, log a
warning message.

A better block/inode allocator that will fix this problem for real has
been queued up for the next merge window.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ialloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -703,6 +703,13 @@ struct inode *ext4_new_inode(handle_t *h
 
 	if (sbi->s_log_groups_per_flex) {
 		ret2 = find_group_flex(sb, dir, &group);
+		if (ret2 == -1) {
+			ret2 = find_group_other(sb, dir, &group);
+			if (ret2 == 0 && printk_ratelimit())
+				printk(KERN_NOTICE "ext4: find_group_flex "
+				       "failed, fallback succeeded dir %lu\n",
+				       dir->i_ino);
+		}
 		goto got_group;
 	}
 


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
