From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/25] misc: zero s_jnl_blocks when removing internal journal
Date: Mon, 08 Sep 2014 16:12:35 -0700
Message-ID: <20140908231235.25904.40254.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38987 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbaIHXMk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:12:40 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're removing the internal journal (broken journal, turning it
off, or adding an external journal), zero s_jnl_blocks so that they
can't be picked up by accident later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: TR Reardon <thomas_reardon@hotmail.com>
---
 e2fsck/journal.c       |    1 +
 lib/ext2fs/mkjournal.c |    1 +
 misc/tune2fs.c         |    1 +
 3 files changed, 3 insertions(+)


diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 16bd757..d12e317 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -549,6 +549,7 @@ static errcode_t e2fsck_journal_fix_bad_inode(e2fsck_t ctx,
 				       "filesystem is now ext2 only ***\n\n");
 			sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 			sb->s_journal_inum = 0;
+			memset(sb->s_jnl_blocks, 0, sizeof(sb->s_jnl_blocks));
 			ctx->flags |= E2F_FLAG_JOURNAL_INODE;
 			ctx->fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 			e2fsck_clear_recover(ctx, 1);
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 85f86bf..0a7cd18 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -490,6 +490,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 	fs->super->s_journal_dev = st.st_rdev;
 	memcpy(fs->super->s_journal_uuid, jsb->s_uuid,
 	       sizeof(fs->super->s_journal_uuid));
+	memset(fs->super->s_jnl_blocks, 0, sizeof(fs->super->s_jnl_blocks));
 	fs->super->s_feature_compat |= EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	ext2fs_mark_super_dirty(fs);
 	return 0;
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index c22c8fd..7292ab1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -377,6 +377,7 @@ static errcode_t remove_journal_inode(ext2_filsys fs)
 		return retval;
 	}
 	fs->super->s_journal_inum = 0;
+	memset(fs->super->s_jnl_blocks, 0, sizeof(fs->super->s_jnl_blocks));
 	ext2fs_mark_super_dirty(fs);
 
 	return 0;

