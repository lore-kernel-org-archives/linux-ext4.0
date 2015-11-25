From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2] tune2fs: warn if the filesystem journal is dirty
Date: Tue, 24 Nov 2015 17:07:39 -0700
Message-ID: <1448410059-3691-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Jim Garlick <garlick@llnl.gov>,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.137]:46708 "EHLO
	smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbbKYAHn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Nov 2015 19:07:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jim Garlick <garlick@llnl.gov>

Running tune2fs on a filesystem with an unrecovered journal can
cause the tune2fs settings changes in the superblock to be reverted
when the journal is replayed if it contains an uncommitted copy of
the superblock.  Print a warning if this is detected so that the
user isn't surprised if it happens.

Signed-off-by: Jim Garlick <garlick@llnl.gov>

Updated message printed to include steps to replay journal.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 misc/tune2fs.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index cd1d17f..aed0a35 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2406,6 +2406,18 @@ retry_open:
 		       ext_mount_opts);
 		free(ext_mount_opts);
 	}
+
+	/* Warn if file system needs recovery and it is opened for writing. */
+	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & EXT2_MF_MOUNTED) &&
+	    (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER)) {
+		fprintf(stderr,
+_("Warning: The journal is dirty. You may wish to replay the journal like:\n\n"
+  "\te2fsck -E journal_only %s\n\n"
+  "then rerun this command.  Otherwise, any changes made may be overwritten\n"
+  "by journal recovery.\n"), device_name);
+	}
+
 	free(device_name);
 	remove_error_table(&et_ext2_error_table);
 
-- 
1.7.3.4

