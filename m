From: amir73il@users.sourceforge.net
Subject: [PATCH v1 36/36] ext4: snapshot rocompat - enable rw mount
Date: Tue,  7 Jun 2011 18:08:03 +0300
Message-ID: <1307459283-22130-37-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab1FGPKf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:35 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:34 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Enable readwrite mount of filesystem with has_snapshot feature only
if ext4 was compiled with snapshot support.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 92d75c2..633a835 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1483,6 +1483,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7f15983..9a81828 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2693,6 +2693,16 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 				"must run fsck -xy to make it writable.");
 			return 0;
 		}
+	} else if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
+		/*
+		 * We get here when CONFIG_EXT4_FS_SNAPSHOT is not defined
+		 * so EXT4_SNAPSHOTS(sb) is defined to (0)
+		 */
+		ext4_msg(sb, KERN_ERR,
+			"Filesystem with has_snapshot feature cannot be "
+			"mounted RDWR without CONFIG_EXT4_FS_SNAPSHOT");
+		return 0;
 	}
 	return 1;
 }
-- 
1.7.4.1

