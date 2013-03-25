From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/7] ext4: add mutex_is_locked() assertion to ext4_truncate()
Date: Sun, 24 Mar 2013 20:06:53 -0400
Message-ID: <1364170014-10295-7-git-send-email-tytso@mit.edu>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55504 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab3CYAG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Mar 2013 20:06:57 -0400
In-Reply-To: <1364170014-10295-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ab20015..eb9a5a9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -258,8 +258,21 @@ void ext4_evict_inode(struct inode *inode)
 			     "couldn't mark inode dirty (err %d)", err);
 		goto stop_handle;
 	}
-	if (inode->i_blocks)
+	if (inode->i_blocks) {
+		/*
+		 * Since we are evicting the inode, it shouldn't be
+		 * locked.  We've added a warning which triggers if
+		 * the mutex is not locked, so take the lock even
+		 * though it's not strictly necessary.  However,
+		 * taking the lock using a simple mutex_lock() will
+		 * trigger a (false positive) lockdep warning, so take
+		 * it using a trylock.
+		 */
+		int locked = mutex_trylock(&inode->i_mutex);
 		ext4_truncate(inode);
+		if (likely(locked))
+			mutex_unlock(&inode->i_mutex);
+	}
 
 	/*
 	 * ext4_ext_truncate() doesn't reserve any slop when it
@@ -3789,6 +3802,7 @@ void ext4_truncate(struct inode *inode)
 	struct address_space *mapping = inode->i_mapping;
 	loff_t page_len;
 
+	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
 	trace_ext4_truncate_enter(inode);
 
 	if (!ext4_can_truncate(inode))
-- 
1.7.12.rc0.22.gcdd159b

