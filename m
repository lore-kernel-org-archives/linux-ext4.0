From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Revert "ext4: wait on all pending commits in ext4_sync_fs()"
Date: Mon,  2 Feb 2009 18:55:08 +0100
Message-ID: <1233597309-20233-4-git-send-email-jack@suse.cz>
References: <y>
 <1233597309-20233-1-git-send-email-jack@suse.cz>
 <1233597309-20233-2-git-send-email-jack@suse.cz>
 <1233597309-20233-3-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43328 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753230AbZBBRzN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Feb 2009 12:55:13 -0500
In-Reply-To: <1233597309-20233-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This undoes commit 14ce0cb411c88681ab8f3a4c9caa7f42e97a3184.

Since jbd2_journal_start_commit() is now fixed to return 1 when we
started a transaction commit, there's some transaction waiting to be
committed or there's a transaction already committing, we don't
need to call ext4_force_commit() in ext4_sync_fs(). Furthermore
ext4_force_commit() can unnecessarily create sync transaction which is
expensive so it's worthwhile to remove it when we can.

CC: Eric Sandeen <sandeen@redhat.com>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e5f06a5..a5732c5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3046,14 +3046,17 @@ static void ext4_write_super(struct super_block *sb)
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
 	int ret = 0;
+	tid_t target;
 
 	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
 	sb->s_dirt = 0;
 	if (EXT4_SB(sb)->s_journal) {
-		if (wait)
-			ret = ext4_force_commit(sb);
-		else
- 			jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
+		if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal,
+					      &target)) {
+			if (wait)
+				jbd2_log_wait_commit(EXT4_SB(sb)->s_journal,
+						     target);
+		}
 	} else {
 		ext4_commit_super(sb, EXT4_SB(sb)->s_es, wait);
 	}
-- 
1.6.0.2

