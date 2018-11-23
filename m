Return-Path: <SRS0=kdxW=OC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49145 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388562AbeKXDPj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Nov 2018 22:15:39 -0500
From: Colin King <colin.king@canonical.com>
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: clean up indentation issues, remove extraneous tabs
Date: Fri, 23 Nov 2018 16:30:43 +0000
Message-Id: <20181123163043.14178-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There are several lines that are indented too far, clean these
up by removing the tabs.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/migrate.c | 12 ++++++------
 fs/ext4/super.c   |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 61a9d1927817..5ae61cd8c5c9 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -535,22 +535,22 @@ int ext4_ext_migrate(struct inode *inode)
 	if (i_data[EXT4_IND_BLOCK]) {
 		retval = update_ind_extent_range(handle, tmp_inode,
 				le32_to_cpu(i_data[EXT4_IND_BLOCK]), &lb);
-			if (retval)
-				goto err_out;
+		if (retval)
+			goto err_out;
 	} else
 		lb.curr_block += max_entries;
 	if (i_data[EXT4_DIND_BLOCK]) {
 		retval = update_dind_extent_range(handle, tmp_inode,
 				le32_to_cpu(i_data[EXT4_DIND_BLOCK]), &lb);
-			if (retval)
-				goto err_out;
+		if (retval)
+			goto err_out;
 	} else
 		lb.curr_block += max_entries * max_entries;
 	if (i_data[EXT4_TIND_BLOCK]) {
 		retval = update_tind_extent_range(handle, tmp_inode,
 				le32_to_cpu(i_data[EXT4_TIND_BLOCK]), &lb);
-			if (retval)
-				goto err_out;
+		if (retval)
+			goto err_out;
 	}
 	/*
 	 * Build the last extent
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5603a4a1a864..15fc71398747 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1940,7 +1940,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 #ifdef CONFIG_FS_DAX
 		ext4_msg(sb, KERN_WARNING,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
-			sbi->s_mount_opt |= m->mount_opt;
+		sbi->s_mount_opt |= m->mount_opt;
 #else
 		ext4_msg(sb, KERN_INFO, "dax option not supported");
 		return -1;
-- 
2.19.1
