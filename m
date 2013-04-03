From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: ext4 dev branch: mutex not locked in ext4_truncate()
Date: Wed, 3 Apr 2013 16:41:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304031503470.10110@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab3DCOlK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 10:41:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

there is a problem with your patch:

32d90a241a44d22ebc5289d2a2561691fc2d1351

because there is one more case where we might call ext4_truncate()
without i_mutex locked - from ext4_symlink(). Because we might be
calling __page_symlink() and it will call ext4_write_begin(). In
possible error case (ENOSPC for example) we might want to truncate
everything which might have been instantiated past i_size, however
at that point we're not holding i_mutex because there is no point in
doing so - the inode can not be possibly held by anyone else.

My proposal is to only check whether the mutex is locked if the
inode is _not_ new or is _not_ being freed.

There is a quick&dirty patch and it seems to be working well so
far. Let me know if you prefer standalone patch, or if you'll
include it into your commit.

Another possibility is to drop the commit
32d90a241a44d22ebc5289d2a2561691fc2d1351 entirely.

Thanks!
-Lukas

--- 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a36ca99..70b5c18 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -255,21 +255,8 @@ void ext4_evict_inode(struct inode *inode)
 			     "couldn't mark inode dirty (err %d)", err);
 		goto stop_handle;
 	}
-	if (inode->i_blocks) {
-		/*
-		 * Since we are evicting the inode, it shouldn't be
-		 * locked.  We've added a warning which triggers if
-		 * the mutex is not locked, so take the lock even
-		 * though it's not strictly necessary.  However,
-		 * taking the lock using a simple mutex_lock() will
-		 * trigger a (false positive) lockdep warning, so take
-		 * it using a trylock.
-		 */
-		int locked = mutex_trylock(&inode->i_mutex);
+	if (inode->i_blocks)
 		ext4_truncate(inode);
-		if (likely(locked))
-			mutex_unlock(&inode->i_mutex);
-	}
 
 	/*
 	 * ext4_ext_truncate() doesn't reserve any slop when it
@@ -3690,7 +3677,13 @@ void ext4_truncate(struct inode *inode)
 	handle_t *handle;
 	struct address_space *mapping = inode->i_mapping;
 
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
+	/*
+	 * There is a possibility that we're either freeing the inode
+	 * or it completely new indode. In those cases we might not
+	 * have i_mutex locked because it's not necessary.
+	 */
+	if (!(inode->i_state & (I_NEW|I_FREEING)))
+		WARN_ON(!mutex_is_locked(&inode->i_mutex));
 	trace_ext4_truncate_enter(inode);
 
 	if (!ext4_can_truncate(inode))
