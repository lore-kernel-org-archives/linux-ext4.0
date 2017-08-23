From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] mke2fs: automatically use 256 byte inodes if project feature enabled
Date: Wed, 23 Aug 2017 11:42:07 -0400
Message-ID: <20170823154210.8756-2-tytso@mit.edu>
References: <20170823154210.8756-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45872 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754154AbdHWPmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Aug 2017 11:42:18 -0400
In-Reply-To: <20170823154210.8756-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the inode size is not implicitly requested on the command line, and
it is too small to support the project feature, automatically promote
the inode size to be 256 bytes so that the project feature will work.

Note the previous test to check for a too-small inode size didn't work
because it checked before inode size was set in fs_param.  Hence, it
was possible to create file systems with a 128 byte inode and the
project feature enabled.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/mke2fs.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index b8d078a0a..7fd7fae40 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2319,6 +2319,26 @@ profile_error:
 			(unsigned long long) fs_blocks_count);
 	}
 
+	if (quotatype_bits & QUOTA_PRJ_BIT)
+		ext2fs_set_feature_project(&fs_param);
+
+	if (ext2fs_has_feature_project(&fs_param)) {
+		quotatype_bits |= QUOTA_PRJ_BIT;
+		if (inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
+			com_err(program_name, 0,
+				_("%d byte inodes are too small for "
+				  "project quota"),
+				inode_size);
+			exit(1);
+		}
+		if (inode_size == 0) {
+			inode_size = get_int_from_profile(fs_types,
+							  "inode_size", 0);
+			if (inode_size <= EXT2_GOOD_OLD_INODE_SIZE*2)
+				inode_size = EXT2_GOOD_OLD_INODE_SIZE*2;
+		}
+	}
+
 	/* Don't allow user to set both metadata_csum and uninit_bg bits. */
 	if (ext2fs_has_feature_metadata_csum(&fs_param) &&
 	    ext2fs_has_feature_gdt_csum(&fs_param))
@@ -2419,19 +2439,6 @@ profile_error:
 		exit(1);
 	}
 
-	/*
-	 * If inode size is 128 and project quota is enabled, we need
-	 * to notify users that project ID will never be useful.
-	 */
-	if (ext2fs_has_feature_project(&fs_param) &&
-	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
-		com_err(program_name, 0,
-			_("%d byte inodes are too small for project quota; "
-			  "specify larger size"),
-			fs_param.s_inode_size);
-		exit(1);
-	}
