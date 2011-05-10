From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ext4: Block mmapped writes while the fs is frozen
Date: Wed, 11 May 2011 00:29:34 +0200
Message-ID: <1305066574-1573-4-git-send-email-jack@suse.cz>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1EJW3u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 18:29:50 -0400
In-Reply-To: <1305066574-1573-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should not allow file modification via mmap while the filesystem is
frozen. So block in ext4_page_mkwrite() while the filesystem is frozen.

We have to check for frozen filesystem with the page marked dirty and under
page lock with which we then return from ext4_page_mkwrite(). Only that way we
cannot race with writeback done by freezing code - either we mark the page
dirty after the writeback has started, see freezing in progress and block, or
writeback will wait for our page lock which is released only when the fault is
done and then writeback will writeout and writeprotect the page again.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 04b164d..a7e13b6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5801,6 +5801,12 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	get_block_t *get_block;
 	int retries = 0;
 
+restart:
+	/*
+	 * This check is racy but catches the common case. The check at the
+	 * end of this function is reliable.
+	 */
+	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -5870,5 +5876,19 @@ out_ret:
 			ret = VM_FAULT_SIGBUS;
 	}
 out:
+	/*
+	 * Freezing in progress? We check after the page is marked dirty and
+	 * with page lock held so if the test here fails, we are sure freezing
+	 * code will wait during syncing until the page fault is done - at that
+	 * point page will be dirty and unlocked so freezing code will write it
+	 * and writeprotect it again.
+	 */
+	if (ret == VM_FAULT_LOCKED) {
+		set_page_dirty(page);
+		if (inode->i_sb->s_frozen != SB_UNFROZEN) {
+			unlock_page(page);
+			goto restart;
+		}
+	}
 	return ret;
 }
-- 
1.7.1

