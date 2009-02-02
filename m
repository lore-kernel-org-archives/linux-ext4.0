From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Revert "ext3: wait on all pending commits in ext3_sync_fs"
Date: Mon,  2 Feb 2009 18:55:09 +0100
Message-ID: <1233597309-20233-5-git-send-email-jack@suse.cz>
References: <y>
 <1233597309-20233-1-git-send-email-jack@suse.cz>
 <1233597309-20233-2-git-send-email-jack@suse.cz>
 <1233597309-20233-3-git-send-email-jack@suse.cz>
 <1233597309-20233-4-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43330 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753169AbZBBRzN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Feb 2009 12:55:13 -0500
In-Reply-To: <1233597309-20233-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This reverts commit c87591b719737b4e91eb1a9fa8fd55a4ff1886d6.

Since journal_start_commit() is now fixed to return 1 when we
started a transaction commit, there's some transaction waiting to be
committed or there's a transaction already committing, we don't
need to call ext3_force_commit() in ext3_sync_fs(). Furthermore
ext3_force_commit() can unnecessarily create sync transaction which is
expensive so it's worthwhile to remove it when we can.

CC: Eric Sandeen <sandeen@redhat.com>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index b70d90e..4a97041 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2428,12 +2428,13 @@ static void ext3_write_super (struct super_block * sb)
 
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
 
-- 
1.6.0.2

