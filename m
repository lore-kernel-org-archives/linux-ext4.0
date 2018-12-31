Return-Path: <SRS0=7jnN=PI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr810107.outbound.protection.outlook.com ([40.107.81.107]:16128
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727392AbeLaTsq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 31 Dec 2018 14:48:46 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, <stable@kernel.org>
Subject: [PATCH 2/3] ext4: use ext4_write_inode() when fsyncing w/o a journal
Date: Mon, 31 Dec 2018 14:48:35 -0500
Message-ID: <20181231194836.3761-2-tytso@mit.edu>
In-Reply-To: <20181231194836.3761-1-tytso@mit.edu>
References: <20181231194836.3761-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In no-journal mode, we previously used __generic_file_fsync() in
no-journal mode.  This triggers a lockdep warning, and in addition,
it's not safe to depend on the inode writeback mechanism in the case
ext4.  We can solve both problems by calling ext4_write_inode()
directly.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/fsync.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 26a7fe5c4fd3..87a7ff00ef62 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -116,8 +116,16 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
+	ret = file_write_and_wait_range(file, start, end);
+	if (ret)
+		return ret;
+
 	if (!journal) {
-		ret = __generic_file_fsync(file, start, end, datasync);
+		struct writeback_control wbc = {
+			.sync_mode = WB_SYNC_ALL
+		};
+
+		ret = ext4_write_inode(inode, &wbc);
 		if (!ret)
 			ret = ext4_sync_parent(inode);
 		if (test_opt(inode->i_sb, BARRIER))
@@ -125,9 +133,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
-	ret = file_write_and_wait_range(file, start, end);
-	if (ret)
-		return ret;
 	/*
 	 * data=writeback,ordered:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
-- 
2.19.1
