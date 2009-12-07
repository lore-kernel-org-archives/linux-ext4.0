From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Ext4: wait for log to commit when putting super V2.
Date: Mon, 7 Dec 2009 16:00:44 -0500
Message-ID: <20091207210044.GD8558@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935582AbZLGVAl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2009 16:00:41 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update:
-Instead of adding new logic to wait for the journal to commit, just move the
cleanup code below the journal destruction which does the same thing.  Thanks to
Eric Sandeen for the suggestion.

There is a problem where a transaction will be committing while we're unmounting
the filesystem and you will get a panic because EXT4_SB(sb)->s_group_info has
been kfree'ed in ext4_put_super.  The commit code does the callback for the
mballoc stuff to release free'ed blocks in the transaction and panic's trying to
access s_group_info.  The fix is to wait for the transaction to finish
committing before we start cleaning up the mballoc stuff.  This patch hasn't
been tested yet, but its an obvious fix.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext4/super.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d4ca92a..6721e10 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -603,10 +603,6 @@ static void ext4_put_super(struct super_block *sb)
 	if (sb->s_dirt)
 		ext4_commit_super(sb, 1);
 
-	ext4_release_system_zone(sb);
-	ext4_mb_release(sb);
-	ext4_ext_release(sb);
-	ext4_xattr_put_super(sb);
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -614,6 +610,12 @@ static void ext4_put_super(struct super_block *sb)
 			ext4_abort(sb, __func__,
 				   "Couldn't clean up the journal");
 	}
+
+	ext4_release_system_zone(sb);
+	ext4_mb_release(sb);
+	ext4_ext_release(sb);
+	ext4_xattr_put_super(sb);
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-- 
1.6.2.5

