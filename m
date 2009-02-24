From: Theodore Ts'o <tytso@mit.edu>
Subject: [STABLE, 2.6.28.y] Revert "ext4: wait on all pending commits in ext4_sync_fs()"
Date: Tue, 24 Feb 2009 12:14:42 -0500
Message-ID: <1235495688-8044-2-git-send-email-tytso@mit.edu>
References: <1235495688-8044-1-git-send-email-tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39937 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbZBXRPJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 12:15:09 -0500
In-Reply-To: <1235495688-8044-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

This undoes commit 14ce0cb411c88681ab8f3a4c9caa7f42e97a3184.

Since jbd2_journal_start_commit() is now fixed to return 1 when we
started a transaction commit, there's some transaction waiting to be
committed or there's a transaction already committing, we don't
need to call ext4_force_commit() in ext4_sync_fs(). Furthermore
ext4_force_commit() can unnecessarily create sync transaction which is
expensive so it's worthwhile to remove it when we can.

http://bugzilla.kernel.org/show_bug.cgi?id=12224

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org
(cherry picked from commit 9eddacf9e9c03578ef2c07c9534423e823d677f8)
---
 fs/ext4/super.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d38e3e1..e522b8c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2914,15 +2914,15 @@ static void ext4_write_super(struct super_block *sb)
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
-	int ret = 0;
+	tid_t target;
 
 	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
 	sb->s_dirt = 0;
-	if (wait)
-		ret = ext4_force_commit(sb);
-	else
-		jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
-	return ret;
+	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
+		if (wait)
+			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
+	}
+	return 0;
 }
 
 /*
-- 
1.5.6.3

