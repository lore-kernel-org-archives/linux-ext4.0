From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/21] libext2fs: remove EA when inline data is less than 60
 bytes
Date: Mon, 04 Aug 2014 18:05:43 -0700
Message-ID: <20140805010543.2611.86125.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40207 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHEBFr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:47 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we write less than 60 bytes of inline data, remove the EA.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inline_data.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index b9bda50..8a71d18 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -557,6 +557,9 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	if (size <= EXT4_MIN_INLINE_DATA_SIZE) {
+		retval = ext2fs_inline_data_ea_remove(fs, ino);
+		if (retval)
+			return retval;
 		memcpy((void *)inode->i_block, buf, size);
 		return ext2fs_write_inode(fs, ino, inode);
 	}

