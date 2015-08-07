From: Jan Kara <jack@suse.com>
Subject: [PATCH 06/19] ext2fs: Make ext2fs_reserve_super_and_bgd() clear block_uninit flag
Date: Fri,  7 Aug 2015 12:51:16 +0200
Message-ID: <1438944689-24562-7-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbbHGKvp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:45 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext2fs_reserve_super_and_bgd() does not change group
descriptor flag showing whether a particular group block bitmap is
initialized or not. Make sure to clear this flag when modifying group's
block bitmap.

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/alloc_sb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 8788c00973df..9100ba29ef13 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -52,6 +52,11 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 				  &old_desc_blk, &new_desc_blk, &used_blks);
 
+	if (used_blks && bmap == fs->block_map) {
+		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+		ext2fs_group_desc_csum_set(fs, group);
+	}
+
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
-- 
2.1.4

