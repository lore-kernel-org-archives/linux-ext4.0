From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 11/12] mke2fs: ea_inode is not supported for hurd
Date: Mon, 26 Jun 2017 06:43:47 -0700
Message-ID: <20170626134348.1240-11-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35902 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdFZNoR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:17 -0400
Received: by mail-pf0-f172.google.com with SMTP id q86so721791pfl.3
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:17 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Extended attribute inodes store their refcount in inode.l_i_version
field which is not available for Hurd. Fail mke2fs for this
combination.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 misc/mke2fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 1ef46f44f35d..85d88edc2375 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1992,6 +1992,7 @@ profile_error:
 		ext2fs_clear_feature_filetype(&fs_param);
 		ext2fs_clear_feature_huge_file(&fs_param);
 		ext2fs_clear_feature_metadata_csum(&fs_param);
+		ext2fs_clear_feature_ea_inode(&fs_param);
 	}
 	edit_feature(fs_features ? fs_features : tmp,
 		     &fs_param.s_feature_compat);
@@ -2017,6 +2018,11 @@ profile_error:
 						"metadata_csum feature.\n"));
 			exit(1);
 		}
+		if (ext2fs_has_feature_ea_inode(&fs_param)) {
+			fprintf(stderr, "%s", _("The HURD does not support the "
+						"ea_inode feature.\n"));
+			exit(1);
+		}
 	}
 
 	/* Get the hardware sector sizes, if available */
-- 
2.13.1.611.g7e3b11ae1-goog
