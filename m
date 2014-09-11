From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/4] jbd2: fix journal checksum feature flag handling
Date: Wed, 10 Sep 2014 17:28:25 -0700
Message-ID: <20140911002825.10109.80519.stgit@birch.djwong.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23554 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIKA2c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 20:28:32 -0400
In-Reply-To: <20140911002818.10109.51772.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Clear all three journal checksum feature flags before turning on
whichever journal checksum options we want.  Rearrange the error
checking so that newer flags get complained about first.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: TR Reardon <thomas_reardon@hotmail.com>
---
 fs/ext4/super.c   |   11 ++++++-----
 fs/jbd2/journal.c |   16 ++++++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bbf515c..7045f1d 100644
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
