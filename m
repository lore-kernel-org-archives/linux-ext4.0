From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/37] mke2fs: set gdt csum when creating packed fs
Date: Thu, 01 May 2014 16:13:15 -0700
Message-ID: <20140501231315.31890.10293.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaEAXNT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:13:19 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're creating a fs with metadata blocks packed at the beginning
(packed_meta_blocks=1 in mke2fs.conf), set the group descriptor
checksum or else we create DOA filesystems with checksum errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 6507d0d..fd6259d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -383,6 +383,7 @@ static errcode_t packed_allocate_tables(ext2_filsys fs)
 		ext2fs_block_alloc_stats_range(fs, goal,
 					       fs->inode_blocks_per_group, +1);
 		ext2fs_inode_table_loc_set(fs, i, goal);
+		ext2fs_group_desc_csum_set(fs, i);
 	}
 	return 0;
 }

