From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/47] libext2fs: set BLOCK_UNINIT for non-last blockgroups
 if all blocks are free
Date: Fri, 07 Nov 2014 13:51:14 -0800
Message-ID: <20141107215114.883.46921.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35267 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:18 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
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

