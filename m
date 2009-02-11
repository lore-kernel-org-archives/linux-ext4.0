From: akpm@linux-foundation.org
Subject: [patch 08/24] ext3: revert "ext3: wait on all pending commits in ext3_sync_fs"
Date: Wed, 11 Feb 2009 13:04:26 -0800
Message-ID: <200902112104.n1BL4Qgg031738@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136AbZBKVEr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 16:04:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

This reverts commit c87591b719737b4e91eb1a9fa8fd55a4ff1886d6.

Since journal_start_commit() is now fixed to return 1 when we started a
transaction commit, there's some transaction waiting to be committed or
there's a transaction already committing, we don't need to call
ext3_force_commit() in ext3_sync_fs().  Furthermore ext3_force_commit()
can unnecessarily create sync transaction which is expensive so it's
worthwhile to remove it when we can.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/ext3/super.c~revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs fs/ext3/super.c
--- a/fs/ext3/super.c~revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs
+++ a/fs/ext3/super.c
@@ -2428,12 +2428,13 @@ static void ext3_write_super (struct sup
 
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
-	sb->s_dirt = 0;
-	if (wait)
-		ext3_force_commit(sb);
-	else
-		journal_start_commit(EXT3_SB(sb)->s_journal, NULL);
+	tid_t target;
 
+	sb->s_dirt = 0;
+	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
+		if (wait)
+			log_wait_commit(EXT3_SB(sb)->s_journal, target);
+	}
 	return 0;
 }
 
_
