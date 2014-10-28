From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/3] ext4: remove extent status procfs files if journal load
 fails
Date: Mon, 27 Oct 2014 18:19:35 -0700
Message-ID: <20141028011935.30103.59038.stgit@birch.djwong.org>
References: <20141028011916.30103.50751.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46599 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaJ1BTk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 21:19:40 -0400
In-Reply-To: <20141028011916.30103.50751.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we can't load the journal, remove the procfs files for the extent
status information file to avoid leaking resources.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 96059e0..2c9e686 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3947,7 +3947,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_MMP) &&
 	    !(sb->s_flags & MS_RDONLY))
 		if (ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block)))
-			goto failed_mount3;
+			goto failed_mount3a;
 
 	/*
 	 * The first inode we look at is the journal inode.  Don't try
@@ -3956,7 +3956,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (!test_opt(sb, NOLOAD) &&
 	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
 		if (ext4_load_journal(sb, es, journal_devnum))
-			goto failed_mount3;
+			goto failed_mount3a;
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
 	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
 		ext4_msg(sb, KERN_ERR, "required journal recovery "
@@ -4244,6 +4244,7 @@ failed_mount_wq:
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
 	}
+failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
 	del_timer_sync(&sbi->s_err_report);

