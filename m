From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/39] libext2fs: set BLOCK_UNINIT for non-last blockgroups
 if all blocks are free
Date: Mon, 27 Oct 2014 16:27:56 -0700
Message-ID: <20141027232756.GC10057@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205825.532.62162.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50543 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaJ0X2D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 19:28:03 -0400
Content-Disposition: inline
In-Reply-To: <20141025205825.532.62162.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set BLOCK_UNINIT in any group whose blocks are all unused, so long as
it isn't the last group.  This helps us speed up future e2fsck runs
and mounts because we don't need to read or checksum block bitmaps for
these groups.

v2: Take care of this in the library, since e2fsck always updates these
summary counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/csum.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 12f6fe9..6dcefb9 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -854,6 +854,11 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 		__u32 old_unused = ext2fs_bg_itable_unused(fs, i);
 		__u32 old_flags = ext2fs_bg_flags(fs, i);
 		__u32 old_free_inodes_count = ext2fs_bg_free_inodes_count(fs, i);
+		__u32 old_free_blocks_count = ext2fs_bg_free_blocks_count(fs, i);
+
+		if (old_free_blocks_count == sb->s_blocks_per_group &&
+		    i != fs->group_desc_count - 1)
+			ext2fs_bg_flags_set(fs, i, EXT2_BG_BLOCK_UNINIT);
 
 		if (old_free_inodes_count == sb->s_inodes_per_group) {
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT);
