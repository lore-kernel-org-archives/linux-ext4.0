From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 36/34] misc: fix Coverity complaints
Date: Thu, 18 Sep 2014 12:09:02 -0700
Message-ID: <20140918190902.GH10150@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40381 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaIRTJJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2014 15:09:09 -0400
Content-Disposition: inline
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a few problems that Coverity picked up with error handling.

Fixes-Coverity-Bug: 1239278
Fixes-Coverity-Bug: 1239279
Fixes-Coverity-Bug: 1239280
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/journal.c |   28 +++++++++++++++-------------
 debugfs/util.c    |   22 ++++++++++++++++------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/debugfs/journal.c b/debugfs/journal.c
index 99547c9..82d5bca 100644
--- a/debugfs/journal.c
+++ b/debugfs/journal.c
@@ -657,10 +657,10 @@ void ext2fs_journal_release(ext2_filsys fs, journal_t *journal,
 	}
 	brelse(journal->j_sb_buffer);
 
-	if (fs->journal_io) {
-		if (fs && fs->io != fs->journal_io)
+	if (fs && fs->journal_io) {
+		if (fs->io != fs->journal_io)
 			io_channel_close(fs->journal_io);
-		fs->journal_io = 0;
+		fs->journal_io = NULL;
 	}
 
 #ifndef USE_INODE_IO
@@ -682,7 +682,6 @@ errcode_t ext2fs_check_ext3_journal(ext2_filsys fs)
 	journal_t *journal;
 	int recover = fs->super->s_feature_incompat &
 		EXT3_FEATURE_INCOMPAT_RECOVER;
-	int reset = 0;
 	errcode_t retval;
 
 	/* If we don't have any journal features, don't do anything more */
@@ -696,23 +695,25 @@ errcode_t ext2fs_check_ext3_journal(ext2_filsys fs)
 		return retval;
 
 	retval = ext2fs_journal_load(journal);
-	if (retval) {
-		ext2fs_journal_release(fs, journal, 0, 1);
-		return retval;
-	}
+	if (retval)
+		goto err;
 
 	/*
 	 * We want to make the flags consistent here.  We will not leave with
 	 * needs_recovery set but has_journal clear.  We can't get in a loop
 	 * with -y, -n, or -p, only if a user isn't making up their mind.
 	 */
-	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
-		return EXT2_ET_JOURNAL_FLAGS_WRONG;
+	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+		retval = EXT2_ET_JOURNAL_FLAGS_WRONG;
+		goto err;
+	}
 
 	if (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL &&
 	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) &&
-	    journal->j_superblock->s_start != 0)
-		return EXT2_ET_JOURNAL_FLAGS_WRONG;
+	    journal->j_superblock->s_start != 0) {
+		retval = EXT2_ET_JOURNAL_FLAGS_WRONG;
+		goto err;
+	}
 
 	/*
 	 * If we don't need to do replay the journal, check to see if
@@ -728,7 +729,8 @@ errcode_t ext2fs_check_ext3_journal(ext2_filsys fs)
 		mark_buffer_dirty(journal->j_sb_buffer);
 	}
 
-	ext2fs_journal_release(fs, journal, reset, 0);
+err:
+	ext2fs_journal_release(fs, journal, 0, retval ? 1 : 0);
 	return retval;
 }
 
diff --git a/debugfs/util.c b/debugfs/util.c
index 54fcdc4..af14539 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -503,6 +503,7 @@ errcode_t read_list(const char *str, blk64_t **list, size_t *len)
 	blk64_t *lst = *list;
 	size_t ln = *len;
 	char *tok, *p = optarg;
+	errcode_t retval;
 
 	while ((tok = strtok(p, ","))) {
 		blk64_t *l;
@@ -517,13 +518,19 @@ errcode_t read_list(const char *str, blk64_t **list, size_t *len)
 			y = strtoull(e + 1, NULL, 0);
 			if (errno)
 				return errno;
-		} else if (*e != 0)
-			return EINVAL;
-		if (y < x)
-			return EINVAL;
+		} else if (*e != 0) {
+			retval = EINVAL;
+			goto err;
+		}
+		if (y < x) {
+			retval = EINVAL;
+			goto err;
+		}
 		l = realloc(lst, sizeof(blk64_t) * (ln + y - x + 1));
-		if (l == NULL)
-			return ENOMEM;
+		if (l == NULL) {
+			retval = ENOMEM;
+			goto err;
+		}
 		lst = l;
 		for (; x <= y; x++)
 			lst[ln++] = x;
@@ -533,4 +540,7 @@ errcode_t read_list(const char *str, blk64_t **list, size_t *len)
 	*list = lst;
 	*len = ln;
 	return 0;
+err:
+	free(lst);
+	return retval;
 }
