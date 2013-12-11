From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 40/74] libext2fs: no need to clear BLOCK_UNINIT during
 ext2fs_reserve_super_and_bgd
Date: Tue, 10 Dec 2013 17:22:46 -0800
Message-ID: <20131211012246.30655.88212.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43216 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3LKBWy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:54 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the beginning of the uninit_bg feature, the kernel[1] and
e2fsck[2] have always been careful to detect the presence of the
BLOCK_UNINIT flag, and compute a block bitmap with any group metadata
blocks marked in that bitmap.  With that in mind, I think it's safe to
say that this is a design feature of uninit_bg.

Now that we've trained libext2fs to have this same behavior whenever
it's loading a block bitmap, we no longer need to unset BLOCK_UNINIT
for a group that contains only its own group metadata -- kernel,
e2fsck, and e2fsprogs will handle this correctly.

[1] kernel git 717d50e4971b81b96c0199c91cdf0039a8cb181a
    "Ext4: Uninitialized Block Groups"
[2] e2fsprogs git f5fa20078bfc05b554294fe9c5505375d7913e8c
    "Add support for EXT2_FEATURE_COMPAT_LAZY_BG"

Reported-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc_sb.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 223ec51..8788c00 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -65,8 +65,6 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 		ext2fs_mark_block_bitmap2(bmap, 0);
 
 	if (old_desc_blk) {
-		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
-			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		num_blocks = old_desc_blocks;
 		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
 			num_blocks = ext2fs_blocks_count(fs->super) -

