From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/34] debugfs: manage needs_recover feature when messing
 with the journal
Date: Sat, 13 Sep 2014 15:11:45 -0700
Message-ID: <20140913221145.13646.30513.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32140 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaIMWLu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:11:50 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set the needs_recover incompat feature when debugfs writes journal
transactions so that we actually replay the journal contents at the
next mount.

Likewise, clear it if we successfully recover the journal.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/do_journal.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/debugfs/do_journal.c b/debugfs/do_journal.c
index 711ed27..a17af6e 100644
--- a/debugfs/do_journal.c
+++ b/debugfs/do_journal.c
@@ -158,6 +158,8 @@ static errcode_t journal_commit_trans(journal_transaction_t *trans)
 	trans->flags &= ~J_TRANS_OPEN;
 	trans->block++;
 
+	trans->fs->super->s_feature_incompat |= EXT3_FEATURE_INCOMPAT_RECOVER;
+	ext2fs_mark_super_dirty(trans->fs);
 error:
 	if (cbh)
 		brelse(cbh);
@@ -979,4 +981,9 @@ void do_journal_run(int argc, char *argv[])
 	err = ext2fs_run_ext3_journal(&current_fs);
 	if (err)
 		com_err("journal_run", err, "while recovering journal");
+	else {
+		current_fs->super->s_feature_incompat &=
+				~EXT3_FEATURE_INCOMPAT_RECOVER;
+		ext2fs_mark_super_dirty(current_fs);
+	}
 }

