From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4_freeze: don't return to userspace with a mutex held
Date: Mon, 29 Mar 2010 17:34:43 -0500
Message-ID: <4BB12B03.9070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab0C2Weu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 18:34:50 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2TMYmuo027416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 18:34:48 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2TMYhFc003642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 18:34:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is for RH bug 568503 - 
snapshot bug: lock held when returning to user space

ext4_freeze() does jbd2_journal_lock_updates() which takes
the j_barrier mutex, and then we return to userspace.  The
kernel does not like this:

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
lvcreate/1075 is leaving the kernel with locks still held!
1 lock held by lvcreate/1075:
 #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
jbd2_journal_lock_updates+0xe1/0xf0

I don't -think- we need to do this; by now we should have s_frozen
set, and nobody else should be coming down the pipe to get to
the journal.  However, just to be on the safe side, I added
a couple of vfs_check_frozen() calls in ext4 functions which will
arrive at start_this_handle(), which should ensure that we never
get any journal traffic generated while frozen.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(ext3 will need similar changes if this patch passes
muster on review

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..00d09f5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,6 +241,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
+	vfs_check_frozen(sb, SB_FREEZE_WRITE);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3485,8 +3486,10 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal)
+	if (journal) {
+		vfs_check_frozen(sb, SB_FREEZE_WRITE);
 		ret = ext4_journal_force_commit(journal);
+	}
 
 	return ret;
 }
@@ -3535,18 +3538,16 @@ static int ext4_freeze(struct super_block *sb)
 	 * the journal.
 	 */
 	error = jbd2_journal_flush(journal);
-	if (error < 0) {
-	out:
-		jbd2_journal_unlock_updates(journal);
-		return error;
-	}
+	if (error < 0)
+		goto out;
 
 	/* Journal blocked and flushed, clear needs_recovery flag. */
 	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	error = ext4_commit_super(sb, 1);
-	if (error)
-		goto out;
-	return 0;
+out:
+	/* we rely on s_frozen to stop further updates */
+	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	return error;
 }
 
 /*
@@ -3563,7 +3564,6 @@ static int ext4_unfreeze(struct super_block *sb)
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
 	unlock_super(sb);
-	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	return 0;
 }
 


