From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] jbd2: fix journal checksum feature flag handling
Date: Mon, 8 Sep 2014 12:42:21 -0700
Message-ID: <20140908194221.GD10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23609 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaIHTm2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 15:42:28 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Clear all three journal checksum feature flags before turning on
whichever journal checksum options we want.  Rearrange the error
checking so that newer flags get complained about first.

This fixes a bug in commit db9ee220361 ("jbd2: fix descriptor block
size handling errors with journal_csum") reported by Mr. Reardon.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: TR Reardon <thomas_reardon@hotmail.com>
---
 fs/ext4/super.c   |   11 ++++++-----
 fs/jbd2/journal.c |   16 ++++++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b28b36..aff945d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3190,6 +3190,10 @@ static int set_journal_csum_feature_set(struct super_block *sb)
 		incompat = 0;
 	}
 
+	jbd2_journal_clear_features(sbi->s_journal,
+			JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+			JBD2_FEATURE_INCOMPAT_CSUM_V3 |
+			JBD2_FEATURE_INCOMPAT_CSUM_V2);
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 		ret = jbd2_journal_set_features(sbi->s_journal,
 				compat, 0,
@@ -3202,11 +3206,8 @@ static int set_journal_csum_feature_set(struct super_block *sb)
 		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
 				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
 	} else {
-		jbd2_journal_clear_features(sbi->s_journal,
-				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT |
-				JBD2_FEATURE_INCOMPAT_CSUM_V3 |
-				JBD2_FEATURE_INCOMPAT_CSUM_V2);
+		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
 	}
 
 	return ret;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 19d74d8..7e70cd5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1522,14 +1522,6 @@ static int journal_get_superblock(journal_t *journal)
 		goto out;
 	}
 
-	if (jbd2_journal_has_csum_v2or3(journal) &&
-	    JBD2_HAS_COMPAT_FEATURE(journal, JBD2_FEATURE_COMPAT_CHECKSUM)) {
-		/* Can't have checksum v1 and v2 on at the same time! */
-		printk(KERN_ERR "JBD2: Can't enable checksumming v1 and v2 "
-		       "at the same time!\n");
-		goto out;
-	}
