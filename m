From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext3: Don't update superblock write time when filesystem is read-only
Date: Wed, 16 Sep 2009 11:21:13 -0400
Message-ID: <1253114473-16240-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49984 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228AbZIPPVM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Sep 2009 11:21:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This avoids updating the superblock write time when we are mounting
the root file system read/only but we need to replay the journal; at
that point, for people who are east of GMT and who make their clock
tick in localtime for Windows bug-for-bug compatibility, and this will
cause e2fsck to complain and force a full file system check.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext3/super.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index a8d80a7..62c86af 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2321,7 +2321,18 @@ static int ext3_commit_super(struct super_block *sb,
 
 	if (!sbh)
 		return error;
-	es->s_wtime = cpu_to_le32(get_seconds());
+	/*
+	 * If the file system is mounted read-only, don't update the
+	 * superblock write time.  This avoids updating the superblock
+	 * write time when we are mounting the root file system
+	 * read/only but we need to replay the journal; at that point,
+	 * for people who are east of GMT and who make their clock
+	 * tick in localtime for Windows bug-for-bug compatibility,
+	 * the clock is set in the future, and this will cause e2fsck
+	 * to complain and force a full file system check.
+	 */
+	if (!(sb->s_flags & MS_RDONLY))
+		es->s_wtime = cpu_to_le32(get_seconds());
 	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
-- 
1.6.3.2.1.gb9f7d.dirty

