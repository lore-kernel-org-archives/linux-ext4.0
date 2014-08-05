From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/21] libext2fs: strict inline data overwrite should not
 return ENOSPC
Date: Mon, 04 Aug 2014 18:05:36 -0700
Message-ID: <20140805010536.2611.51390.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40199 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHEBFm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:42 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're doing a strict overwrite (same data size) of data in an
inline data file, we should be able to skip the size check.  If the
in-core EA representation is fine but the on-disk EA is slightly
corrupt (this happens when fixing minor errors in an inline dir), the
ext2fs_xattr_inode_max_size() call, which reads the disk EA, can lead
us to think that there's no space when in reality there is no issue
with doing a strict overwrite.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inline_data.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index c188d75..b9bda50 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -574,7 +574,8 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	else
 		free_inode_size = 0;
 
-	if (size > existing_size + free_ea_size + free_inode_size)
+	if (size != existing_size &&
+	    size > existing_size + free_ea_size + free_inode_size)
 		return EXT2_ET_INLINE_DATA_NO_SPACE;
 
 	memcpy((void *)inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);

