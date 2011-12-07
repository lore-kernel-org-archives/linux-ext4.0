From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 01/02] ext2: reserve INCOMPAT_INLINEDATA feature flag
Date: Tue, 6 Dec 2011 17:13:51 -0700
Message-ID: <E8BB5200-9BE3-49FE-AFC2-18B2E7BBA5A8@whamcloud.com>
References: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Liang Zhen <liang@whamcloud.com>, Tao Ma <tm@tao.ma>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52685 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1LGAN4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 19:13:56 -0500
Received: by yenm1 with SMTP id m1so3530015yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2011 16:13:56 -0800 (PST)
In-Reply-To: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reserve the EXT4_FEATURE_INCOMPAT_INLINEDATA feature flag for use
with storing small file data in the i_blocks field (up to 60 bytes)
and/or the large xattr space (after i_extra_isize, up to the large
inode size).  On typical filesystems this can save 1-3% of the space,
and more importantly it also avoids seeking to read the data block.

This will become increasingly important with bigalloc filesystems,
since they consume a full cluster of blocks for each file, including
small directories that could easily fit into the inode itself.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Originally-by: Tao Ma <tm@tao.ma>
---
 lib/ext2fs/ext2_fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0f8cde8..6cf47f9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -719,6 +719,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
+#define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
-- 
1.7.2



